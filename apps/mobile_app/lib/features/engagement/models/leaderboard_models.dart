class LeaderboardEntry {
  final String userId;
  final String fullName;
  final String? profilePhoto;
  final int totalPoints;
  final int level;
  final int badgeCount;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.fullName,
    this.profilePhoto,
    required this.totalPoints,
    this.level = 1,
    this.badgeCount = 0,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      profilePhoto: json['profile_photo'] as String?,
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      badgeCount: (json['badge_count'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );
  }
}

class HostelEntry {
  final String hostelId;
  final String hostelName;
  final int totalScore;
  final int memberCount;
  final double avgScore;
  final int rank;

  const HostelEntry({
    required this.hostelId,
    required this.hostelName,
    required this.totalScore,
    required this.memberCount,
    required this.avgScore,
    required this.rank,
  });

  factory HostelEntry.fromJson(Map<String, dynamic> json) {
    return HostelEntry(
      hostelId: json['hostel_id'] as String? ?? '',
      hostelName: json['hostel_name'] as String? ?? '',
      totalScore: (json['total_points'] as num?)?.toInt() ?? 0,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      avgScore: (json['avg_score'] as num?)?.toDouble() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );
  }
}

enum LeaderboardFilter { campus, hostel, department, friends }

enum LeaderboardPeriod { weekly, monthly, allTime }
