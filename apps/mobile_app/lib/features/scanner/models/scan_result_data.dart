import 'package:mobile_app/features/scanner/models/classify_result.dart';

class ScanResultData {
  final String imagePath;
  final String category;
  final double confidence;
  final String disposalTips;
  final bool isUncertain;
  final String explanation;
  final List<LabelInfo> topLabels;
  final List<DiySuggestionItem> diySuggestions;

  const ScanResultData({
    required this.imagePath,
    required this.category,
    required this.confidence,
    required this.disposalTips,
    required this.isUncertain,
    this.explanation = '',
    this.topLabels = const [],
    required this.diySuggestions,
  });

  factory ScanResultData.fromResult(ClassifyResult result, String imagePath) {
    return ScanResultData(
      imagePath: imagePath,
      category: result.category,
      confidence: result.confidence,
      disposalTips: result.disposalTips,
      isUncertain: result.isUncertain,
      explanation: result.explanation,
      topLabels: result.topLabels,
      diySuggestions: result.diySuggestions,
    );
  }
}
