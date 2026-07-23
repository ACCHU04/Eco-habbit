class UserPoints {
  final int totalPoints;

  const UserPoints({required this.totalPoints});

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
    );
  }
}

class PointsHistoryItem {
  final String id;
  final String action;
  final int points;
  final DateTime createdAt;

  const PointsHistoryItem({
    required this.id,
    required this.action,
    required this.points,
    required this.createdAt,
  });

  factory PointsHistoryItem.fromJson(Map<String, dynamic> json) {
    return PointsHistoryItem(
      id: json['id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      points: (json['points'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String get actionLabel {
    switch (action) {
      case 'list_item': return 'Listed an item';
      case 'complete_sale': return 'Completed a sale';
      case 'complete_donation': return 'Completed a donation';
      case 'recycle_item': return 'Recycled an item';
      case 'post_community': return 'Community post';
      case 'like_post': return 'Liked a post';
      case 'comment_post': return 'Commented on a post';
      case 'ai_scan': return 'AI scan';
      case 'complete_diy': return 'Completed DIY project';
      case 'refer_friend': return 'Referred a friend';
      default: return action.replaceAll('_', ' ');
    }
  }
}

class PaginatedPointsHistory {
  final List<PointsHistoryItem> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedPointsHistory({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}

class Badge {
  final String id;
  final String badgeType;
  final DateTime earnedAt;

  const Badge({
    required this.id,
    required this.badgeType,
    required this.earnedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String? ?? '',
      badgeType: json['badge_type'] as String? ?? '',
      earnedAt: DateTime.tryParse(json['earned_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

const badgeDisplay = {
  'first_sale': ('🌱', 'First Sale'),
  'recycler': ('♻️', 'Recycler'),
  'creator': ('🎨', 'Creator'),
  'community_star': ('💬', 'Community Star'),
  'campus_champion': ('🏆', 'Campus Champion'),
  'eco_warrior': ('🌍', 'Eco Warrior'),
};

class LeaderboardEntry {
  final String userId;
  final String fullName;
  final String? profilePhoto;
  final int totalPoints;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.fullName,
    this.profilePhoto,
    required this.totalPoints,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json, {int rank = 0}) {
    final users = json['users'] as Map<String, dynamic>?;
    return LeaderboardEntry(
      userId: json['user_id'] as String? ?? '',
      fullName: users?['full_name'] as String? ?? '',
      profilePhoto: users?['profile_photo'] as String?,
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      rank: rank,
    );
  }
}
