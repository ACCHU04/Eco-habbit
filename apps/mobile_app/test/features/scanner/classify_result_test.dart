import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/scanner/models/classify_result.dart';
import 'package:mobile_app/features/scanner/models/scan_result_data.dart';

void main() {
  group('ClassifyResult', () {
    test('parses from JSON correctly', () {
      final json = {
        'result': {
          'category': 'plastic',
          'confidence': 0.94,
          'disposal_tips': 'Rinse and recycle.',
          'is_uncertain': false,
          'explanation': 'I identified this as plastic because the image '
              'most closely resembles **plastic_bottle** (94% confidence), '
              'followed by **bottle** (3%).',
          'top_labels': [
            {'label': 'plastic_bottle', 'confidence': 0.94},
            {'label': 'bottle', 'confidence': 0.03},
          ],
        },
        'diy_suggestions': [
          {
            'project_id': 'p1',
            'title': 'Bottle Planter',
            'difficulty': 'easy',
            'estimated_time': '30 min',
            'estimated_price': 150,
            'materials': ['Bottle', 'Scissors'],
            'thumbnail_url': null,
          },
        ],
        'cached': false,
      };

      final result = ClassifyResult.fromJson(json);

      expect(result.category, 'plastic');
      expect(result.confidence, 0.94);
      expect(result.disposalTips, 'Rinse and recycle.');
      expect(result.isUncertain, false);
      expect(result.explanation, contains('plastic_bottle'));
      expect(result.topLabels.length, 2);
      expect(result.topLabels[0].label, 'plastic_bottle');
      expect(result.topLabels[0].confidence, 0.94);
      expect(result.diySuggestions.length, 1);
      expect(result.diySuggestions[0].title, 'Bottle Planter');
      expect(result.cached, false);
    });

    test('handles empty/malformed JSON gracefully', () {
      final result = ClassifyResult.fromJson({});

      expect(result.category, 'others');
      expect(result.confidence, 0.0);
      expect(result.isUncertain, true);
      expect(result.explanation, '');
      expect(result.topLabels, isEmpty);
      expect(result.diySuggestions, isEmpty);
    });
  });

  group('LabelInfo', () {
    test('parses from JSON', () {
      final label = LabelInfo.fromJson({'label': 'plastic_bottle', 'confidence': 0.94});
      expect(label.label, 'plastic_bottle');
      expect(label.confidence, 0.94);
    });
  });

  group('ScanResultData', () {
    test('creates from ClassifyResult', () {
      const result = ClassifyResult(
        category: 'glass',
        confidence: 0.88,
        disposalTips: 'Recycle in glass bin.',
        isUncertain: false,
        diySuggestions: [],
        cached: false,
      );

      final data = ScanResultData.fromResult(result, '/tmp/image.jpg');

      expect(data.imagePath, '/tmp/image.jpg');
      expect(data.category, 'glass');
      expect(data.confidence, 0.88);
      expect(data.disposalTips, 'Recycle in glass bin.');
      expect(data.isUncertain, false);
      expect(data.explanation, '');
      expect(data.topLabels, isEmpty);
      expect(data.diySuggestions, isEmpty);
    });
  });
}
