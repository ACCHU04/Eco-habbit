import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile_app/core/services/api_client.dart';

class FcmService {
  static bool _initialized = false;

  static Future<void> initialize(ApiClient api) async {
    if (_initialized) return;
    _initialized = true;

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      if (token != null) {
        await _sendTokenToBackend(api, token);
      }

      messaging.onTokenRefresh.listen((token) {
        _sendTokenToBackend(api, token);
      });
    }

    FirebaseMessaging.onMessage.listen((message) {
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationTap(message);
    });

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  static Future<void> _sendTokenToBackend(ApiClient api, String token) async {
    try {
      await api.post('/users/fcm-token', data: {'fcm_token': token});
    } catch (_) {
      // FCM token registration is best-effort
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // In-app notification shown via notification stream
    // Handled by provider in app
  }

  static void _handleNotificationTap(RemoteMessage message) {
    // Navigate based on data payload — handled via a NavigatorKey or router
    // message.data['type'] and message.data['id'] will be used for routing
  }

  static Future<void> clearToken(ApiClient api) async {
    await _sendTokenToBackend(api, '');
    _initialized = false;
  }
}
