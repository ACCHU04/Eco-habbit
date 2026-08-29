class ImpactMetric {
  final double value;
  final String unit;
  final String label;

  const ImpactMetric({
    required this.value,
    required this.unit,
    required this.label,
  });

  factory ImpactMetric.fromJson(Map<String, dynamic> json) {
    return ImpactMetric(
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }

  String get displayValue {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}

class ImpactData {
  final ImpactMetric co2;
  final ImpactMetric water;
  final ImpactMetric waste;
  final ImpactMetric energy;
  final int itemsRecycled;
  final int itemsSold;
  final int diyCompleted;
  final int scansCompleted;
  final int level;
  final int totalXp;

  const ImpactData({
    required this.co2,
    required this.water,
    required this.waste,
    required this.energy,
    required this.itemsRecycled,
    required this.itemsSold,
    required this.diyCompleted,
    required this.scansCompleted,
    required this.level,
    required this.totalXp,
  });

  factory ImpactData.fromJson(Map<String, dynamic> json) {
    final impact = json['impact'] as Map<String, dynamic>? ?? {};
    final actions = json['actions'] as Map<String, dynamic>? ?? {};
    return ImpactData(
      co2: ImpactMetric.fromJson(impact['co2'] as Map<String, dynamic>? ?? {}),
      water: ImpactMetric.fromJson(impact['water'] as Map<String, dynamic>? ?? {}),
      waste: ImpactMetric.fromJson(impact['waste'] as Map<String, dynamic>? ?? {}),
      energy: ImpactMetric.fromJson(impact['energy'] as Map<String, dynamic>? ?? {}),
      itemsRecycled: actions['items_recycled'] as int? ?? 0,
      itemsSold: actions['items_sold'] as int? ?? 0,
      diyCompleted: actions['diy_completed'] as int? ?? 0,
      scansCompleted: actions['scans_completed'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      totalXp: json['total_xp'] as int? ?? 0,
    );
  }
}

class TimelineEntry {
  final String id;
  final String action;
  final int points;
  final int coinValue;
  final DateTime createdAt;

  const TimelineEntry({
    required this.id,
    required this.action,
    required this.points,
    required this.coinValue,
    required this.createdAt,
  });

  factory TimelineEntry.fromJson(Map<String, dynamic> json) {
    return TimelineEntry(
      id: json['id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      coinValue: json['coin_value'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String get displayLabel {
    switch (action) {
      case 'list_item':
        return 'Listed an item';
      case 'complete_sale':
        return 'Completed a sale';
      case 'complete_donation':
        return 'Donated an item';
      case 'recycle_item':
        return 'Recycled an item';
      case 'post_community':
        return 'Shared a post';
      case 'like_post':
        return 'Liked a post';
      case 'comment_post':
        return 'Commented on a post';
      case 'ai_scan':
        return 'Scanned an item';
      case 'complete_diy':
        return 'Completed DIY project';
      case 'refer_friend':
        return 'Referred a friend';
      default:
        if (action.startsWith('quest_complete:')) {
          return 'Completed quest';
        }
        return action.replaceAll('_', ' ');
    }
  }
}

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final String? lastActiveDate;

  const StreakData({
    required this.currentStreak,
    required this.longestStreak,
    this.lastActiveDate,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastActiveDate: json['last_active_date'] as String?,
    );
  }
}
