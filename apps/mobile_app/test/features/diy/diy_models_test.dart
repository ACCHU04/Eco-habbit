import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/diy/models/diy_project_model.dart';
import 'package:mobile_app/features/diy/models/diy_filters.dart';

void main() {
  group('DiyProject', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'p1',
        'title': 'Bottle Planter',
        'description': 'A fun project',
        'difficulty': 'easy',
        'estimated_time': '30 minutes',
        'estimated_price': 150,
        'materials': ['Bottle', 'Scissors'],
        'steps': ['Cut', 'Paint'],
        'image_url': 'https://example.com/img.jpg',
        'tutorial_url': 'https://example.com/tutorial',
      };
      final project = DiyProject.fromJson(json);
      expect(project.id, 'p1');
      expect(project.title, 'Bottle Planter');
      expect(project.description, 'A fun project');
      expect(project.difficulty, 'easy');
      expect(project.estimatedTime, '30 minutes');
      expect(project.estimatedPrice, 150);
      expect(project.materials, ['Bottle', 'Scissors']);
      expect(project.steps, ['Cut', 'Paint']);
      expect(project.imageUrl, 'https://example.com/img.jpg');
      expect(project.tutorialUrl, 'https://example.com/tutorial');
    });

    test('fromJson applies defaults for missing optional fields', () {
      final project = DiyProject.fromJson({'id': 'p1', 'title': 'Test'});
      expect(project.description, '');
      expect(project.difficulty, 'easy');
      expect(project.estimatedTime, '30 minutes');
      expect(project.estimatedPrice, 0);
      expect(project.materials, isEmpty);
      expect(project.steps, isEmpty);
      expect(project.imageUrl, isNull);
      expect(project.tutorialUrl, isNull);
    });

    test('toJson serializes all fields to snake_case', () {
      const project = DiyProject(
        id: 'p1',
        title: 'Test',
        description: 'Desc',
        difficulty: 'medium',
        estimatedTime: '1 hour',
        estimatedPrice: 200,
        materials: ['A'],
        steps: ['Step 1'],
        imageUrl: 'https://example.com/img.jpg',
        tutorialUrl: 'https://example.com/tutorial',
      );
      final json = project.toJson();
      expect(json['id'], 'p1');
      expect(json['title'], 'Test');
      expect(json['description'], 'Desc');
      expect(json['difficulty'], 'medium');
      expect(json['estimated_time'], '1 hour');
      expect(json['estimated_price'], 200);
      expect(json['materials'], ['A']);
      expect(json['steps'], ['Step 1']);
      expect(json['image_url'], 'https://example.com/img.jpg');
      expect(json['tutorial_url'], 'https://example.com/tutorial');
    });

    test('fromJson toJson round-trip preserves data', () {
      final json = {
        'id': 'p1',
        'title': 'Test',
        'materials': ['A', 'B'],
        'steps': ['S1'],
      };
      final project = DiyProject.fromJson(json);
      final result = project.toJson();
      expect(result['id'], json['id']);
      expect(result['title'], json['title']);
      expect(result['materials'], ['A', 'B']);
      expect(result['steps'], ['S1']);
    });

    test('sample constant has expected values', () {
      expect(DiyProject.sample.id, 'sample-1');
      expect(DiyProject.sample.title, 'Plastic Bottle Planter');
      expect(DiyProject.sample.materials, isNotEmpty);
      expect(DiyProject.sample.steps, isNotEmpty);
      expect(DiyProject.sample.difficulty, 'easy');
    });
  });

  group('DiyFilters', () {
    test('copyWith sets new category', () {
      const filters = DiyFilters();
      final updated = filters.copyWith(category: 'furniture');
      expect(updated.category, 'furniture');
    });

    test('copyWith clears category with clearCategory flag', () {
      const filters = DiyFilters(category: 'furniture');
      final updated = filters.copyWith(clearCategory: true);
      expect(updated.category, isNull);
    });

    test('copyWith clears difficulty with clearDifficulty flag', () {
      const filters = DiyFilters(difficulty: 'hard');
      final updated = filters.copyWith(clearDifficulty: true);
      expect(updated.difficulty, isNull);
    });

    test('copyWith preserves existing values when no args provided', () {
      const filters = DiyFilters(
        search: 'test',
        category: 'furniture',
        difficulty: 'easy',
      );
      final copy = filters.copyWith();
      expect(copy.search, 'test');
      expect(copy.category, 'furniture');
      expect(copy.difficulty, 'easy');
    });

    test('copyWith updates search independently', () {
      const filters = DiyFilters(category: 'furniture');
      final updated = filters.copyWith(search: 'chair');
      expect(updated.search, 'chair');
      expect(updated.category, 'furniture');
    });
  });
}
