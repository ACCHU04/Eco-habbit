import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/engagement/data/engagement_repository.dart';
import 'package:mobile_app/features/engagement/models/leaderboard_models.dart';
import 'package:mobile_app/features/engagement/models/hostel_models.dart';
import 'package:mobile_app/features/engagement/models/challenge_models.dart';
import 'package:mobile_app/features/engagement/models/achievement_models.dart';

// ── Leaderboard Providers ──

class FilteredLeaderboardNotifier extends AsyncNotifier<List<LeaderboardEntry>> {
  String _filter = 'campus';
  String? _value;

  @override
  Future<List<LeaderboardEntry>> build() async {
    return ref.read(engagementRepositoryProvider).getFilteredLeaderboard(
          filter: _filter,
          value: _value,
        );
  }

  Future<void> setFilter(String filter, {String? value}) async {
    _filter = filter;
    _value = value;
    ref.invalidateSelf();
  }
}

final filteredLeaderboardProvider =
    AsyncNotifierProvider<FilteredLeaderboardNotifier, List<LeaderboardEntry>>(
  FilteredLeaderboardNotifier.new,
);

class FriendLeaderboardNotifier extends AsyncNotifier<List<LeaderboardEntry>> {
  @override
  Future<List<LeaderboardEntry>> build() async {
    return ref.read(engagementRepositoryProvider).getFriendLeaderboard();
  }
}

final friendLeaderboardProvider =
    AsyncNotifierProvider<FriendLeaderboardNotifier, List<LeaderboardEntry>>(
  FriendLeaderboardNotifier.new,
);

class HostelLeaderboardNotifier extends AsyncNotifier<List<HostelEntry>> {
  @override
  Future<List<HostelEntry>> build() async {
    return ref.read(engagementRepositoryProvider).getHostelLeaderboard();
  }
}

final hostelLeaderboardProvider =
    AsyncNotifierProvider<HostelLeaderboardNotifier, List<HostelEntry>>(
  HostelLeaderboardNotifier.new,
);

class PeriodLeaderboardNotifier extends AsyncNotifier<List<LeaderboardEntry>> {
  String _period = 'weekly';
  String _filter = 'campus';
  String? _value;

  @override
  Future<List<LeaderboardEntry>> build() async {
    return ref.read(engagementRepositoryProvider).getPeriodLeaderboard(
          period: _period,
          filter: _filter,
          value: _value,
        );
  }

  Future<void> setPeriod(String period, {String filter = 'campus', String? value}) async {
    _period = period;
    _filter = filter;
    _value = value;
    ref.invalidateSelf();
  }
}

final periodLeaderboardProvider =
    AsyncNotifierProvider<PeriodLeaderboardNotifier, List<LeaderboardEntry>>(
  PeriodLeaderboardNotifier.new,
);

// ── Hostel Providers ──

class HostelsNotifier extends AsyncNotifier<List<Hostel>> {
  @override
  Future<List<Hostel>> build() async {
    return ref.read(engagementRepositoryProvider).getHostels();
  }
}

final hostelsProvider = AsyncNotifierProvider<HostelsNotifier, List<Hostel>>(
  HostelsNotifier.new,
);

class BattlesNotifier extends AsyncNotifier<List<HostelBattle>> {
  @override
  Future<List<HostelBattle>> build() async {
    return ref.read(engagementRepositoryProvider).getBattles();
  }
}

final battlesProvider = AsyncNotifierProvider<BattlesNotifier, List<HostelBattle>>(
  BattlesNotifier.new,
);

// ── Challenge / Friend Providers ──

class FriendsNotifier extends AsyncNotifier<List<Friend>> {
  @override
  Future<List<Friend>> build() async {
    return ref.read(engagementRepositoryProvider).getFriends();
  }
}

final friendsProvider = AsyncNotifierProvider<FriendsNotifier, List<Friend>>(
  FriendsNotifier.new,
);

class PendingRequestsNotifier extends AsyncNotifier<List<FriendRequest>> {
  @override
  Future<List<FriendRequest>> build() async {
    return ref.read(engagementRepositoryProvider).getPendingRequests();
  }
}

final pendingRequestsProvider =
    AsyncNotifierProvider<PendingRequestsNotifier, List<FriendRequest>>(
  PendingRequestsNotifier.new,
);

class ChallengesNotifier extends AsyncNotifier<List<FriendChallenge>> {
  @override
  Future<List<FriendChallenge>> build() async {
    return ref.read(engagementRepositoryProvider).getMyChallenges();
  }
}

final challengesProvider =
    AsyncNotifierProvider<ChallengesNotifier, List<FriendChallenge>>(
  ChallengesNotifier.new,
);

// ── Achievement Providers ──

class AchievementsNotifier extends AsyncNotifier<List<Achievement>> {
  @override
  Future<List<Achievement>> build() async {
    return ref.read(engagementRepositoryProvider).getAchievements();
  }
}

final achievementsProvider =
    AsyncNotifierProvider<AchievementsNotifier, List<Achievement>>(
  AchievementsNotifier.new,
);
