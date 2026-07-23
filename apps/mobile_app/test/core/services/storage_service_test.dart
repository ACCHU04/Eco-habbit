import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService();
    await storage.init();
  });

  group('Firebase custom token', () {
    test('save and retrieve custom token', () async {
      await storage.saveFirebaseCustomToken('custom-token-abc');
      expect(storage.getFirebaseCustomToken(), 'custom-token-abc');
    });

    test('returns null when no custom token saved', () {
      expect(storage.getFirebaseCustomToken(), isNull);
    });
  });

  group('Firebase ID token', () {
    test('save and retrieve ID token', () async {
      await storage.saveFirebaseIdToken('id-token-xyz');
      expect(storage.getFirebaseIdToken(), 'id-token-xyz');
    });

    test('getToken returns the ID token', () async {
      await storage.saveFirebaseIdToken('id-token-xyz');
      expect(storage.getToken(), 'id-token-xyz');
    });

    test('overwriting ID token replaces previous value', () async {
      await storage.saveFirebaseIdToken('old-token');
      await storage.saveFirebaseIdToken('new-token');
      expect(storage.getToken(), 'new-token');
    });
  });

  group('clearAuth', () {
    test('removes both tokens', () async {
      await storage.saveFirebaseCustomToken('custom-abc');
      await storage.saveFirebaseIdToken('id-xyz');

      await storage.clearAuth();

      expect(storage.getFirebaseCustomToken(), isNull);
      expect(storage.getFirebaseIdToken(), isNull);
    });

    test('leaves non-auth keys intact', () async {
      await storage.saveFirebaseCustomToken('custom-abc');
      await storage.saveFirebaseIdToken('id-xyz');
      await storage.setThemeMode('dark');

      await storage.clearAuth();

      expect(storage.getThemeMode(), 'dark');
    });
  });
}
