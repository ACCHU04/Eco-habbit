import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _kFirebaseCustomToken = 'firebase_custom_token';
  static const _kFirebaseIdToken = 'firebase_id_token';
  static const _kUserId = 'user_id';
  static const _kUserEmail = 'user_email';
  static const _kUserName = 'user_name';
  static const _kUserRole = 'user_role';
  static const _kUserCollege = 'user_college';
  static const _kThemeMode = 'theme_mode';
  static const _kCampusSlug = 'campus_slug';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveFirebaseCustomToken(String token) =>
      _prefs.setString(_kFirebaseCustomToken, token);
  String? getFirebaseCustomToken() => _prefs.getString(_kFirebaseCustomToken);

  Future<void> saveFirebaseIdToken(String token) =>
      _prefs.setString(_kFirebaseIdToken, token);
  String? getFirebaseIdToken() => _prefs.getString(_kFirebaseIdToken);

  String? getToken() => getFirebaseIdToken();

  Future<void> saveUser({
    required String id,
    required String email,
    required String fullName,
    String? role,
    String? college,
  }) async {
    await _prefs.setString(_kUserId, id);
    await _prefs.setString(_kUserEmail, email);
    await _prefs.setString(_kUserName, fullName);
    if (role != null) await _prefs.setString(_kUserRole, role);
    if (college != null) await _prefs.setString(_kUserCollege, college);
  }

  String? getUserId() => _prefs.getString(_kUserId);
  String? getUserEmail() => _prefs.getString(_kUserEmail);
  String? getUserName() => _prefs.getString(_kUserName);
  String? getUserRole() => _prefs.getString(_kUserRole);
  String? getUserCollege() => _prefs.getString(_kUserCollege);

  bool get isAuthenticated => getFirebaseIdToken() != null;

  Future<void> clearAuth() async {
    await _prefs.remove(_kFirebaseCustomToken);
    await _prefs.remove(_kFirebaseIdToken);
    await _prefs.remove(_kUserId);
    await _prefs.remove(_kUserEmail);
    await _prefs.remove(_kUserName);
    await _prefs.remove(_kUserRole);
    await _prefs.remove(_kUserCollege);
  }

  Future<void> setThemeMode(String mode) => _prefs.setString(_kThemeMode, mode);
  String getThemeMode() => _prefs.getString(_kThemeMode) ?? 'system';

  Future<void> setSelectedCampus(String slug) => _prefs.setString(_kCampusSlug, slug);
  String? getSelectedCampusSlug() => _prefs.getString(_kCampusSlug);
  Future<void> clearSelectedCampus() => _prefs.remove(_kCampusSlug);
}
