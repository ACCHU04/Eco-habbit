class Achievement {
  final String key;
  final String title;
  final String description;
  final String icon;
  final int target;
  final int current;
  final bool completed;

  const Achievement({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    this.current = 0,
    this.completed = false,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      target: (json['target'] as num?)?.toInt() ?? 1,
      current: (json['current'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
    );
  }

  double get progress => target > 0 ? current / target : 0;
}
