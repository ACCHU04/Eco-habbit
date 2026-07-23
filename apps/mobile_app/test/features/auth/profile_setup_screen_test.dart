import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/screens/profile_setup_screen.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('ProfileSetupScreen', () {
    Widget buildProfileSetup({
      AsyncValue<AuthData> authState =
          const AsyncValue.data(AuthData(user: testUser)),
    }) {
      return buildTestWidget(
        const ProfileSetupScreen(),
        initialLocation: '/profile-setup',
        overrides: [authOverride(initial: authState)],
        destinationRoutes: {
          '/home': (_, __) => const Scaffold(body: Text('home-page')),
        },
      );
    }

    testWidgets('renders avatar options and bio text field', (tester) async {
      await tester.pumpWidget(buildProfileSetup());
      await tester.pumpAndSettle();

      expect(find.text('Choose your avatar'), findsOneWidget);
      expect(find.text('🧑‍🎓'), findsOneWidget);
      expect(find.text('👩‍💻'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Get Started button shows loading during save', (tester) async {
      await tester.pumpWidget(buildProfileSetup());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to /home after profile setup completes', (tester) async {
      await tester.pumpWidget(buildProfileSetup());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
      await tester.pumpAndSettle();

      expect(find.text('home-page'), findsOneWidget);
    });
  });
}
