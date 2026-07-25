class Quest {
  final String id;
  final String title;
  final String description;
  final String questType;
  final int xpReward;
  final int coinReward;
  final String difficulty;
  final String targetAction;
  final int targetCount;
  final int progress;
  final bool completed;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.questType,
    required this.xpReward,
    required this.coinReward,
    required this.difficulty,
    required this.targetAction,
    required this.targetCount,
    this.progress = 0,
    this.completed = false,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      questType: json['quest_type'] as String? ?? 'daily',
      xpReward: json['xp_reward'] as int? ?? 0,
      coinReward: json['coin_reward'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'easy',
      targetAction: json['target_action'] as String? ?? '',
      targetCount: json['target_count'] as int? ?? 1,
      progress: json['progress'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
    );
  }

  double get progressPercent =>
      targetCount > 0 ? (progress / targetCount).clamp(0.0, 1.0) : 0.0;

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    String? questType,
    int? xpReward,
    int? coinReward,
    String? difficulty,
    String? targetAction,
    int? targetCount,
    int? progress,
    bool? completed,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      questType: questType ?? this.questType,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
      difficulty: difficulty ?? this.difficulty,
      targetAction: targetAction ?? this.targetAction,
      targetCount: targetCount ?? this.targetCount,
      progress: progress ?? this.progress,
      completed: completed ?? this.completed,
    );
  }
}

class QuestProgressResult {
  final Quest quest;
  final int currentCount;
  final bool completed;
  final int xpAwarded;
  final int coinsAwarded;
  final bool leveledUp;

  const QuestProgressResult({
    required this.quest,
    required this.currentCount,
    required this.completed,
    required this.xpAwarded,
    required this.coinsAwarded,
    required this.leveledUp,
  });

  factory QuestProgressResult.fromJson(Map<String, dynamic> json) {
    final questData = json['quest'] as Map<String, dynamic>?;
    final progressData = json['progress'] as Map<String, dynamic>?;
    return QuestProgressResult(
      quest: questData != null ? Quest.fromJson(questData) : const Quest(id: '', title: '', description: '', questType: '', xpReward: 0, coinReward: 0, difficulty: '', targetAction: '', targetCount: 1),
      currentCount: progressData?['current_count'] as int? ?? 0,
      completed: progressData?['completed'] as bool? ?? false,
      xpAwarded: json['xp_awarded'] as int? ?? 0,
      coinsAwarded: json['coins_awarded'] as int? ?? 0,
      leveledUp: json['leveled_up'] as bool? ?? false,
    );
  }
}
