import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/community/models/post.dart';
import 'package:mobile_app/features/community/models/community_filter.dart';

class CommunityRepository {
  final ApiClient _api;
  CommunityRepository(this._api);

  Future<String> uploadImage(String filePath) async {
    final response = await _api.postMultipart(
      '/community/upload-image',
      fieldName: 'file',
      filePath: filePath,
    );
    return response.data['url'] as String;
  }

  Future<PaginatedPosts> getFeed({
    CommunityFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (filter?.postType != null) params['type'] = filter!.postType;
    final response = await _api.get('/community/posts', queryParameters: params);
    final data = response.data['data'] as List<dynamic>;
    final pagination = response.data['pagination'] as Map<String, dynamic>;
    return PaginatedPosts(
      posts: data.map((p) => Post.fromJson(p)).toList(),
      page: pagination['page'] as int? ?? page,
      limit: pagination['limit'] as int? ?? limit,
      total: pagination['total'] as int? ?? 0,
      totalPages: pagination['total_pages'] as int? ?? 1,
    );
  }

  Future<Post> getPost(String id) async {
    final response = await _api.get('/community/posts/$id');
    final json = response.data['data'] as Map<String, dynamic>;
    final post = Post.fromJson(json);
    final commentsList = json['post_comments'] as List<dynamic>?;
    final comments = commentsList?.map((c) => Comment.fromJson(c)).toList() ?? [];
    return post.copyWith(comments: comments);
  }

  Future<Post> createPost(CreatePostRequest request) async {
    final response = await _api.post('/community/posts', data: request.toJson());
    return Post.fromJson(response.data['data']);
  }

  Future<bool> likePost(String postId) async {
    final response = await _api.post('/community/posts/$postId/like');
    return response.data['liked'] as bool? ?? false;
  }

  Future<Comment> addComment(String postId, String content) async {
    final response = await _api.post(
      '/community/posts/$postId/comments',
      data: {'content': content},
    );
    return Comment.fromJson(response.data['data']);
  }

  Future<void> deletePost(String postId) async {
    await _api.delete('/community/posts/$postId');
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await _api.delete('/community/posts/$postId/comments/$commentId');
  }

  Future<PaginatedPosts> searchPosts({required String query, String? type, int page = 1, int limit = 20}) async {
    final params = <String, dynamic>{'q': query, 'page': page, 'limit': limit};
    if (type != null) params['type'] = type;
    final response = await _api.get('/community/posts/search', queryParameters: params);
    final data = response.data['data'] as List<dynamic>;
    final pagination = response.data['pagination'] as Map<String, dynamic>;
    return PaginatedPosts(
      posts: data.map((p) => Post.fromJson(p)).toList(),
      page: pagination['page'] as int? ?? page,
      limit: pagination['limit'] as int? ?? limit,
      total: pagination['total'] as int? ?? 0,
      totalPages: pagination['total_pages'] as int? ?? 1,
    );
  }

  Future<List<Post>> getTrending({int limit = 10}) async {
    final response = await _api.get('/community/posts/trending', queryParameters: {'limit': limit});
    final data = response.data['data'] as List<dynamic>;
    return data.map((p) => Post.fromJson(p)).toList();
  }

  Future<bool> toggleBookmark(String postId) async {
    final response = await _api.post('/community/posts/$postId/bookmark');
    return response.data['bookmarked'] as bool? ?? false;
  }

  Future<PaginatedPosts> getBookmarks({int page = 1, int limit = 20}) async {
    final response = await _api.get('/community/bookmarks', queryParameters: {'page': page, 'limit': limit});
    final data = response.data['data'] as List<dynamic>;
    final pagination = response.data['pagination'] as Map<String, dynamic>;
    return PaginatedPosts(
      posts: data.map((p) => Post.fromJson(p)).toList(),
      page: pagination['page'] as int? ?? page,
      limit: pagination['limit'] as int? ?? limit,
      total: pagination['total'] as int? ?? 0,
      totalPages: pagination['total_pages'] as int? ?? 1,
    );
  }

  Future<void> reportContent(CreateReportRequest request) async {
    await _api.post('/reports', data: request.toJson());
  }
}

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(ref.read(apiClientProvider));
});
