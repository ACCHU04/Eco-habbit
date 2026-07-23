import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/empty_state.dart';
import 'package:mobile_app/features/community/models/post.dart';
import 'package:mobile_app/features/community/models/community_filter.dart';
import 'package:mobile_app/features/community/providers/community_provider.dart';
import 'package:mobile_app/features/community/data/community_repository.dart';
import 'package:mobile_app/core/widgets/notifications_badge.dart';

class CommunityFeedScreen extends ConsumerStatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  ConsumerState<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends ConsumerState<CommunityFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(communityFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(communityFeedProvider);
    final currentFilter = ref.watch(communityFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          NotificationsBadge(
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.push('/notifications'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: currentFilter.postType == null,
                  onTap: () {
                    ref.read(communityFilterProvider.notifier).state = const CommunityFilter();
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'DIY',
                  selected: currentFilter.postType == 'diy',
                  onTap: () {
                    ref.read(communityFilterProvider.notifier).state = const CommunityFilter(postType: 'diy');
                  },
                  icon: Icons.build,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Tips',
                  selected: currentFilter.postType == 'tip',
                  onTap: () {
                    ref.read(communityFilterProvider.notifier).state = const CommunityFilter(postType: 'tip');
                  },
                  icon: Icons.lightbulb,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Market',
                  selected: currentFilter.postType == 'marketplace',
                  onTap: () {
                    ref.read(communityFilterProvider.notifier).state = const CommunityFilter(postType: 'marketplace');
                  },
                  icon: Icons.storefront,
                ),
              ],
            ),
          ),
          Expanded(
            child: feedAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: $e'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(communityFeedProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (paginated) {
                if (paginated.posts.isEmpty) {
                  return const EmptyState(
                    icon: Icons.forum_outlined,
                    title: 'No posts yet',
                    subtitle: 'Be the first to share something with the community',
                    actionLabel: 'Create Post',
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: paginated.posts.length + (paginated.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
              if (index == paginated.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                    }
                    final post = paginated.posts[index];
                    return _PostCard(
                      post: post,
                      onTap: () => context.push('/community/post/${post.id}'),
                      onLike: () => _toggleLike(post),
                      onReport: () => _showReportDialog(context, post),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-post'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _toggleLike(Post post) async {
    final repo = ref.read(communityRepositoryProvider);
    final previousIsLiked = post.isLiked;
    final previousLikesCount = post.likesCount;

    ref.read(communityFeedProvider.notifier).toggleLike(
      post.id,
      isCurrentlyLiked: post.isLiked,
      currentLikesCount: post.likesCount,
    );

    try {
      await repo.likePost(post.id);
    } catch (e) {
      ref.read(communityFeedProvider.notifier).toggleLike(
        post.id,
        isCurrentlyLiked: previousIsLiked,
        currentLikesCount: previousLikesCount - 1,
      );
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update like')),
        );
      }
    }
  }

  void _showReportDialog(BuildContext context, Post post) {
    final reasons = [
      ('spam', 'Spam', Icons.report_outlined),
      ('inappropriate', 'Inappropriate', Icons.warning),
      ('scam', 'Scam', Icons.shield),
      ('other', 'Other', Icons.more_horiz),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: reasons.map((r) => ListTile(
            leading: Icon(r.$3),
            title: Text(r.$2),
            onTap: () async {
              Navigator.pop(context);
              try {
                await ref.read(communityRepositoryProvider).reportContent(
                  CreateReportRequest(
                    contentType: 'post',
                    contentId: post.id,
                    reason: r.$1,
                  ),
                );
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report submitted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to submit report')),
                  );
                }
              }
            },
          )).toList(),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: selected ? Colors.white : Colors.grey[600]),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onReport;

  const _PostCard({
    required this.post,
    required this.onTap,
    required this.onLike,
    required this.onReport,
  });

  Color get _typeColor {
    switch (post.postType) {
      case 'diy':
        return Colors.orange;
      case 'tip':
        return Colors.blue;
      case 'marketplace':
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }

  String get _typeLabel {
    switch (post.postType) {
      case 'diy':
        return 'DIY';
      case 'tip':
        return 'Tip';
      case 'marketplace':
        return 'Marketplace';
      default:
        return 'Post';
    }
  }

  IconData get _typeIcon {
    switch (post.postType) {
      case 'diy':
        return Icons.build;
      case 'tip':
        return Icons.lightbulb;
      case 'marketplace':
        return Icons.storefront;
      default:
        return Icons.article;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _typeColor.withValues(alpha: 0.1),
                    child: Text(
                      post.author.initials,
                      style: TextStyle(
                        color: _typeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Text(
                          _timeAgo(post.createdAt),
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_typeIcon, size: 12, color: _typeColor),
                        const SizedBox(width: 4),
                        Text(
                          _typeLabel,
                          style: TextStyle(color: _typeColor, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'report') onReport();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'report', child: Text('Report')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(post.content, style: const TextStyle(fontSize: 14, height: 1.4)),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(
                          post.isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: post.isLiked ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.likesCount}',
                          style: TextStyle(color: post.isLiked ? Colors.red : Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onTap,
                    child: Row(
                      children: [
                        Icon(Icons.comment_outlined, size: 18, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text('${post.commentsCount}', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.share_outlined, size: 18, color: Colors.grey[500]),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
