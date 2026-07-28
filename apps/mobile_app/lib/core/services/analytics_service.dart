import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mobile_app/core/config/app_config.dart';

enum AnalyticsEvent {
  scanCompleted,
  scanFailed,
  postCreated,
  postLiked,
  postCommented,
  listingCreated,
  listingSold,
  questCompleted,
  challengeAccepted,
  challengeDeclined,
  leaderboardViewed,
  hostelJoined,
  diyProjectSaved,
  bookmarkAdded,
  searchPerformed,
  shareTapped,
}

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {
    final params = <String, Object>{
      'app_version': AppConfig.appVersion,
      if (parameters != null) ...parameters,
    };
    await _analytics.logEvent(name: event.name, parameters: params);
  }

  Future<void> logScreenView(
    String screenName, {
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  FirebaseAnalyticsObserver createObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }
}
