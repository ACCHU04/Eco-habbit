import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/features/diy/data/diy_repository.dart';
import 'package:mobile_app/features/diy/models/diy_project_model.dart';
import 'package:mobile_app/features/diy/providers/diy_provider.dart';

import 'diy_provider_test.mocks.dart';

@GenerateMocks([DiyRepository])
void main() {
  late MockDiyRepository mockRepo;
  late ProviderContainer container;

  const testProject = DiyProject(
    id: 'p1', title: 'Bottle Planter', description: 'Turn bottles into planters',
    difficulty: 'easy', estimatedTime: '30 min', estimatedPrice: 150,
    materials: ['Bottle', 'Scissors'], steps: ['Cut', 'Paint'],
  );

  setUp(() {
    mockRepo = MockDiyRepository();
    container = ProviderContainer(
      overrides: [diyRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() => container.dispose());

  group('DiyProjectsNotifier', () {
    test('loads projects successfully', () async {
      when(mockRepo.getProjects(filters: anyNamed('filters'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => const PaginatedProjects(
            projects: [testProject], page: 1, limit: 20, total: 1, totalPages: 1,
          ));

      final result = await container.read(diyProjectsProvider.future);
      expect(result.projects.length, 1);
      expect(result.projects[0].title, 'Bottle Planter');
    });
  });

  group('DiyDetailProvider', () {
    test('loads project by ID', () async {
      when(mockRepo.getProject('p1')).thenAnswer((_) async => testProject);

      final result = await container.read(diyDetailProvider('p1').future);
      expect(result.id, 'p1');
      expect(result.title, 'Bottle Planter');
    });

    test('not found throws', () async {
      when(mockRepo.getProject('missing')).thenThrow(Exception('not found'));

      final future = container.read(diyDetailProvider('missing').future);
      expect(future, throwsException);
    });
  });

  group('SavedProjectsNotifier', () {
    test('loads saved projects', () async {
      const saved = SavedProject(savedId: 's1', project: testProject);
      when(mockRepo.getSavedProjects()).thenAnswer((_) async => [saved]);

      final result = await container.read(savedProjectsProvider.future);
      expect(result.length, 1);
      expect(result[0].project.title, 'Bottle Planter');
    });

    test('empty saved list', () async {
      when(mockRepo.getSavedProjects()).thenAnswer((_) async => []);

      final result = await container.read(savedProjectsProvider.future);
      expect(result, isEmpty);
    });
  });
}
