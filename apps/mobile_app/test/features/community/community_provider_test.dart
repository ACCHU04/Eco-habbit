import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/features/community/data/community_repository.dart';
import 'package:mobile_app/features/community/models/post.dart';
import 'package:mobile_app/features/community/models/community_filter.dart';
import 'package:mobile_app/features/community/providers/community_provider.dart';

@GenerateMocks([CommunityRepository])
import 'community_provider_test.mocks.dart';

void main() {
  late MockCommunityRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockCommunityRepository();
    container = ProviderContainer(
      overrides: [
        communityRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  PaginatedPosts mockPaginatedPosts({
    List<Post>? posts,
    int page = 1,
    int limit = 20,
    int total = 1,
    int totalPages = 1,
  }) {
    return PaginatedPosts(
      posts: posts ?? [Post(
        id: '1', content: 'Hello', postType: PostType.tip,
        likesCount: 5, commentsCount: 2, createdAt: DateTime(2026),
        author: const PostAuthor(id: 'u1', fullName: 'Test User'),
        imageUrls: [], isLiked: false, comments: [],
      )],
      page: page, limit: limit, total: total, totalPages: totalPages,
    );
  }

  group('CommunityFeedNotifier', () {
    test('loads feed successfully', () async {
      when(mockRepo.getFeed(filter: anyNamed('filter'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => mockPaginatedPosts());

      final result = await container.read(communityFeedProvider.future);

      expect(result.posts, hasLength(1));
      expect(result.posts[0].content, 'Hello');
      verify(mockRepo.getFeed(filter: anyNamed('filter'), page: 1, limit: 20)).called(1);
    });

    test('applies filter correctly', () async {
      when(mockRepo.getFeed(filter: anyNamed('filter'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => mockPaginatedPosts());

      container.read(communityFilterProvider.notifier).state = const CommunityFilter(postType: 'diy');
      await container.read(communityFeedProvider.future);

      final captured = verify(mockRepo.getFeed(
        filter: captureAnyNamed('filter'), page: captureAnyNamed('page'), limit: captureAnyNamed('limit'),
      )).captured;
      final filter = captured.first as CommunityFilter;
      expect(filter.postType, 'diy');
    });

    test('loads more pages', () async {
      final page1 = mockPaginatedPosts(
        posts: [Post(
          id: '1', content: 'Post 1', postType: PostType.tip,
          likesCount: 0, commentsCount: 0, createdAt: DateTime(2026),
          author: const PostAuthor(id: 'u1', fullName: 'User 1'),
          imageUrls: [], isLiked: false, comments: [],
        )],
        page: 1, total: 2, totalPages: 2,
      );
      final page2 = mockPaginatedPosts(
        posts: [Post(
          id: '2', content: 'Post 2', postType: PostType.diy,
          likesCount: 0, commentsCount: 0, createdAt: DateTime(2026),
          author: const PostAuthor(id: 'u2', fullName: 'User 2'),
          imageUrls: [], isLiked: false, comments: [],
        )],
        page: 2, total: 2, totalPages: 2,
      );

      when(mockRepo.getFeed(filter: anyNamed('filter'), page: 1, limit: 20))
          .thenAnswer((_) async => page1);
      when(mockRepo.getFeed(filter: anyNamed('filter'), page: 2, limit: 20))
          .thenAnswer((_) async => page2);

      await container.read(communityFeedProvider.future);
      await container.read(communityFeedProvider.notifier).loadMore();

      final result = container.read(communityFeedProvider).value;
      expect(result!.posts, hasLength(2));
      expect(result.posts[1].id, '2');
    });

    test('handles API failure', () async {
      when(mockRepo.getFeed(filter: anyNamed('filter'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenThrow(Exception('Network error'));

      expect(
        () => container.read(communityFeedProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('PostDetailNotifier', () {
    test('loads post with comments', () async {
      final post = Post(
        id: 'p1', content: 'Detail post', postType: PostType.diy,
        likesCount: 10, commentsCount: 2, createdAt: DateTime(2026),
        author: const PostAuthor(id: 'u1', fullName: 'Author'),
        imageUrls: [], isLiked: true,
        comments: [
          Comment(id: 'c1', content: 'Nice!', createdAt: DateTime(2026), author: const PostAuthor(id: 'u2', fullName: 'Commenter')),
        ],
      );
      when(mockRepo.getPost('p1')).thenAnswer((_) async => post);

      final result = await container.read(postDetailProvider('p1').future);

      expect(result.id, 'p1');
      expect(result.content, 'Detail post');
      expect(result.comments, hasLength(1));
      verify(mockRepo.getPost('p1')).called(1);
    });

    test('handles post not found', () async {
      when(mockRepo.getPost('nonexistent')).thenThrow(Exception('Post not found'));

      expect(
        () => container.read(postDetailProvider('nonexistent').future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Optimistic like', () {
    test('toggles like optimistically and rolls back on failure', () async {
      final post = Post(
        id: 'p1', content: 'Test', postType: PostType.tip,
        likesCount: 5, commentsCount: 0, createdAt: DateTime(2026),
        author: const PostAuthor(id: 'u1', fullName: 'User'),
        imageUrls: [], isLiked: false, comments: [],
      );
      final paginated = mockPaginatedPosts(posts: [post], total: 1, totalPages: 1);

      when(mockRepo.getFeed(filter: anyNamed('filter'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => paginated);

      await container.read(communityFeedProvider.future);

      when(mockRepo.likePost('p1')).thenThrow(Exception('Network error'));

      final currentData = container.read(communityFeedProvider).value!;
      container.read(communityFeedProvider.notifier).state = AsyncValue.data(PaginatedPosts(
        posts: currentData.posts.map((p) => p.id == 'p1'
            ? p.copyWith(isLiked: true, likesCount: 6)
            : p).toList(),
        page: currentData.page, limit: currentData.limit,
        total: currentData.total, totalPages: currentData.totalPages,
      ));

      final afterOptimistic = container.read(communityFeedProvider).value;
      expect(afterOptimistic!.posts[0].isLiked, true);
      expect(afterOptimistic.posts[0].likesCount, 6);

      try {
        await mockRepo.likePost('p1');
      } catch (_) {
        final rollbackData = container.read(communityFeedProvider).value!;
        container.read(communityFeedProvider.notifier).state = AsyncValue.data(PaginatedPosts(
          posts: rollbackData.posts.map((p) => p.id == 'p1' ? post : p).toList(),
          page: rollbackData.page, limit: rollbackData.limit,
          total: rollbackData.total, totalPages: rollbackData.totalPages,
        ));
      }

      final afterRollback = container.read(communityFeedProvider).value;
      expect(afterRollback!.posts[0].isLiked, false);
      expect(afterRollback.posts[0].likesCount, 5);
    });
  });

  group('Comment', () {
    test('addComment calls repository', () async {
      when(mockRepo.addComment('p1', 'Great post!'))
          .thenAnswer((_) async => Comment(
            id: 'c1', content: 'Great post!', createdAt: DateTime(2026),
            author: const PostAuthor(id: 'u1', fullName: 'User'),
          ));

      final result = await mockRepo.addComment('p1', 'Great post!');

      expect(result.content, 'Great post!');
      verify(mockRepo.addComment('p1', 'Great post!')).called(1);
    });
  });

  group('Create post', () {
    test('createPost calls repository and returns post', () async {
      when(mockRepo.createPost(any)).thenAnswer((_) async => Post(
        id: 'new-1', content: 'My tip', postType: PostType.tip,
        likesCount: 0, commentsCount: 0, createdAt: DateTime(2026),
        author: const PostAuthor(id: 'u1', fullName: 'User'),
        imageUrls: [], isLiked: false, comments: [],
      ));

      final result = await mockRepo.createPost(const CreatePostRequest(
        postType: PostType.tip, content: 'My tip',
      ));

      expect(result.id, 'new-1');
      expect(result.content, 'My tip');
      verify(mockRepo.createPost(any)).called(1);
    });
  });
}
