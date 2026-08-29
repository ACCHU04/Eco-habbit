import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/screens/register_screen.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('RegisterScreen', () {
    Widget buildRegister({
      AsyncValue<AuthData> authState = const AsyncValue.data(AuthData()),
      bool shouldFail = false,
    }) {
      return buildTestWidget(
        const RegisterScreen(),
        initialLocation: '/register',
        overrides: [authOverride(initial: authState, shouldFail: shouldFail)],
        destinationRoutes: {
          '/login': (_, __) => const Scaffold(body: Text('login-page')),
          '/role-selection': (_, __) => const Scaffold(body: Text('role-selection-page')),
        },
      );
    }

    testWidgets('renders all form fields and Create Account button', (tester) async {
      await tester.pumpWidget(buildRegister());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'College Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'College / University'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Create Account'), findsOneWidget);
    });

    testWidgets('shows validation errors when form is submitted empty', (tester) async {
      await tester.pumpWidget(buildRegister());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Name required'), findsOneWidget);
      expect(find.text('Email required'), findsOneWidget);
      expect(find.text('College required'), findsOneWidget);
      expect(find.text('Password required'), findsOneWidget);
    });

    testWidgets('shows loading indicator during registration', (tester) async {
      await tester.pumpWidget(buildRegister());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'Test User');
      await tester.enterText(find.widgetWithText(TextFormField, 'College Email'), 'test@college.edu');
      await tester.enterText(find.widgetWithText(TextFormField, 'College / University'), 'Test College');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Advance past the fake delay to clean up timers
      await tester.pump(const Duration(milliseconds: 20));
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message when registration fails', (tester) async {
      await tester.pumpWidget(buildRegister(shouldFail: true));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'Test User');
      await tester.enterText(find.widgetWithText(TextFormField, 'College Email'), 'test@college.edu');
      await tester.enterText(find.widgetWithText(TextFormField, 'College / University'), 'Test College');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Email already registered'), findsOneWidget);
    });

    testWidgets('navigates to /login when Log In is tapped', (tester) async {
      await tester.pumpWidget(buildRegister());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('login-page'), findsOneWidget);
    });
  });
}
