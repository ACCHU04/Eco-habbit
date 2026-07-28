class ClassifyResult {
  final String category;
  final double confidence;
  final String disposalTips;
  final bool isUncertain;
  final String explanation;
  final List<LabelInfo> topLabels;
  final List<DiySuggestionItem> diySuggestions;
  final bool cached;

  const ClassifyResult({
    required this.category,
    required this.confidence,
    required this.disposalTips,
    required this.isUncertain,
    this.explanation = '',
    this.topLabels = const [],
    required this.diySuggestions,
    required this.cached,
  });

  factory ClassifyResult.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as Map<String, dynamic>? ?? {};
    final suggestions = json['diy_suggestions'] as List<dynamic>?;
    final rawLabels = result['top_labels'] as List<dynamic>?;
    return ClassifyResult(
      category: result['category'] as String? ?? 'others',
      confidence: (result['confidence'] as num?)?.toDouble() ?? 0.0,
      disposalTips: result['disposal_tips'] as String? ?? '',
      isUncertain: result['is_uncertain'] as bool? ?? true,
      explanation: result['explanation'] as String? ?? '',
      topLabels: rawLabels?.map((l) => LabelInfo.fromJson(l)).toList() ?? [],
      diySuggestions: suggestions?.map((s) => DiySuggestionItem.fromJson(s)).toList() ?? [],
      cached: json['cached'] as bool? ?? false,
    );
  }
}

class LabelInfo {
  final String label;
  final double confidence;

  const LabelInfo({required this.label, required this.confidence});

  factory LabelInfo.fromJson(Map<String, dynamic> json) {
    return LabelInfo(
      label: json['label'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
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

