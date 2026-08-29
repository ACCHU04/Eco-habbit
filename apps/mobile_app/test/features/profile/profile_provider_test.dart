import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/features/auth/models/user_model.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/profile/models/user_stats.dart';
import 'package:mobile_app/features/profile/providers/profile_provider.dart';

import 'profile_provider_test.mocks.dart';

class FakeAuthNotifier extends StateNotifier<AsyncValue<AuthData>>
    implements AuthNotifier {
  FakeAuthNotifier(super.initial);

  @override
  AuthState get authState => AuthState.authenticated;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockRepo;
  late ProviderContainer container;

  const mockUser = UserModel(id: 'u1', email: 'a@b.com', fullName: 'Test');

  setUp(() {
    mockRepo = MockProfileRepository();
    container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(mockRepo),
        authProvider.overrideWith(
          (ref) => FakeAuthNotifier(const AsyncValue.data(AuthData(user: mockUser))),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('loads user stats successfully', () async {
    const stats = UserStats(listingsCount: 5, totalPoints: 120, badgesCount: 3, badges: []);
    when(mockRepo.getUserStats(any)).thenAnswer((_) async => stats);

    final result = await container.read(profileStatsProvider.future);

    expect(result.listingsCount, 5);
    expect(result.totalPoints, 120);
    expect(result.badgesCount, 3);
  });

  test('exposes error state on failure', () async {
    when(mockRepo.getUserStats(any)).thenThrow(Exception('network'));

    final future = container.read(profileStatsProvider.future);

    expect(future, throwsException);
  });

  test('reloads stats on invalidate', () async {
    const stats = UserStats(listingsCount: 2, totalPoints: 50, badgesCount: 1, badges: []);
    when(mockRepo.getUserStats(any)).thenAnswer((_) async => stats);

    await container.read(profileStatsProvider.future);

    when(mockRepo.getUserStats(any)).thenAnswer((_) async => const UserStats(listingsCount: 8, totalPoints: 200, badgesCount: 5, badges: []));
    container.invalidate(profileStatsProvider);

    final result = await container.read(profileStatsProvider.future);
    expect(result.listingsCount, 8);
  });
}
