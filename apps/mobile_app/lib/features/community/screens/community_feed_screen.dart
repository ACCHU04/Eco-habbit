import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/empty_state.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  final List<_MockPost> _posts = [
    _MockPost(
      id: '1',
      author: 'Priya M.',
      avatar: 'PM',
      type: 'diy',
      content:
          'Turned old jeans into a tote bag! Used the DIY Studio guide - took about 2 hours. Here are the before/after photos.',
      likes: 24,
      comments: 8,
      timeAgo: '2h ago',
    ),
    _MockPost(
      id: '2',
      author: 'Rahul K.',
      avatar: 'RK',
      type: 'tip',
      content:
          'Pro tip: Before throwing away electronics, check if your campus has an e-waste collection point. Most colleges do!',
      likes: 42,
      comments: 15,
      timeAgo: '5h ago',
    ),
    _MockPost(
      id: '3',
      author: 'Aisha S.',
      avatar: 'AS',
      type: 'marketplace',
      content:
          'Listing my 2nd year textbooks at 50% off. All in great condition. DM me if interested!',
      likes: 12,
      comments: 6,
      timeAgo: '1d ago',
    ),
    _MockPost(
      id: '4',
      author: 'Campus Green Club',
      avatar: 'CG',
      type: 'diy',
      content:
          'Check out this amazing planter made from recycled plastic bottles. Perfect for your dorm room!',
      likes: 67,
      comments: 23,
      timeAgo: '2d ago',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _selectedFilter == 'all'
        ? _posts
        : _posts.where((p) => p.type == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
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
                  selected: _selectedFilter == 'all',
                  onTap: () => setState(() => _selectedFilter = 'all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'DIY',
                  selected: _selectedFilter == 'diy',
                  onTap: () => setState(() => _selectedFilter = 'diy'),
                  icon: Icons.build,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Tips',
                  selected: _selectedFilter == 'tip',
                  onTap: () => setState(() => _selectedFilter = 'tip'),
                  icon: Icons.lightbulb,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Market',
                  selected: _selectedFilter == 'marketplace',
                  onTap: () =>
                      setState(() => _selectedFilter = 'marketplace'),
                  icon: Icons.storefront,
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredPosts.isEmpty
                ? const EmptyState(
                    icon: Icons.forum_outlined,
                    title: 'No posts yet',
                    subtitle: 'Be the first to share something with the community',
                    actionLabel: 'Create Post',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      return _PostCard(
                        post: post,
                        onTap: () => context.push('/community/post/${post.id}'),
                        onLike: () => setState(() => post.liked = !post.liked),
                        onReport: () => _showReportDialog(context, post),
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

  void _showReportDialog(BuildContext context, _MockPost post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.spam),
              title: const Text('Spam'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Inappropriate'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Scam'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.more_horiz),
              title: const Text('Other'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
            ),
          ],
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
  final _MockPost post;
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
    switch (post.type) {
      case 'diy':
        return Colors.orange;
      case 'tip':
        return Colors.blue;
      case 'marketplace':
        return AppColors.primary;
    }
  }

  String get _typeLabel {
    switch (post.type) {
      case 'diy':
        return 'DIY';
      case 'tip':
        return 'Tip';
      case 'marketplace':
        return 'Marketplace';
    }
  }

  IconData get _typeIcon {
    switch (post.type) {
      case 'diy':
        return Icons.build;
      case 'tip':
        return Icons.lightbulb;
      case 'marketplace':
        return Icons.storefront;
    }
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
                    backgroundColor: _typeColor.withOpacity(0.1),
                    child: Text(
                      post.avatar,
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
                          post.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          post.timeAgo,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_typeIcon, size: 12, color: _typeColor),
                        const SizedBox(width: 4),
                        Text(
                          _typeLabel,
                          style: TextStyle(
                            color: _typeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
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
              Text(
                post.content,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(
                          post.liked ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: post.liked ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.likes + (post.liked ? 1 : 0)}',
                          style: TextStyle(
                            color: post.liked ? Colors.red : Colors.grey,
                            fontSize: 13,
                          ),
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
                        Text(
                          '${post.comments}',
                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
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

class _MockPost {
  final String id;
  final String author;
  final String avatar;
  final String type;
  final String content;
  final int likes;
  final int comments;
  final String timeAgo;
  bool liked;

  _MockPost({
    required this.id,
    required this.author,
    required this.avatar,
    required this.type,
    required this.content,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    this.liked = false,
  });
}
