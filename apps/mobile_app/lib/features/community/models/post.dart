class PostAuthor {
  final String id;
  final String fullName;
  final String? profilePhoto;

  const PostAuthor({required this.id, required this.fullName, this.profilePhoto});

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      profilePhoto: json['profile_photo'] as String?,
    );
  }

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

class Comment {
  final String id;
  final String content;
  final DateTime createdAt;
  final PostAuthor author;

  const Comment({required this.id, required this.content, required this.createdAt, required this.author});

  factory Comment.fromJson(Map<String, dynamic> json) {
    final authorJson = json['users'] as Map<String, dynamic>?;
    return Comment(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      author: authorJson != null ? PostAuthor.fromJson(authorJson) : const PostAuthor(id: '', fullName: ''),
    );
  }
}

class Post {
  final String id;
  final String content;
  final String postType;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final PostAuthor author;
  final List<String> imageUrls;
  final bool isLiked;
  final List<Comment> comments;

  const Post({
    required this.id,
    required this.content,
    required this.postType,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.author,
    required this.imageUrls,
    required this.isLiked,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final authorJson = json['users'] as Map<String, dynamic>?;
    final images = json['post_images'] as List<dynamic>?;
    final likes = json['post_likes'] as List<dynamic>?;

    return Post(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      postType: json['post_type'] as String? ?? 'tip',
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      author: authorJson != null ? PostAuthor.fromJson(authorJson) : const PostAuthor(id: '', fullName: ''),
      imageUrls: images?.map((i) => i['image_url'] as String? ?? '').where((u) => u.isNotEmpty).toList() ?? [],
      isLiked: likes != null && likes.isNotEmpty,
      comments: [],
    );
  }

  Post copyWith({
    String? id,
    String? content,
    String? postType,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    PostAuthor? author,
    List<String>? imageUrls,
    bool? isLiked,
    List<Comment>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      postType: postType ?? this.postType,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      imageUrls: imageUrls ?? this.imageUrls,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
    );
  }
}

class PaginatedPosts {
  final List<Post> posts;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedPosts({
    required this.posts,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}

class CreatePostRequest {
  final String postType;
  final String content;
  final List<String>? imageUrls;
  final String? diyProjectId;
  final String? marketplaceListingId;

  const CreatePostRequest({
    required this.postType,
    required this.content,
    this.imageUrls,
    this.diyProjectId,
    this.marketplaceListingId,
  });

  Map<String, dynamic> toJson() => {
    'post_type': postType,
    'content': content,
    if (imageUrls != null && imageUrls!.isNotEmpty) 'image_urls': imageUrls,
    if (diyProjectId != null) 'diy_project_id': diyProjectId,
    if (marketplaceListingId != null) 'marketplace_listing_id': marketplaceListingId,
  };
}

class CreateReportRequest {
  final String contentType;
  final String contentId;
  final String reason;
  final String? description;

  const CreateReportRequest({
    required this.contentType,
    required this.contentId,
    required this.reason,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'content_type': contentType,
    'content_id': contentId,
    'reason': reason,
    if (description != null) 'description': description,
  };
}
