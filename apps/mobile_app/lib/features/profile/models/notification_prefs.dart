class NotificationPrefs {
  final bool likeComment;
  final bool marketplaceInquiry;
  final bool rewardAchievement;
  final bool communityUpdate;

  const NotificationPrefs({
    required this.likeComment,
    required this.marketplaceInquiry,
    required this.rewardAchievement,
    required this.communityUpdate,
  });

  factory NotificationPrefs.fromJson(Map<String, dynamic> json) {
    return NotificationPrefs(
      likeComment: json['like_comment'] as bool? ?? true,
      marketplaceInquiry: json['marketplace_inquiry'] as bool? ?? true,
      rewardAchievement: json['reward_achievement'] as bool? ?? true,
      communityUpdate: json['community_update'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'like_comment': likeComment,
    'marketplace_inquiry': marketplaceInquiry,
    'reward_achievement': rewardAchievement,
    'community_update': communityUpdate,
  };

  NotificationPrefs copyWith({
    bool? likeComment,
    bool? marketplaceInquiry,
    bool? rewardAchievement,
    bool? communityUpdate,
  }) {
    return NotificationPrefs(
      likeComment: likeComment ?? this.likeComment,
      marketplaceInquiry: marketplaceInquiry ?? this.marketplaceInquiry,
      rewardAchievement: rewardAchievement ?? this.rewardAchievement,
      communityUpdate: communityUpdate ?? this.communityUpdate,
    );
  }
}
