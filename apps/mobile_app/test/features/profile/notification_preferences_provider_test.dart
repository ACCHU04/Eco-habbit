import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/features/profile/data/notification_preferences_repository.dart';
import 'package:mobile_app/features/profile/models/notification_prefs.dart';
import 'package:mobile_app/features/profile/providers/notification_preferences_provider.dart';

import 'notification_preferences_provider_test.mocks.dart';

@GenerateMocks([NotificationPreferencesRepository])
void main() {
  late MockNotificationPreferencesRepository mockRepo;
  late ProviderContainer container;

  const defaultPrefs = NotificationPrefs(
    likeComment: true,
    marketplaceInquiry: true,
    rewardAchievement: true,
    communityUpdate: false,
  );

  setUp(() {
    mockRepo = MockNotificationPreferencesRepository();
    container = ProviderContainer(
      overrides: [notificationPreferencesRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() => container.dispose());

  test('loads preferences on init', () async {
    when(mockRepo.getPreferences()).thenAnswer((_) async => defaultPrefs);

    final result = await container.read(notificationPreferencesProvider.future);

    expect(result.likeComment, true);
    expect(result.communityUpdate, false);
  });

  test('toggles a single preference', () async {
    when(mockRepo.getPreferences()).thenAnswer((_) async => defaultPrefs);
    when(mockRepo.updatePreferences(any)).thenAnswer((_) async => defaultPrefs.copyWith(likeComment: false));

    await container.read(notificationPreferencesProvider.future);

    await container.read(notificationPreferencesProvider.notifier).updatePreference(
      (p) => p.copyWith(likeComment: false),
    );

    final result = container.read(notificationPreferencesProvider).valueOrNull;
    expect(result?.likeComment, false);
  });

  test('rolls back on error during update', () async {
    when(mockRepo.getPreferences()).thenAnswer((_) async => defaultPrefs);
    when(mockRepo.updatePreferences(any)).thenThrow(Exception('fail'));

    await container.read(notificationPreferencesProvider.future);

    try {
      await container.read(notificationPreferencesProvider.notifier).updatePreference(
        (p) => p.copyWith(rewardAchievement: false),
      );
    } catch (_) {}

    final result = container.read(notificationPreferencesProvider).valueOrNull;
    expect(result?.rewardAchievement, true);
  });

  test('reload refreshes preferences', () async {
    final updated = defaultPrefs.copyWith(marketplaceInquiry: false);
    when(mockRepo.getPreferences()).thenAnswer((_) async => defaultPrefs);

    await container.read(notificationPreferencesProvider.future);

    when(mockRepo.getPreferences()).thenAnswer((_) async => updated);
    await container.read(notificationPreferencesProvider.notifier).reload();

    final result = await container.read(notificationPreferencesProvider.future);
    expect(result.marketplaceInquiry, false);
  });
}
