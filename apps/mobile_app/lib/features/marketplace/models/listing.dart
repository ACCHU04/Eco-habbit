class Listing {
  final String id;
  final String title;
  final String description;
  final int price;
  final String category;
  final String condition;
  final String status;
  final DateTime createdAt;
  final List<ListingImage> images;
  final SellerInfo seller;

  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.status,
    required this.createdAt,
    required this.images,
    required this.seller,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    final images = json['marketplace_listing_images'] as List<dynamic>?;
    final seller = json['users'] as Map<String, dynamic>?;
    return Listing(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      images: images?.map((i) => ListingImage.fromJson(i)).toList() ?? [],
      seller: seller != null ? SellerInfo.fromJson(seller) : const SellerInfo(id: '', fullName: '', profilePhoto: null, college: ''),
    );
  }

  String? get imageUrl => images.isNotEmpty ? images.first.imageUrl : null;

  Listing copyWith({
    String? id,
    String? title,
    String? description,
    int? price,
    String? category,
    String? condition,
    String? status,
    DateTime? createdAt,
    List<ListingImage>? images,
    SellerInfo? seller,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
      seller: seller ?? this.seller,
    );
  }
}

class ListingImage {
  final String id;
  final String imageUrl;
  final int sortOrder;

  const ListingImage({required this.id, required this.imageUrl, required this.sortOrder});

  factory ListingImage.fromJson(Map<String, dynamic> json) {
    return ListingImage(
      id: json['id'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

class SellerInfo {
  final String id;
  final String fullName;
  final String? profilePhoto;
  final String? college;

  const SellerInfo({required this.id, required this.fullName, this.profilePhoto, this.college});

  factory SellerInfo.fromJson(Map<String, dynamic> json) {
    return SellerInfo(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      profilePhoto: json['profile_photo'] as String?,
      college: json['college'] as String?,
    );
  }
}

class PaginatedListings {
  final List<Listing> listings;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedListings({
    required this.listings,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}

class CreateListingRequest {
  final String title;
  final String description;
  final int price;
  final String category;
  final String condition;
  final List<String>? imageUrls;

  const CreateListingRequest({
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    this.imageUrls,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'price': price,
    'category': category,
    'condition': condition,
    if (imageUrls != null) 'image_urls': imageUrls,
  };
}

class UpdateListingRequest {
  final String? title;
  final String? description;
  final int? price;
  final String? category;
  final String? condition;
  final String? status;

  const UpdateListingRequest({this.title, this.description, this.price, this.category, this.condition, this.status});

  Map<String, dynamic> toJson() => {
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (price != null) 'price': price,
    if (category != null) 'category': category,
    if (condition != null) 'condition': condition,
    if (status != null) 'status': status,
  };
}
