import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
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

class _NoopNavigatorObserver extends NavigatorObserver {}

class AnalyticsService {
  final FirebaseAnalytics? _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? _tryCreate();

  static FirebaseAnalytics? _tryCreate() {
    try {
      return FirebaseAnalytics.instance;
    } catch (_) {
      return null;
    }
  }

  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {
    final analytics = _analytics;
    if (analytics == null) return;
    final params = <String, Object>{
      'app_version': AppConfig.appVersion,
      if (parameters != null) ...parameters,
    };
    await analytics.logEvent(name: event.name, parameters: params);
  }

  Future<void> logScreenView(
    String screenName, {
    String? screenClass,
  }) async {
    final analytics = _analytics;
    if (analytics == null) return;
    await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  Future<void> setUserId(String? userId) async {
    final analytics = _analytics;
    if (analytics == null) return;
    await analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    final analytics = _analytics;
    if (analytics == null) return;
    await analytics.setUserProperty(name: name, value: value);
  }

  NavigatorObserver createObserver() {
    final analytics = _analytics;
    if (analytics == null) return _NoopNavigatorObserver();
    return FirebaseAnalyticsObserver(analytics: analytics);
  }
}
