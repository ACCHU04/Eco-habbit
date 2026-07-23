import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/models/user_model.dart';

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

  Future<AuthResult> register({
    required String email,
    required String password,
    required String fullName,
    required String college,
    required String role,
  }) async {
    final response = await _api.post('/auth/register', data: {
      'email': email,
      'password': password,
      'full_name': fullName,
      'college': college,
      'role': role,
    });

    final data = response.data['data'];
    final customToken = data['custom_token'] as String;

    final credential = await FirebaseAuth.instance.signInWithCustomToken(customToken);
    final idToken = await credential.user!.getIdToken();

    return AuthResult(
      customToken: customToken,
      idToken: idToken!,
      user: UserModel(
        id: data['uid'] as String,
        email: data['email'] as String,
        fullName: data['full_name'] as String? ?? '',
        role: role,
        college: college,
      ),
    );
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final data = response.data['data'];
    final customToken = data['custom_token'] as String;

    final credential = await FirebaseAuth.instance.signInWithCustomToken(customToken);
    final idToken = await credential.user!.getIdToken();

    return AuthResult(
      customToken: customToken,
      idToken: idToken!,
      user: UserModel(
        id: data['uid'] as String,
        email: data['email'] as String,
        fullName: data['full_name'] as String? ?? '',
      ),
    );
  }

  Future<UserModel> getMe() async {
    final response = await _api.get('/users/me');
    return UserModel.fromJson(response.data['data']);
  }

  Future<UserModel> updateProfile({
    String? fullName,
    String? college,
    String? role,
    String? bio,
  }) async {
    final response = await _api.put('/users/me', data: {
      if (fullName != null) 'full_name': fullName,
      if (college != null) 'college': college,
      if (role != null) 'role': role,
      if (bio != null) 'bio': bio,
    });
    return UserModel.fromJson(response.data['data']);
  }

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {
      // Logout is best-effort
    }
  }
}

class AuthResult {
  final String customToken;
  final String idToken;
  final UserModel user;

  const AuthResult({required this.customToken, required this.idToken, required this.user});
}
