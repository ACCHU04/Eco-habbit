import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mobile_app/core/services/analytics_service.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'analytics_service_test.mocks.dart';

@GenerateMocks([FirebaseAnalytics])
void main() {
  late MockFirebaseAnalytics mockAnalytics;
  late AnalyticsService service;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    service = AnalyticsService(analytics: mockAnalytics);
  });

  group('AnalyticsService', () {
    test('logEvent sends correct event name from enum', () async {
      when(mockAnalytics.logEvent(
        name: anyNamed('name'),
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      await service.logEvent(AnalyticsEvent.scanCompleted);

      verify(mockAnalytics.logEvent(
        name: 'scanCompleted',
        parameters: anyNamed('parameters'),
      )).called(1);
    });

    test('logEvent includes app_version parameter', () async {
      when(mockAnalytics.logEvent(
        name: anyNamed('name'),
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      await service.logEvent(AnalyticsEvent.postCreated);

      final captured = verify(mockAnalytics.logEvent(
        name: anyNamed('name'),
        parameters: captureAnyNamed('parameters'),
      )).captured;

      final params = captured.first as Map<String, dynamic>;
      expect(params['app_version'], AppConfig.appVersion);
    });

    test('logEvent merges custom parameters with app_version', () async {
      when(mockAnalytics.logEvent(
        name: anyNamed('name'),
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      await service.logEvent(
        AnalyticsEvent.listingCreated,
        parameters: {'category': 'electronics', 'price': 500},
      );

      final captured = verify(mockAnalytics.logEvent(
        name: anyNamed('name'),
        parameters: captureAnyNamed('parameters'),
      )).captured;

      final params = captured.first as Map<String, dynamic>;
      expect(params['app_version'], AppConfig.appVersion);
      expect(params['category'], 'electronics');
      expect(params['price'], 500);
    });

    test('logScreenView sends screen name', () async {
      when(mockAnalytics.logScreenView(
        screenName: anyNamed('screenName'),
        screenClass: anyNamed('screenClass'),
      )).thenAnswer((_) async {});

      await service.logScreenView('HomeScreen');

      verify(mockAnalytics.logScreenView(
        screenName: 'HomeScreen',
        screenClass: 'HomeScreen',
      )).called(1);
    });

    test('logScreenView accepts custom screen class', () async {
      when(mockAnalytics.logScreenView(
        screenName: anyNamed('screenName'),
        screenClass: anyNamed('screenClass'),
      )).thenAnswer((_) async {});

      await service.logScreenView('HomeScreen', screenClass: 'Dashboard');

      verify(mockAnalytics.logScreenView(
        screenName: 'HomeScreen',
        screenClass: 'Dashboard',
      )).called(1);
    });

    test('setUserId delegates to Firebase', () async {
      when(mockAnalytics.setUserId(id: anyNamed('id')))
          .thenAnswer((_) async {});

      await service.setUserId('user-123');

      verify(mockAnalytics.setUserId(id: 'user-123')).called(1);
    });

    test('setUserId clears userId when null', () async {
      when(mockAnalytics.setUserId(id: anyNamed('id')))
          .thenAnswer((_) async {});

      await service.setUserId(null);

      verify(mockAnalytics.setUserId(id: null)).called(1);
    });

    test('createObserver returns FirebaseAnalyticsObserver', () {
      final observer = service.createObserver();
      expect(observer, isA<FirebaseAnalyticsObserver>());
    });
  });
}
