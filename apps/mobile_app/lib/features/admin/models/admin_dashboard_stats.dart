class AdminDashboardStats {
  final int totalUsers;
  final int totalPosts;
  final int pendingReports;
  final int activeListings;
  final Map<String, int> roleBreakdown;

  AdminDashboardStats({
    required this.totalUsers,
    required this.totalPosts,
    required this.pendingReports,
    required this.activeListings,
    required this.roleBreakdown,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    final breakdown = <String, int>{};
    final raw = json['role_breakdown'] as Map<String, dynamic>?;
    raw?.forEach((key, value) {
      breakdown[key] = (value as num).toInt();
    });

    return AdminDashboardStats(
      totalUsers: (json['total_users'] as num?)?.toInt() ?? 0,
      totalPosts: (json['total_posts'] as num?)?.toInt() ?? 0,
      pendingReports: (json['pending_reports'] as num?)?.toInt() ?? 0,
      activeListings: (json['active_listings'] as num?)?.toInt() ?? 0,
      roleBreakdown: breakdown,
    );
  }
}
