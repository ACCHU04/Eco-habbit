import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/home/screens/home_screen.dart';
import 'package:mobile_app/features/home/providers/home_provider.dart';
import 'package:mobile_app/features/home/models/dashboard_data.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/quests/providers/quests_provider.dart';
import 'package:mobile_app/features/quests/models/quest.dart';
import 'package:mobile_app/features/coins/providers/coins_provider.dart';
import 'package:mobile_app/features/coins/models/coin_balance.dart';
import 'package:mobile_app/features/profile/providers/profile_provider.dart';
import 'package:mobile_app/features/profile/models/user_stats.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('HomeScreen', () {
    Widget buildHome({
      AsyncValue<AuthData> authState =
          const AsyncValue.data(AuthData(user: testUser)),
      AsyncValue<DashboardData> dashboardState =
          const AsyncValue.data(DashboardData(points: 150, recentListings: [])),
      AsyncValue<List<Quest>> questsState =
          const AsyncValue.data([]),
      AsyncValue<CoinBalance> coinState =
          const AsyncValue.data(CoinBalance(userId: 'test-user-id', totalCoins: 50)),
      AsyncValue<UserStats> statsState =
          const AsyncValue.data(UserStats(listingsCount: 2, totalPoints: 150, badgesCount: 3, badges: [])),
    }) {
      return buildTestWidget(
        const HomeScreen(),
        initialLocation: '/home',
        overrides: [
          authOverride(initial: authState),
          dashboardProvider.overrideWith(() => _FakeDashboardNotifier(dashboardState)),
          todayQuestsProvider.overrideWith(() => _FakeTodayQuestsNotifier(questsState)),
          coinBalanceProvider.overrideWith(() => _FakeCoinBalanceNotifier(coinState)),
          profileStatsProvider.overrideWith(() => _FakeProfileStatsNotifier(statsState)),
        ],
        destinationRoutes: {
          '/notifications': (_, __) => const Scaffold(body: Text('notifications-page')),
          '/scanner': (_, __) => const Scaffold(body: Text('scanner-page')),
          '/create-listing': (_, __) => const Scaffold(body: Text('create-listing-page')),
          '/diy': (_, __) => const Scaffold(body: Text('diy-page')),
          '/marketplace': (_, __) => const Scaffold(body: Text('marketplace-page')),
          '/quests': (_, __) => const Scaffold(body: Text('quests-page')),
          '/wallet': (_, __) => const Scaffold(body: Text('wallet-page')),
          '/rewards': (_, __) => const Scaffold(body: Text('rewards-page')),
          '/my-listings': (_, __) => const Scaffold(body: Text('my-listings-page')),
          '/settings': (_, __) => const Scaffold(body: Text('settings-page')),
        },
      );
    }

    testWidgets('renders welcome message with user first name', (tester) async {
      await tester.pumpWidget(buildHome());
      await tester.pumpAndSettle();

      expect(find.textContaining('Welcome back, Test'), findsOneWidget);
      expect(find.text('Test College'), findsOneWidget);
    });

    testWidgets('shows quick action buttons', (tester) async {
      await tester.pumpWidget(buildHome());
      await tester.pumpAndSettle();

      expect(find.text('Scan Item'), findsOneWidget);
      expect(find.text('Sell Item'), findsOneWidget);
      expect(find.text('DIY Projects'), findsOneWidget);
    });

    testWidgets('shows today quests section', (tester) async {
      await tester.pumpWidget(buildHome());
      await tester.pumpAndSettle();

      expect(find.text("Today's Quests"), findsOneWidget);
    });

    testWidgets('shows quest cards when quests are loaded', (tester) async {
      final quests = [
        const Quest(
          id: 'q1', title: 'First Scan', description: 'Scan an item',
          questType: 'daily', xpReward: 25, coinReward: 5,
          difficulty: 'easy', targetAction: 'scan_item', targetCount: 1,
        ),
      ];
      await tester.pumpWidget(buildHome(questsState: AsyncValue.data(quests)));
      await tester.pumpAndSettle();

      expect(find.text('First Scan'), findsOneWidget);
    });

    testWidgets('shows hero stats with points and coins', (tester) async {
      await tester.pumpWidget(buildHome());
      await tester.pumpAndSettle();

      expect(find.text('150'), findsWidgets);
      expect(find.text('50'), findsOneWidget);
    });
  });
}

class _FakeDashboardNotifier extends AsyncNotifier<DashboardData>
    implements DashboardNotifier {
  final AsyncValue<DashboardData>? _initial;
  _FakeDashboardNotifier(this._initial);

  @override
  Future<DashboardData> build() async {
    final initial = _initial;
    if (initial == null || initial.isLoading) {
      await Completer<DashboardData>().future;
    }
    return initial!.value!;
  }

  @override
  Future<void> reload() async {}
}

class _FakeTodayQuestsNotifier extends AsyncNotifier<List<Quest>>
    implements TodayQuestsNotifier {
  final AsyncValue<List<Quest>>? _initial;
  _FakeTodayQuestsNotifier(this._initial);

  @override
  Future<List<Quest>> build() async {
    final initial = _initial;
    if (initial == null || initial.isLoading) {
      await Completer<List<Quest>>().future;
    }
    return initial!.value!;
  }

  @override
  Future<QuestProgressResult?> completeQuest(String questId) async => null;

  @override
  Future<void> reload() async {}
}

class _FakeCoinBalanceNotifier extends AsyncNotifier<CoinBalance>
    implements CoinBalanceNotifier {
  final AsyncValue<CoinBalance>? _initial;
  _FakeCoinBalanceNotifier(this._initial);

  @override
  Future<CoinBalance> build() async {
    final initial = _initial;
    if (initial == null || initial.isLoading) {
      await Completer<CoinBalance>().future;
    }
    return initial!.value!;
  }

  @override
  Future<void> reload() async {}
}

class _FakeProfileStatsNotifier extends AsyncNotifier<UserStats>
    implements ProfileStatsNotifier {
  final AsyncValue<UserStats>? _initial;
  _FakeProfileStatsNotifier(this._initial);

  @override
  Future<UserStats> build() async {
    final initial = _initial;
    if (initial == null || initial.isLoading) {
      await Completer<UserStats>().future;
    }
    return initial!.value!;
  }

  @override
  Future<void> reload() async {}
}
