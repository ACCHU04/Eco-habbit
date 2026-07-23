import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/screens/role_selection_screen.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('RoleSelectionScreen', () {
    Widget buildRoleSelection({
      AsyncValue<AuthData> authState =
          const AsyncValue.data(AuthData(user: testUser)),
    }) {
      return buildTestWidget(
        const RoleSelectionScreen(),
        initialLocation: '/role-selection',
        overrides: [authOverride(initial: authState)],
        destinationRoutes: {
          '/profile-setup': (_, __) => const Scaffold(body: Text('profile-setup-page')),
        },
      );
    }

    testWidgets('renders three role options', (tester) async {
      await tester.pumpWidget(buildRoleSelection());
      await tester.pumpAndSettle();

      expect(find.text('Student'), findsOneWidget);
      expect(find.text('NGO'), findsOneWidget);
      expect(find.text('Organization'), findsOneWidget);
    });

    testWidgets('Continue button is disabled when no role is selected', (tester) async {
      await tester.pumpWidget(buildRoleSelection());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continue'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Continue button becomes enabled after selecting a role', (tester) async {
      await tester.pumpWidget(buildRoleSelection());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Student'));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continue'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('navigates to /profile-setup on continue', (tester) async {
      await tester.pumpWidget(buildRoleSelection());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Student'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
      await tester.pumpAndSettle();

      expect(find.text('profile-setup-page'), findsOneWidget);
    });
  });
}
