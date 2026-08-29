class UserStats {
  final int listingsCount;
  final int totalPoints;
  final int badgesCount;
  final List<String> badges;

  const UserStats({
    required this.listingsCount,
    required this.totalPoints,
    required this.badgesCount,
    required this.badges,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      listingsCount: json['listings_count'] as int? ?? 0,
      totalPoints: json['total_points'] as int? ?? 0,
      badgesCount: json['badges_count'] as int? ?? 0,
      badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
