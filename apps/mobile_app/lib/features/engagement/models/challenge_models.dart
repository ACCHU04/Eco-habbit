class Friend {
  final String friendshipId;
  final FriendUser friend;
  final DateTime since;

  const Friend({
    required this.friendshipId,
    required this.friend,
    required this.since,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      friendshipId: json['friendship_id'] as String? ?? '',
      friend: FriendUser.fromJson(json['friend'] as Map<String, dynamic>? ?? {}),
      since: DateTime.tryParse(json['since'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class FriendUser {
  final String id;
  final String fullName;
  final String? profilePhoto;

  const FriendUser({
    required this.id,
    required this.fullName,
    this.profilePhoto,
  });

  factory FriendUser.fromJson(Map<String, dynamic> json) {
    return FriendUser(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      profilePhoto: json['profile_photo'] as String?,
    );
  }
}

class FriendRequest {
  final String friendshipId;
  final FriendUser requester;
  final DateTime createdAt;

  const FriendRequest({
    required this.friendshipId,
    required this.requester,
    required this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      friendshipId: json['id'] as String? ?? '',
      requester: FriendUser.fromJson(json['requester'] as Map<String, dynamic>? ?? {}),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class FriendChallenge {
  final String id;
  final String title;
  final String description;
  final FriendUser? challenger;
  final FriendUser? challengee;
  final String status;
  final String goalAction;
  final int goalCount;
  final int challengerProgress;
  final int challengeeProgress;
  final String? winnerId;
  final int xpReward;
  final int coinReward;
  final DateTime? startsAt;
  final DateTime endsAt;
  final DateTime createdAt;

  const FriendChallenge({
    required this.id,
    required this.title,
    required this.description,
    this.challenger,
    this.challengee,
    required this.status,
    required this.goalAction,
    required this.goalCount,
    this.challengerProgress = 0,
    this.challengeeProgress = 0,
    this.winnerId,
    this.xpReward = 100,
    this.coinReward = 25,
    this.startsAt,
    required this.endsAt,
    required this.createdAt,
  });

  factory FriendChallenge.fromJson(Map<String, dynamic> json) {
    return FriendChallenge(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      challenger: json['challenger'] != null ? FriendUser.fromJson(json['challenger'] as Map<String, dynamic>) : null,
      challengee: json['challengee'] != null ? FriendUser.fromJson(json['challengee'] as Map<String, dynamic>) : null,
      status: json['status'] as String? ?? 'pending',
      goalAction: json['goal_action'] as String? ?? '',
      goalCount: (json['goal_count'] as num?)?.toInt() ?? 1,
      challengerProgress: (json['challenger_progress'] as num?)?.toInt() ?? 0,
      challengeeProgress: (json['challengee_progress'] as num?)?.toInt() ?? 0,
      winnerId: json['winner_id'] as String?,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 100,
      coinReward: (json['coin_reward'] as num?)?.toInt() ?? 25,
      startsAt: json['starts_at'] != null ? DateTime.tryParse(json['starts_at']) : null,
      endsAt: DateTime.tryParse(json['ends_at'] as String? ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  bool get isExpired => DateTime.now().isAfter(endsAt);

  String get goalActionLabel {
    switch (goalAction) {
      case 'recycle_item': return 'Recycle items';
      case 'complete_sale': return 'Complete sales';
      case 'complete_donation': return 'Donate items';
      case 'ai_scan': return 'Scan items';
      case 'complete_diy': return 'DIY projects';
      case 'create_post': return 'Create posts';
      case 'list_item': return 'List items';
      default: return goalAction.replaceAll('_', ' ');
    }
  }
}
