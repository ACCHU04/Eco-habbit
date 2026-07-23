import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/community/models/post.dart';
import 'package:mobile_app/features/community/models/community_filter.dart';

void main() {
  group('Post.fromJson', () {
    test('parses post with author, images, and likes', () {
      final json = {
        'id': 'p1',
        'content': 'Hello world',
        'post_type': 'tip',
        'likes_count': 10,
        'comments_count': 3,
        'created_at': '2026-07-23T10:00:00Z',
        'users': {'id': 'u1', 'full_name': 'Test User', 'profile_photo': null},
        'post_images': [
          {'image_url': 'https://example.com/img1.jpg'},
          {'image_url': 'https://example.com/img2.jpg'},
        ],
        'post_likes': [{'user_id': 'u1'}],
      };

      final post = Post.fromJson(json);

      expect(post.id, 'p1');
      expect(post.content, 'Hello world');
      expect(post.postType, 'tip');
      expect(post.likesCount, 10);
      expect(post.commentsCount, 3);
      expect(post.author.id, 'u1');
      expect(post.author.fullName, 'Test User');
      expect(post.imageUrls, hasLength(2));
      expect(post.isLiked, true);
    });

    test('parses post with zero likes (left join)', () {
      final json = {
        'id': 'p2',
        'content': 'New post',
        'post_type': 'diy',
        'likes_count': 0,
        'comments_count': 0,
        'created_at': '2026-07-23T10:00:00Z',
        'users': {'id': 'u2', 'full_name': 'Another User'},
        'post_images': [],
        'post_likes': [],
      };

      final post = Post.fromJson(json);

      expect(post.likesCount, 0);
      expect(post.isLiked, false);
      expect(post.imageUrls, isEmpty);
    });

    test('handles missing optional fields gracefully', () {
      final json = <String, dynamic>{
        'id': 'p3',
        'content': 'Minimal post',
        'post_type': 'marketplace',
      };

      final post = Post.fromJson(json);

      expect(post.id, 'p3');
      expect(post.likesCount, 0);
      expect(post.author.fullName, '');
      expect(post.isLiked, false);
    });
  });

  group('Post.copyWith', () {
    test('creates modified copy', () {
      final original = Post(
        id: 'p1', content: 'Original', postType: 'tip',
        likesCount: 5, commentsCount: 2, createdAt: DateTime(2026),
        author: const PostAuthor(id: 'u1', fullName: 'User'),
        imageUrls: [], isLiked: false, comments: [],
      );

      final modified = original.copyWith(isLiked: true, likesCount: 6);

      expect(modified.isLiked, true);
      expect(modified.likesCount, 6);
      expect(modified.content, 'Original');
    });
  });

  group('CommunityFilter', () {
    test('creates with null postType', () {
      const filter = CommunityFilter();
      expect(filter.postType, isNull);
    });

    test('copyWith sets postType', () {
      const original = CommunityFilter();
      final filtered = original.copyWith(postType: 'diy');
      expect(filtered.postType, 'diy');
    });

    test('copyWith clearType resets to null', () {
      const original = CommunityFilter(postType: 'diy');
      final cleared = original.copyWith(clearType: true);
      expect(cleared.postType, isNull);
    });
  });

  group('PostAuthor', () {
    test('initials for full name', () {
      const author = PostAuthor(id: 'u1', fullName: 'Priya Mehta');
      expect(author.initials, 'PM');
    });

    test('initials for single name', () {
      const author = PostAuthor(id: 'u1', fullName: 'Rahul');
      expect(author.initials, 'R');
    });

    test('initials for empty name', () {
      const author = PostAuthor(id: 'u1', fullName: '');
      expect(author.initials, '?');
    });
  });

  group('CreatePostRequest', () {
    test('toJson omits null fields', () {
      const request = CreatePostRequest(postType: 'tip', content: 'Hello');
      final json = request.toJson();

      expect(json['post_type'], 'tip');
      expect(json['content'], 'Hello');
      expect(json.containsKey('image_urls'), false);
      expect(json.containsKey('diy_project_id'), false);
    });

    test('toJson includes optional fields when set', () {
      const request = CreatePostRequest(
        postType: 'diy', content: 'Project',
        diyProjectId: 'proj-1',
      );
      final json = request.toJson();

      expect(json['diy_project_id'], 'proj-1');
    });
  });

  group('CreateReportRequest', () {
    test('toJson serializes correctly', () {
      const request = CreateReportRequest(
        contentType: 'post', contentId: 'p1', reason: 'spam',
      );
      final json = request.toJson();

      expect(json['content_type'], 'post');
      expect(json['content_id'], 'p1');
      expect(json['reason'], 'spam');
    });
  });

  group('PaginatedPosts', () {
    test('hasMore returns true when page < totalPages', () {
      const paginated = PaginatedPosts(
        posts: [], page: 1, limit: 20, total: 50, totalPages: 3,
      );
      expect(paginated.hasMore, true);
    });

    test('hasMore returns false when on last page', () {
      const paginated = PaginatedPosts(
        posts: [], page: 3, limit: 20, total: 50, totalPages: 3,
      );
      expect(paginated.hasMore, false);
    });
  });
}
