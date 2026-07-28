import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/engagement/models/achievement_models.dart';

void main() {
  group('Achievement', () {
    test('fromJson parses all fields', () {
      final json = {
        'key': 'first_scan',
        'title': 'First Scan',
        'description': 'Scan your first item',
        'icon': '🔍',
        'target': 1,
        'current': 1,
        'completed': true,
      };
      final a = Achievement.fromJson(json);
      expect(a.key, 'first_scan');
      expect(a.title, 'First Scan');
      expect(a.description, 'Scan your first item');
      expect(a.icon, '🔍');
      expect(a.target, 1);
      expect(a.current, 1);
      expect(a.completed, isTrue);
    });

    test('fromJson defaults when missing', () {
      final a = Achievement.fromJson({});
      expect(a.key, '');
      expect(a.title, '');
      expect(a.description, '');
      expect(a.icon, '');
      expect(a.target, 1);
      expect(a.current, 0);
      expect(a.completed, isFalse);
    });

    test('progress computes correctly', () {
      final a = Achievement.fromJson({
        'target': 10,
        'current': 5,
      });
      expect(a.progress, 0.5);
    });

    test('progress returns 0 when target is 0', () {
      final a = Achievement.fromJson({
        'target': 0,
        'current': 5,
      });
      expect(a.progress, 0);
    });

    test('progress returns 0 when target is negative', () {
      final a = Achievement.fromJson({
        'target': -1,
        'current': 5,
      });
      expect(a.progress, 0);
    });

    test('progress returns 1.0 when completed', () {
      final a = Achievement.fromJson({
        'target': 5,
        'current': 5,
        'completed': true,
      });
      expect(a.progress, 1.0);
    });

    test('progress returns >1.0 when current exceeds target', () {
      final a = Achievement.fromJson({
        'target': 3,
        'current': 6,
      });
      expect(a.progress, 2.0);
    });

    test('fromJson handles null completed field', () {
      final a = Achievement.fromJson({'completed': null});
      expect(a.completed, isFalse);
    });

    test('fromJson handles null current field', () {
      final a = Achievement.fromJson({'current': null});
      expect(a.current, 0);
    });

    test('fromJson handles null target field', () {
      final a = Achievement.fromJson({'target': null});
      expect(a.target, 1);
    });
  });
}
