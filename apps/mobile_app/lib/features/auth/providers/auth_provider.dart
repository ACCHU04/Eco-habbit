import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/analytics_service.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/core/services/storage_service.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/auth/models/user_model.dart';
import 'package:mobile_app/features/notifications/services/fcm_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthData {
  final UserModel? user;
  final String? errorMessage;

  const AuthData({this.user, this.errorMessage});

  AuthData copyWith({UserModel? user, String? errorMessage}) {
    return AuthData(
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AsyncValue<AuthData>> {
  final AuthRepository _repository;
  final StorageService _storage;
  final Ref _ref;
  AuthState _authState = AuthState.initial;

  AuthNotifier(this._repository, this._storage, this._ref)
      : super(const AsyncValue.loading()) {
    _init();
  }

  AuthState get authState => _authState;

  static FirebaseAuth? _tryFirebaseAuth() {
    try {
      Firebase.app();
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  Future<void> _init() async {
    _authState = AuthState.loading;
    state = const AsyncValue.loading();

    final auth = _tryFirebaseAuth();

    try {
      if (auth == null) {
        await _storage.clearAuth();
        _authState = AuthState.unauthenticated;
        state = const AsyncValue.data(AuthData());
        return;
      }

      var firebaseUser = auth.currentUser;

      if (firebaseUser == null) {
        final customToken = _storage.getFirebaseCustomToken();
        if (customToken == null) {
          _authState = AuthState.unauthenticated;
          state = const AsyncValue.data(AuthData());
          return;
        }

        try {
          final credential = await auth.signInWithCustomToken(customToken);
          firebaseUser = credential.user;
        } catch (_) {
          await _storage.clearAuth();
          _authState = AuthState.unauthenticated;
          state = const AsyncValue.data(AuthData());
          return;
        }
      }

      if (firebaseUser == null) {
        _authState = AuthState.unauthenticated;
        state = const AsyncValue.data(AuthData());
        return;
      }

      final idToken = await firebaseUser.getIdToken();
      await _storage.saveFirebaseIdToken(idToken!);

      final user = await _repository.getMe();
      await _storage.saveUser(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
        college: user.college,
      );

      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: user));

      _initFcm();
    } catch (e) {
      await _storage.clearAuth();
      _authState = AuthState.unauthenticated;
      state = const AsyncValue.data(AuthData());
    }
  }

  void _initFcm() {
    Future.microtask(() {
      try {
        final api = _ref.read(apiClientProvider);
        FcmService.initialize(api);
      } catch (_) {}
    });
  }

  Future<String?> refreshIdToken() async {
    final auth = _tryFirebaseAuth();
    if (auth == null) return null;
    final user = auth.currentUser;
    if (user == null) return null;
    try {
      final idToken = await user.getIdToken(true);
      await _storage.saveFirebaseIdToken(idToken!);
      return idToken;
    } catch (_) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    _authState = AuthState.loading;
    state = const AsyncValue.loading();

    try {
      final result = await _repository.login(email: email, password: password);
      await _storage.saveFirebaseCustomToken(result.customToken);
      await _storage.saveFirebaseIdToken(result.idToken);
      await _storage.saveUser(
        id: result.user.id,
        email: result.user.email,
        fullName: result.user.fullName,
        role: result.user.role,
        college: result.user.college,
      );
      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: result.user));
      _initFcm();
    } catch (e) {
      _authState = AuthState.error;
      state = AsyncValue.data(AuthData(errorMessage: _parseError(e)));
    }
  }

  Future<void> loginWithGoogle() async {
    _authState = AuthState.loading;
    state = const AsyncValue.loading();

    try {
      final result = await _repository.loginWithGoogle();
      await _storage.saveFirebaseCustomToken(result.customToken);
      await _storage.saveFirebaseIdToken(result.idToken);
      await _storage.saveUser(
        id: result.user.id,
        email: result.user.email,
        fullName: result.user.fullName,
        role: result.user.role,
        college: result.user.college,
      );
      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: result.user));
      _initFcm();
    } catch (e) {
      if (e.toString().contains('canceled')) {
        _authState = AuthState.unauthenticated;
        state = const AsyncValue.data(AuthData());
        return;
      }
      _authState = AuthState.error;
      state = AsyncValue.data(AuthData(errorMessage: _parseError(e)));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String college,
    required String role,
  }) async {
    _authState = AuthState.loading;
    state = const AsyncValue.loading();

    try {
      final result = await _repository.register(
        email: email,
        password: password,
        fullName: fullName,
        college: college,
        role: role,
      );
      await _storage.saveFirebaseCustomToken(result.customToken);
      await _storage.saveFirebaseIdToken(result.idToken);
      await _storage.saveUser(
        id: result.user.id,
        email: result.user.email,
        fullName: result.user.fullName,
        role: role,
        college: college,
      );
      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: result.user));
      _initFcm();
    } catch (e) {
      _authState = AuthState.error;
      state = AsyncValue.data(AuthData(errorMessage: _parseError(e)));
    }
  }

  Future<void> updateRole(String role) async {
    final currentUser = state.valueOrNull?.user;
    if (currentUser == null) return;

    try {
      final updated = await _repository.updateProfile(role: role);
      _storage.saveUser(
        id: updated.id,
        email: updated.email,
        fullName: updated.fullName,
        role: updated.role,
        college: updated.college,
      );
      state = AsyncValue.data(AuthData(user: updated));
    } catch (_) {}
  }

  Future<void> completeSetup({String? bio}) async {
    final currentUser = state.valueOrNull?.user;
    if (currentUser == null) return;

    try {
      final updated = await _repository.updateProfile(bio: bio);
      _storage.saveUser(
        id: updated.id,
        email: updated.email,
        fullName: updated.fullName,
        role: updated.role,
        college: updated.college,
      );
      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: updated));
    } catch (_) {
      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: currentUser));
    }
  }

  Future<void> logout() async {
    try {
      final api = _ref.read(apiClientProvider);
      await api.post('/users/fcm-token', data: {'fcm_token': null});
    } catch (_) {}

    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    await _repository.logout();
    await _storage.clearAuth();

    _authState = AuthState.unauthenticated;
    state = const AsyncValue.data(AuthData());
  }

  String _parseError(dynamic e) {
    // ignore: avoid_print
    print('Auth error details: $e');
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['error'] != null && data['error'] is Map) {
        final msg = data['error']['message'];
        if (msg != null && msg is String) return msg;
      }
      if (data is Map && data['message'] != null) {
        final msg = data['message'];
        if (msg is List) return msg.join(', ');
        return msg.toString();
      }
      final code = e.response?.statusCode;
      if (code == 409) return 'Email already registered';
      if (code == 401) return 'Invalid credentials';
      if (code == 502 || code == 503) {
        return 'Server is starting up — please wait a moment and try again.';
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Connection timeout. Check your network.';
      }
      if (e.type == DioExceptionType.connectionError) {
        return 'Cannot reach server. Check your internet connection.';
      }
      if (code != null) {
        return 'Something went wrong (error $code). Please try again.';
      }
      return 'Network error. Please try again.';
    }
    if (e is FirebaseException) {
      return 'Firebase error: ${e.message ?? "sign-in unavailable"}. Please try again.';
    }
    return '$e'.contains('canceled') ? 'Sign-in cancelled.' : 'Error: $e';
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthData>>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});
