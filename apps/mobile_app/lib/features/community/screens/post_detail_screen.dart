import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/utils/time_ago.dart';
import 'package:mobile_app/features/community/providers/community_provider.dart';
import 'package:mobile_app/features/community/data/community_repository.dart';
import 'package:mobile_app/features/community/models/post.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmittingComment = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postDetailProvider(widget.postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'report') {
                await _reportPost();
              } else if (value == 'delete') {
                await _deletePost();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'report', child: Text('Report')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $e'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(postDetailProvider(widget.postId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (post) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          post.author.initials,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.author.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            timeAgo(post.createdAt),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(post.content, style: const TextStyle(fontSize: 14, height: 1.4)),
                  if (post.imageUrls.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    if (post.imageUrls.length == 1)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(post.imageUrls.first, fit: BoxFit.cover),
                        ),
                      )
                    else
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          itemCount: post.imageUrls.length,
                          itemBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(post.imageUrls[index], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.favorite, color: post.isLiked ? Colors.red : Colors.grey, size: 18),
                      const SizedBox(width: 4),
                      Text('${post.likesCount}', style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 16),
                      Icon(Icons.comment_outlined, size: 18, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('${post.commentsCount}', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text('Comments', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 12),
                  if (post.comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No comments yet',
                          style: TextStyle(color: Colors.grey[500], fontSize: 14),
                        ),
                      ),
                    )
                  else
                    ...post.comments.map((c) => _CommentTile(
                      comment: c,
                      postId: widget.postId,
                      currentUserId: 'current-user-id',
                      onDelete: () => _deleteComment(c),
                    )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isSubmittingComment
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          onPressed: _submitComment,
                          icon: const Icon(Icons.send, color: AppColors.primary),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSubmittingComment = true);

    try {
      await ref.read(communityRepositoryProvider).addComment(widget.postId, content);
      _commentController.clear();
      ref.invalidate(postDetailProvider(widget.postId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmittingComment = false);
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(communityRepositoryProvider).deleteComment(widget.postId, comment.id);
      ref.invalidate(postDetailProvider(widget.postId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete comment')),
        );
      }
    }
  }

  Future<void> _reportPost() async {
    final reasons = [
      ('spam', 'Spam'),
      ('inappropriate', 'Inappropriate'),
      ('scam', 'Scam'),
      ('other', 'Other'),
    ];

    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: reasons.map((r) => ListTile(
            title: Text(r.$2),
            onTap: () => Navigator.pop(context, r.$1),
          )).toList(),
        ),
      ),
    );

    if (selected == null || !mounted) return;

    try {
      await ref.read(communityRepositoryProvider).reportContent(
        CreateReportRequest(
          contentType: 'post',
          contentId: widget.postId,
          reason: selected,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit report')),
        );
      }
    }
  }

  Future<void> _deletePost() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(communityRepositoryProvider).deletePost(widget.postId);
      ref.invalidate(communityFeedProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete post')),
        );
      }
    }
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;
  final String postId;
  final String currentUserId;
  final VoidCallback onDelete;

  const _CommentTile({
    required this.comment,
    required this.postId,
    required this.currentUserId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOwnComment = comment.author.id == currentUserId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onLongPress: isOwnComment ? () => onDelete() : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[200],
              child: Text(
                comment.author.initials,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(comment.author.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      const SizedBox(width: 8),
                      Text(
                        timeAgo(comment.createdAt),
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.content, style: const TextStyle(fontSize: 13, height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
