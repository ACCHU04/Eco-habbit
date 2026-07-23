class DiyProject {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String estimatedTime;
  final int estimatedPrice;
  final List<String> materials;
  final List<String> steps;
  final String? imageUrl;
  final String? tutorialUrl;

  const DiyProject({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedTime,
    required this.estimatedPrice,
    required this.materials,
    required this.steps,
    this.imageUrl,
    this.tutorialUrl,
  });

  factory DiyProject.fromJson(Map<String, dynamic> json) {
    return DiyProject(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'easy',
      estimatedTime: json['estimated_time'] as String? ?? '30 minutes',
      estimatedPrice: json['estimated_price'] as int? ?? 0,
      materials: (json['materials'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      imageUrl: json['image_url'] as String?,
      tutorialUrl: json['tutorial_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'estimated_time': estimatedTime,
        'estimated_price': estimatedPrice,
        'materials': materials,
        'steps': steps,
        'image_url': imageUrl,
        'tutorial_url': tutorialUrl,
      };

  static const sample = DiyProject(
    id: 'sample-1',
    title: 'Plastic Bottle Planter',
    description:
        'Turn plastic bottles into hanging planters for your dorm room. A fun and easy project that helps reduce plastic waste.',
    difficulty: 'easy',
    estimatedTime: '30 minutes',
    estimatedPrice: 150,
    materials: ['Plastic bottle', 'Scissors', 'Rope', 'Paint'],
    steps: [
      'Cut the bottle in half horizontally',
      'Poke drainage holes in the bottom',
      'Paint and decorate the outside',
      'Thread rope through holes for hanging',
      'Add soil and plant',
    ],
  );
}
