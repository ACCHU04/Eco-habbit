class ClassifyResult {
  final String category;
  final double confidence;
  final String disposalTips;
  final bool isUncertain;
  final List<DiySuggestionItem> diySuggestions;
  final bool cached;

  const ClassifyResult({
    required this.category,
    required this.confidence,
    required this.disposalTips,
    required this.isUncertain,
    required this.diySuggestions,
    required this.cached,
  });

  factory ClassifyResult.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as Map<String, dynamic>? ?? {};
    final suggestions = json['diy_suggestions'] as List<dynamic>?;
    return ClassifyResult(
      category: result['category'] as String? ?? 'others',
      confidence: (result['confidence'] as num?)?.toDouble() ?? 0.0,
      disposalTips: result['disposal_tips'] as String? ?? '',
      isUncertain: result['is_uncertain'] as bool? ?? true,
      diySuggestions: suggestions?.map((s) => DiySuggestionItem.fromJson(s)).toList() ?? [],
      cached: json['cached'] as bool? ?? false,
    );
  }
}

class DiySuggestionItem {
  final String projectId;
  final String title;
  final String difficulty;
  final String estimatedTime;
  final int estimatedPrice;
  final List<String> materials;
  final String? thumbnailUrl;

  const DiySuggestionItem({
    required this.projectId,
    required this.title,
    required this.difficulty,
    required this.estimatedTime,
    required this.estimatedPrice,
    required this.materials,
    this.thumbnailUrl,
  });

  factory DiySuggestionItem.fromJson(Map<String, dynamic> json) {
    return DiySuggestionItem(
      projectId: json['project_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'easy',
      estimatedTime: json['estimated_time'] as String? ?? '30 minutes',
      estimatedPrice: (json['estimated_price'] as num?)?.toInt() ?? 0,
      materials: (json['materials'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }
}
