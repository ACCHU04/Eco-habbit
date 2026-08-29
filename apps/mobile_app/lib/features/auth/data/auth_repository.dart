import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/models/user_model.dart';

FirebaseAuth? _tryFirebaseAuth() {
  try {
    Firebase.app();
    return FirebaseAuth.instance;
  } catch (_) {
    return null;
  }
}

Future<String> _getIdToken(String customToken) async {
  final auth = _tryFirebaseAuth();
  if (auth != null) {
    try {
      final credential = await auth.signInWithCustomToken(customToken);
      return (await credential.user!.getIdToken())!;
    } catch (e) {
      debugPrint('FirebaseAuth signInWithCustomToken failed: $e');
    }
  }
  try {
    final resp = await Dio().post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${AppConfig.firebaseApiKey}',
      data: {'token': customToken, 'returnSecureToken': true},
    );
    return resp.data['idToken'] as String;
  } catch (e) {
    debugPrint('Firebase REST API token exchange failed: $e');
    rethrow;
  }
}

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

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
    final uid = data['uid'] as String;
    final userEmail = data['email'] as String;
    final fullName = data['full_name'] as String? ?? '';

    final idToken = await _getIdToken(customToken);

    return AuthResult(
      customToken: customToken,
      idToken: idToken,
      user: UserModel(
        id: uid,
        email: userEmail,
        fullName: fullName,
      ),
    );
  }

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
    final uid = data['uid'] as String;

    final idToken = await _getIdToken(customToken);

    return AuthResult(
      customToken: customToken,
      idToken: idToken,
      user: UserModel(
        id: uid,
        email: data['email'] as String,
        fullName: data['full_name'] as String? ?? '',
        role: role,
        college: college,
      ),
    );
  }

  Future<AuthResult> loginWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In canceled');
    }

    final googleAuth = await googleUser.authentication;

    final response = await _api.post('/auth/google', data: {
      'id_token': googleAuth.idToken,
      'access_token': googleAuth.accessToken,
      'email': googleUser.email,
      'full_name': googleUser.displayName,
    });

    final data = response.data['data'];
    final customToken = data['custom_token'] as String;

    final idToken = await _getIdToken(customToken);

    return AuthResult(
      customToken: customToken,
      idToken: idToken,
      user: UserModel(
        id: data['uid'] as String,
        email: data['email'] as String,
        fullName: googleUser.displayName ?? '',
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
