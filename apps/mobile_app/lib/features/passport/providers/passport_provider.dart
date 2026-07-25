import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/passport/data/passport_repository.dart';
import 'package:mobile_app/features/passport/models/passport_data.dart';

class ImpactNotifier extends AsyncNotifier<ImpactData> {
  @override
  Future<ImpactData> build() async {
    return ref.read(passportRepositoryProvider).getImpact();
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final impactProvider =
    AsyncNotifierProvider<ImpactNotifier, ImpactData>(ImpactNotifier.new);

class TimelineNotifier extends AsyncNotifier<List<TimelineEntry>> {
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<TimelineEntry>> build() async {
    _page = 1;
    _hasMore = true;
    return ref.read(passportRepositoryProvider).getTimeline(page: 1);
  }

  bool get hasMore => _hasMore;

  Future<void> loadMore() async {
    _page++;
    final more = await ref.read(passportRepositoryProvider).getTimeline(page: _page);
    if (more.isEmpty) {
      _hasMore = false;
    }
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, ...more]);
  }

  Future<void> reload() async {
    _page = 1;
    _hasMore = true;
    ref.invalidateSelf();
    await future;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineNotifier, List<TimelineEntry>>(TimelineNotifier.new);

class StreakNotifier extends AsyncNotifier<StreakData> {
  @override
  Future<StreakData> build() async {
    return ref.read(passportRepositoryProvider).getStreak();
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final streakProvider =
    AsyncNotifierProvider<StreakNotifier, StreakData>(StreakNotifier.new);
