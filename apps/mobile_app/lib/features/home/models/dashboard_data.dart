class DashboardData {
  final int points;
  final List<ListingSummary> recentListings;

  const DashboardData({
    required this.points,
    required this.recentListings,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final listings = json['recent_listings'] as List<dynamic>?;
    return DashboardData(
      points: json['points'] as int? ?? 0,
      recentListings: listings?.map((l) => ListingSummary.fromJson(l)).toList() ?? [],
    );
  }
}

class ListingSummary {
  final String id;
  final String title;
  final int price;
  final String category;
  final String condition;
  final String? imageUrl;

  const ListingSummary({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.condition,
    this.imageUrl,
  });

  factory ListingSummary.fromJson(Map<String, dynamic> json) {
    final images = json['marketplace_listing_images'] as List<dynamic>?;
    String? url;
    if (images != null && images.isNotEmpty) {
      url = images[0]['image_url'] as String?;
    }
    return ListingSummary(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
      imageUrl: url,
    );
  }
}
