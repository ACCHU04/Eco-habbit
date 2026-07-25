import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/utils/time_ago.dart';
import 'package:mobile_app/core/widgets/eco_post_card.dart' show EcoPostCard;
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
  final Set<String> _bookmarkedIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
    _loadBookmarks();
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

  Future<void> _loadBookmarks() async {
    try {
      final result = await ref.read(communityRepositoryProvider).getBookmarks();
      if (mounted) {
        setState(() {
          for (final post in result.posts) {
            _bookmarkedIds.add(post.id);
          }
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(communityFeedProvider);
    final currentFilter = ref.watch(communityFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/community/search'),
          ),
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
                  selected: currentFilter.postType == PostType.diy.value,
                  onTap: () {
                    ref.read(communityFilterProvider.notifier).state = const CommunityFilter(postType: 'diy');
                  },
                  icon: Icons.build,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Tips',
                  selected: currentFilter.postType == PostType.tip.value,
                  onTap: () {
                    ref.read(communityFilterProvider.notifier).state = const CommunityFilter(postType: 'tip');
                  },
                  icon: Icons.lightbulb,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Market',
                  selected: currentFilter.postType == PostType.marketplace.value,
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
              loading: () => _buildSkeletonList(),
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
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(communityFeedProvider),
                  child: ListView.builder(
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EcoPostCard(
                          authorName: post.author.fullName,
                          authorAvatarUrl: post.author.profilePhoto,
                          content: post.content,
                          postType: post.postType,
                          likes: post.likesCount,
                          comments: post.commentsCount,
                          timeAgo: timeAgo(post.createdAt),
                          isLiked: post.isLiked,
                          isBookmarked: _bookmarkedIds.contains(post.id),
                          imageUrls: post.imageUrls,
                          onTap: () => context.push('/community/post/${post.id}'),
                          onLike: () => _toggleLike(post),
                          onBookmark: () => _toggleBookmark(post.id),
                          onLongPress: () => _showReportDialog(context, post),
                        ),
                      );
                    },
                  ),
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

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundColor: Colors.grey[300]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 12, width: 120, color: Colors.grey[300]),
                        const SizedBox(height: 4),
                        Container(height: 10, width: 60, color: Colors.grey[200]),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 14, width: double.infinity, color: Colors.grey[200]),
              const SizedBox(height: 4),
              Container(height: 14, width: 200, color: Colors.grey[200]),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleLike(Post post) async {
    ref.read(communityFeedProvider.notifier).toggleLike(post.id);

    try {
      await ref.read(communityRepositoryProvider).likePost(post.id);
    } catch (e) {
      ref.read(communityFeedProvider.notifier).toggleLike(post.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update like')),
        );
      }
    }
  }

  void _toggleBookmark(String postId) async {
    final wasBookmarked = _bookmarkedIds.contains(postId);
    setState(() {
      if (wasBookmarked) {
        _bookmarkedIds.remove(postId);
      } else {
        _bookmarkedIds.add(postId);
      }
    });

    try {
      await ref.read(communityRepositoryProvider).toggleBookmark(postId);
    } catch (e) {
      setState(() {
        if (wasBookmarked) {
          _bookmarkedIds.add(postId);
        } else {
          _bookmarkedIds.remove(postId);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update bookmark')),
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
              final ctx = context;
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
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Report submitted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(ctx).showSnackBar(
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
