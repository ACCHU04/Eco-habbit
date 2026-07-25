import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/utils/time_ago.dart';
import 'package:mobile_app/core/widgets/eco_post_card.dart';
import 'package:mobile_app/core/widgets/empty_state.dart';
import 'package:mobile_app/features/community/providers/community_provider.dart';
import 'package:mobile_app/features/community/data/community_repository.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _bookmarkedIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(bookmarksProvider.notifier).loadMore();
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
      if (!wasBookmarked && mounted) {
        ref.invalidate(bookmarksProvider);
      }
    } catch (e) {
      setState(() {
        if (wasBookmarked) {
          _bookmarkedIds.add(postId);
        } else {
          _bookmarkedIds.remove(postId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $e'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(bookmarksProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (paginated) {
          if (paginated.posts.isEmpty) {
            return const EmptyState(
              icon: Icons.bookmark_outline,
              title: 'No bookmarks yet',
              subtitle: 'Save posts to read them later',
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(bookmarksProvider),
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
                _bookmarkedIds.add(post.id);
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
                    isBookmarked: true,
                    imageUrls: post.imageUrls,
                    onTap: () => context.push('/community/post/${post.id}'),
                    onBookmark: () => _toggleBookmark(post.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
