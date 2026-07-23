import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/home/screens/home_screen.dart';
import 'package:mobile_app/features/home/providers/home_provider.dart';
import 'package:mobile_app/features/home/models/dashboard_data.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('HomeScreen', () {
    Widget buildHome({
      AsyncValue<AuthData> authState =
          const AsyncValue.data(AuthData(user: testUser)),
      AsyncValue<DashboardData> dashboardState =
          const AsyncValue.data(DashboardData(points: 150, recentListings: [])),
    }) {
      return buildTestWidget(
        const HomeScreen(),
        initialLocation: '/home',
        overrides: [
          authOverride(initial: authState),
          dashboardProvider.overrideWith(() => _FakeDashboardNotifier(dashboardState)),
        ],
        destinationRoutes: {
          '/notifications': (_, __) => const Scaffold(body: Text('notifications-page')),
          '/scanner': (_, __) => const Scaffold(body: Text('scanner-page')),
          '/create-listing': (_, __) => const Scaffold(body: Text('create-listing-page')),
          '/diy': (_, __) => const Scaffold(body: Text('diy-page')),
          '/marketplace': (_, __) => const Scaffold(body: Text('marketplace-page')),
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

    testWidgets('shows loading indicator while dashboard loads', (tester) async {
      await tester.pumpWidget(buildHome(
        dashboardState: const AsyncValue.loading(),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows empty state when no recent listings', (tester) async {
      await tester.pumpWidget(buildHome());
      await tester.pumpAndSettle();

      expect(find.text('No listings yet. Items you save will appear here.'), findsOneWidget);
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
