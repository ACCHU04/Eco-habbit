import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/community/data/community_repository.dart';
import 'package:mobile_app/features/community/models/post.dart';
import 'package:mobile_app/features/community/models/community_filter.dart';

final communityFilterProvider = StateProvider<CommunityFilter>((ref) => const CommunityFilter());

class CommunityFeedNotifier extends AsyncNotifier<PaginatedPosts> {
  @override
  Future<PaginatedPosts> build() async {
    final filter = ref.watch(communityFilterProvider);
    return ref.read(communityRepositoryProvider).getFeed(filter: filter);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    state = AsyncValue.data(current);
    try {
      final filter = ref.read(communityFilterProvider);
      final next = await ref.read(communityRepositoryProvider).getFeed(
        filter: filter,
        page: current.page + 1,
        limit: current.limit,
      );
      state = AsyncValue.data(PaginatedPosts(
        posts: [...current.posts, ...next.posts],
        page: next.page,
        limit: next.limit,
        total: next.total,
        totalPages: next.totalPages,
      ));
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }

  void toggleLike(String postId) {
    final current = state.valueOrNull;
    if (current == null) return;
    final post = current.posts.where((p) => p.id == postId).firstOrNull;
    if (post == null) return;
    final newIsLiked = !post.isLiked;
    final newLikesCount = newIsLiked ? post.likesCount + 1 : post.likesCount - 1;
    state = AsyncValue.data(PaginatedPosts(
      posts: current.posts.map((p) => p.id == postId
          ? p.copyWith(isLiked: newIsLiked, likesCount: newLikesCount)
          : p).toList(),
      page: current.page,
      limit: current.limit,
      total: current.total,
      totalPages: current.totalPages,
    ));
  }
}

final communityFeedProvider = AsyncNotifierProvider<CommunityFeedNotifier, PaginatedPosts>(
  CommunityFeedNotifier.new,
);

final postDetailProvider = FutureProvider.family<Post, String>((ref, id) async {
  return ref.read(communityRepositoryProvider).getPost(id);
});

class BookmarksNotifier extends AsyncNotifier<PaginatedPosts> {
  @override
  Future<PaginatedPosts> build() async {
    return ref.read(communityRepositoryProvider).getBookmarks();
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    state = AsyncValue.data(current);
    try {
      final next = await ref.read(communityRepositoryProvider).getBookmarks(
        page: current.page + 1,
        limit: current.limit,
      );
      state = AsyncValue.data(PaginatedPosts(
        posts: [...current.posts, ...next.posts],
        page: next.page,
        limit: next.limit,
        total: next.total,
        totalPages: next.totalPages,
      ));
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }
}

final bookmarksProvider = AsyncNotifierProvider<BookmarksNotifier, PaginatedPosts>(
  BookmarksNotifier.new,
);
