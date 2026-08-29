import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/auth/models/user_model.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

const testUser = UserModel(
  id: 'test-user-id',
  email: 'test@college.edu',
  fullName: 'Test User',
  college: 'Test College',
  role: 'student',
);

const unauthenticatedData = AuthData();

AuthData authenticatedData([UserModel? user]) =>
    AuthData(user: user ?? testUser);

class FakeAuthNotifier extends StateNotifier<AsyncValue<AuthData>>
    implements AuthNotifier {
  bool shouldFail;
  bool loginCalled = false;
  bool registerCalled = false;

  FakeAuthNotifier({
    AsyncValue<AuthData> initial = const AsyncValue.data(AuthData()),
    this.shouldFail = false,
  }) : super(initial);

  @override
  AuthState get authState =>
      state.valueOrNull?.user != null
          ? AuthState.authenticated
          : AuthState.unauthenticated;

  @override
  Future<String?> refreshIdToken() async => 'fake-token';

  @override
  Future<void> login(String email, String password) async {
    loginCalled = true;
    state = const AsyncValue.loading();
    // Yield to allow UI to show loading state
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      state =
          const AsyncValue.data(AuthData(errorMessage: 'Invalid credentials'));
    } else {
      state = const AsyncValue.data(AuthData(user: testUser));
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    loginCalled = true;
    state = const AsyncValue.loading();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      state =
          const AsyncValue.data(AuthData(errorMessage: 'Invalid Google token'));
    } else {
      state = const AsyncValue.data(AuthData(user: testUser));
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String college,
    required String role,
  }) async {
    registerCalled = true;
    state = const AsyncValue.loading();
    // Yield to allow UI to show loading state
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      state =
          const AsyncValue.data(AuthData(errorMessage: 'Email already registered'));
    } else {
      state = const AsyncValue.data(AuthData(user: testUser));
    }
  }

  @override
  Future<void> updateRole(String role) async {
    state = AsyncValue.data(AuthData(user: testUser.copyWith(role: role)));
  }

  @override
  Future<void> completeSetup({String? bio}) async {
    state = const AsyncValue.data(AuthData(user: testUser));
  }

  @override
  Future<void> logout() async {
    state = const AsyncValue.data(AuthData());
  }
}

/// Builds a testable widget tree with ProviderScope + MaterialApp.router.
///
/// The screen under test is placed at [initialLocation]. Any route the
/// screen might navigate to should be listed in [destinationRoutes] so
/// GoRouter doesn't throw on unknown paths.
Widget buildTestWidget(
  Widget child, {
  List<Override> overrides = const [],
  String initialLocation = '/',
  Map<String, Widget Function(BuildContext, GoRouterState)>
      destinationRoutes = const {},
}) {
  final routes = <GoRoute>[
    GoRoute(path: initialLocation, builder: (_, __) => child),
    ...destinationRoutes.entries.map(
      (e) => GoRoute(path: e.key, builder: e.value),
    ),
  ];

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: GoRouter(initialLocation: initialLocation, routes: routes),
    ),
  );
}

/// Convenience for creating the auth provider override.
Override authOverride({
  AsyncValue<AuthData> initial = const AsyncValue.data(AuthData()),
  bool shouldFail = false,
}) {
  return authProvider.overrideWith(
    (ref) => FakeAuthNotifier(initial: initial, shouldFail: shouldFail),
  );
}

/// Convenience for creating an auth override with an already-authenticated user.
Override authenticatedOverride({
  UserModel? user,
  bool shouldFail = false,
}) {
  return authOverride(
    initial: AsyncValue.data(AuthData(user: user ?? testUser)),
    shouldFail: shouldFail,
  );
}
