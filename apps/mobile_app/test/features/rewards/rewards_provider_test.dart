import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/features/rewards/data/rewards_repository.dart';
import 'package:mobile_app/features/rewards/models/reward_models.dart';
import 'package:mobile_app/features/rewards/providers/rewards_provider.dart';

@GenerateMocks([RewardsRepository])
import 'rewards_provider_test.mocks.dart';

void main() {
  late MockRewardsRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockRewardsRepository();
    container = ProviderContainer(
      overrides: [
        rewardsRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PointsNotifier', () {
    test('loads total points', () async {
      when(mockRepo.getUserPoints()).thenAnswer((_) async => const UserPoints(totalPoints: 1250));

      final result = await container.read(pointsProvider.future);

      expect(result.totalPoints, 1250);
      verify(mockRepo.getUserPoints()).called(1);
    });

    test('handles API failure', () async {
      when(mockRepo.getUserPoints()).thenThrow(Exception('Network error'));

      expect(
        () => container.read(pointsProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('PointsHistoryNotifier', () {
    test('loads paginated history', () async {
      when(mockRepo.getPointsHistory(page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => PaginatedPointsHistory(
            items: [PointsHistoryItem(id: '1', action: 'ai_scan', points: 5, createdAt: DateTime(2026))],
            page: 1, limit: 20, total: 1, totalPages: 1,
          ));

      final result = await container.read(pointsHistoryProvider.future);

      expect(result.items, hasLength(1));
      expect(result.items[0].points, 5);
    });

    test('loads more pages', () async {
      when(mockRepo.getPointsHistory(page: 1, limit: 20))
          .thenAnswer((_) async => PaginatedPointsHistory(
            items: [PointsHistoryItem(id: '1', action: 'ai_scan', points: 5, createdAt: DateTime(2026))],
            page: 1, limit: 20, total: 2, totalPages: 2,
          ));
      when(mockRepo.getPointsHistory(page: 2, limit: 20))
          .thenAnswer((_) async => PaginatedPointsHistory(
            items: [PointsHistoryItem(id: '2', action: 'list_item', points: 10, createdAt: DateTime(2026))],
            page: 2, limit: 20, total: 2, totalPages: 2,
          ));

      await container.read(pointsHistoryProvider.future);
      await container.read(pointsHistoryProvider.notifier).loadMore();

      final result = container.read(pointsHistoryProvider).value;
      expect(result!.items, hasLength(2));
    });
  });

  group('BadgesNotifier', () {
    test('loads user badges', () async {
      when(mockRepo.getBadges()).thenAnswer((_) async => [
        Badge(id: 'b1', badgeType: 'first_sale', earnedAt: DateTime(2026)),
        Badge(id: 'b2', badgeType: 'recycler', earnedAt: DateTime(2026)),
      ]);

      final result = await container.read(badgesProvider.future);

      expect(result, hasLength(2));
      expect(result[0].badgeType, 'first_sale');
    });
  });

  group('LeaderboardNotifier', () {
    test('loads leaderboard entries', () async {
      when(mockRepo.getLeaderboard(limit: anyNamed('limit'))).thenAnswer((_) async => [
        const LeaderboardEntry(userId: 'u1', fullName: 'Priya', totalPoints: 2450, rank: 1),
        const LeaderboardEntry(userId: 'u2', fullName: 'Rahul', totalPoints: 980, rank: 2),
      ]);

      final result = await container.read(leaderboardProvider.future);

      expect(result, hasLength(2));
      expect(result[0].rank, 1);
      expect(result[0].totalPoints, 2450);
    });
  });
}
