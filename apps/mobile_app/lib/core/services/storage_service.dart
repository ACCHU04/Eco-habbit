import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';
  static const _keyUserName = 'user_name';
  static const _keyUserRole = 'user_role';
  static const _keyUserCollege = 'user_college';
  static const _keyThemeMode = 'theme_mode';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) => _prefs.setString(_keyToken, token);
  String? getToken() => _prefs.getString(_keyToken);

  Future<void> saveUser({
    required String id,
    required String email,
    required String fullName,
    String? role,
    String? college,
  }) async {
    await _prefs.setString(_keyUserId, id);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserName, fullName);
    if (role != null) await _prefs.setString(_keyUserRole, role);
    if (college != null) await _prefs.setString(_keyUserCollege, college);
  }

  String? getUserId() => _prefs.getString(_keyUserId);
  String? getUserEmail() => _prefs.getString(_keyUserEmail);
  String? getUserName() => _prefs.getString(_keyUserName);
  String? getUserRole() => _prefs.getString(_keyUserRole);
  String? getUserCollege() => _prefs.getString(_keyUserCollege);

  bool get isAuthenticated => getToken() != null;

  Future<void> clearAuth() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserRole);
    await _prefs.remove(_keyUserCollege);
  }

  Future<void> setThemeMode(String mode) => _prefs.setString(_keyThemeMode, mode);
  String getThemeMode() => _prefs.getString(_keyThemeMode) ?? 'system';
}
