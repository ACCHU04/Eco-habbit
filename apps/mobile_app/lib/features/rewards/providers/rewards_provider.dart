import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/rewards/data/rewards_repository.dart';
import 'package:mobile_app/features/rewards/models/reward_models.dart';

class PointsNotifier extends AsyncNotifier<UserPoints> {
  @override
  Future<UserPoints> build() async {
    return ref.read(rewardsRepositoryProvider).getUserPoints();
  }
}

final pointsProvider = AsyncNotifierProvider<PointsNotifier, UserPoints>(
  PointsNotifier.new,
);

class PointsHistoryNotifier extends AsyncNotifier<PaginatedPointsHistory> {
  @override
  Future<PaginatedPointsHistory> build() async {
    return ref.read(rewardsRepositoryProvider).getPointsHistory();
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    state = AsyncValue.data(current);
    try {
      final next = await ref.read(rewardsRepositoryProvider).getPointsHistory(
        page: current.page + 1,
        limit: current.limit,
      );
      state = AsyncValue.data(PaginatedPointsHistory(
        items: [...current.items, ...next.items],
        page: next.page,
        limit: next.limit,
        total: next.total,
        totalPages: next.totalPages,
      ));
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }
}

final pointsHistoryProvider = AsyncNotifierProvider<PointsHistoryNotifier, PaginatedPointsHistory>(
  PointsHistoryNotifier.new,
);

class BadgesNotifier extends AsyncNotifier<List<Badge>> {
  @override
  Future<List<Badge>> build() async {
    return ref.read(rewardsRepositoryProvider).getBadges();
  }
}

final badgesProvider = AsyncNotifierProvider<BadgesNotifier, List<Badge>>(
  BadgesNotifier.new,
);

class LeaderboardNotifier extends AsyncNotifier<List<LeaderboardEntry>> {
  @override
  Future<List<LeaderboardEntry>> build() async {
    return ref.read(rewardsRepositoryProvider).getLeaderboard();
  }
}

final leaderboardProvider = AsyncNotifierProvider<LeaderboardNotifier, List<LeaderboardEntry>>(
  LeaderboardNotifier.new,
);
