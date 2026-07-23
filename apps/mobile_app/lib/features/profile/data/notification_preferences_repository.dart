import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/profile/models/notification_prefs.dart';

class NotificationPreferencesRepository {
  final ApiClient _api;
  NotificationPreferencesRepository(this._api);

  Future<NotificationPrefs> getPreferences() async {
    final response = await _api.get('/notifications/preferences');
    return NotificationPrefs.fromJson(response.data['data']);
  }

  Future<NotificationPrefs> updatePreferences(NotificationPrefs prefs) async {
    final response = await _api.put(
      '/notifications/preferences',
      data: prefs.toJson(),
    );
    return NotificationPrefs.fromJson(response.data['data']);
  }
}

final notificationPreferencesRepositoryProvider = Provider((ref) {
  return NotificationPreferencesRepository(ref.read(apiClientProvider));
});
