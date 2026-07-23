import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/profile/data/notification_preferences_repository.dart';
import 'package:mobile_app/features/profile/models/notification_prefs.dart';

class NotificationPreferencesNotifier extends AsyncNotifier<NotificationPrefs> {
  @override
  Future<NotificationPrefs> build() async {
    return ref.read(notificationPreferencesRepositoryProvider).getPreferences();
  }

  Future<void> updatePreference(NotificationPrefs Function(NotificationPrefs current) updateFn) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = updateFn(current);
    state = AsyncValue.data(updated);
    try {
      await ref.read(notificationPreferencesRepositoryProvider).updatePreferences(updated);
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final notificationPreferencesProvider = AsyncNotifierProvider<
    NotificationPreferencesNotifier, NotificationPrefs>(
  NotificationPreferencesNotifier.new,
);
