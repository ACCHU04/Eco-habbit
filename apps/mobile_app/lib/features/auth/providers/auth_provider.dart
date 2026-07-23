import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/storage_service.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/auth/models/user_model.dart';

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
  AuthState _authState = AuthState.initial;

  AuthNotifier(this._repository, this._storage)
      : super(const AsyncValue.loading()) {
    _init();
  }

  AuthState get authState => _authState;

  Future<void> _init() async {
    final token = _storage.getToken();
    if (token == null) {
      _authState = AuthState.unauthenticated;
      state = const AsyncValue.data(AuthData());
      return;
    }

    try {
      final user = await _repository.getMe();
      _storage.saveUser(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
        college: user.college,
      );
      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: user));
    } catch (_) {
      await _storage.clearAuth();
      _authState = AuthState.unauthenticated;
      state = const AsyncValue.data(AuthData());
    }
  }

  Future<void> login(String email, String password) async {
    _authState = AuthState.loading;
    state = const AsyncValue.loading();

    try {
      final result = await _repository.login(email: email, password: password);
      await _storage.saveToken(result.token);
      await _storage.saveUser(
        id: result.user.id,
        email: result.user.email,
        fullName: result.user.fullName,
        role: result.user.role,
        college: result.user.college,
      );
      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: result.user));
    } catch (e) {
      _authState = AuthState.error;
      state = AsyncValue.data(AuthData(
        errorMessage: _parseError(e),
      ));
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
      await _storage.saveToken(result.token);
      await _storage.saveUser(
        id: result.user.id,
        email: result.user.email,
        fullName: result.user.fullName,
        role: role,
        college: college,
      );
      _authState = AuthState.authenticated;
      state = AsyncValue.data(AuthData(user: result.user));
    } catch (e) {
      _authState = AuthState.error;
      state = AsyncValue.data(AuthData(
        errorMessage: _parseError(e),
      ));
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
    } catch (_) {
      // Role update is non-critical for RC
    }
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
    await _repository.logout();
    await _storage.clearAuth();
    _authState = AuthState.unauthenticated;
    state = const AsyncValue.data(AuthData());
  }

  String _parseError(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
      if (e.response?.statusCode == 409) return 'Email already registered';
      if (e.response?.statusCode == 401) return 'Invalid credentials';
      if (e.type == DioExceptionType.connectionTimeout) {
        return 'Connection timeout. Check your network.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}

// These providers are overridden in main.dart with initialized instances
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
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
