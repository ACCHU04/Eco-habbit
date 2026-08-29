class Hostel {
  final String id;
  final String name;
  final String college;
  final int totalScore;
  final int memberCount;
  final String? avatarUrl;

  const Hostel({
    required this.id,
    required this.name,
    required this.college,
    this.totalScore = 0,
    this.memberCount = 0,
    this.avatarUrl,
  });

  factory Hostel.fromJson(Map<String, dynamic> json) {
    return Hostel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      college: json['college'] as String? ?? '',
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}

class HostelBattle {
  final String id;
  final String title;
  final String description;
  final Hostel? hosteler;
  final Hostel? challenger;
  final String status;
  final String metric;
  final int startScoreHosteler;
  final int startScoreChallenger;
  final int? endScoreHosteler;
  final int? endScoreChallenger;
  final String? winnerId;
  final DateTime startsAt;
  final DateTime endsAt;

  const HostelBattle({
    required this.id,
    required this.title,
    required this.description,
    this.hosteler,
    this.challenger,
    required this.status,
    required this.metric,
    this.startScoreHosteler = 0,
    this.startScoreChallenger = 0,
    this.endScoreHosteler,
    this.endScoreChallenger,
    this.winnerId,
    required this.startsAt,
    required this.endsAt,
  });

  factory HostelBattle.fromJson(Map<String, dynamic> json) {
    final hostelerData = json['hosteler'] as Map<String, dynamic>?;
    final challengerData = json['challenger'] as Map<String, dynamic>?;

    return HostelBattle(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      hosteler: hostelerData != null ? Hostel.fromJson(hostelerData) : null,
      challenger: challengerData != null ? Hostel.fromJson(challengerData) : null,
      status: json['status'] as String? ?? 'active',
      metric: json['metric'] as String? ?? 'total_score',
      startScoreHosteler: (json['start_score_hosteler'] as num?)?.toInt() ?? 0,
      startScoreChallenger: (json['start_score_challenger'] as num?)?.toInt() ?? 0,
      endScoreHosteler: (json['end_score_hosteler'] as num?)?.toInt(),
      endScoreChallenger: (json['end_score_challenger'] as num?)?.toInt(),
      winnerId: json['winner_id'] as String?,
      startsAt: DateTime.tryParse(json['starts_at'] as String? ?? '') ?? DateTime.now(),
      endsAt: DateTime.tryParse(json['ends_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  bool get isExpired => DateTime.now().isAfter(endsAt);
  bool get isActive => status == 'active' && !isExpired;
  int get durationDays => endsAt.difference(startsAt).inDays;
}
