import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/screens/login_screen.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('LoginScreen', () {
    Widget buildLogin({
      AsyncValue<AuthData> authState = const AsyncValue.data(AuthData()),
      bool shouldFail = false,
    }) {
      return buildTestWidget(
        const LoginScreen(),
        initialLocation: '/login',
        overrides: [authOverride(initial: authState, shouldFail: shouldFail)],
        destinationRoutes: {
          '/register': (_, __) => const Scaffold(body: Text('register-page')),
          '/home': (_, __) => const Scaffold(body: Text('home-page')),
        },
      );
    }

    testWidgets('renders email field, password field, and Log In button', (tester) async {
      await tester.pumpWidget(buildLogin());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Log In'), findsOneWidget);
    });

    testWidgets('shows validation errors when form is submitted empty', (tester) async {
      await tester.pumpWidget(buildLogin());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Email required'), findsOneWidget);
      expect(find.text('Password required'), findsOneWidget);
    });

    testWidgets('shows loading indicator during login', (tester) async {
      await tester.pumpWidget(buildLogin());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@college.edu');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Advance past the fake delay to clean up timers
      await tester.pump(const Duration(milliseconds: 20));
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message when login fails', (tester) async {
      await tester.pumpWidget(buildLogin(shouldFail: true));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@college.edu');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('navigates to /register when Sign Up is tapped', (tester) async {
      await tester.pumpWidget(buildLogin());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Sign Up'));
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('register-page'), findsOneWidget);
    });
  });
}
