import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/profile/models/user_stats.dart';

class ProfileStatsNotifier extends AsyncNotifier<UserStats> {
  @override
  Future<UserStats> build() async {
    final user = ref.watch(authProvider).valueOrNull?.user;
    if (user == null) throw Exception('Not authenticated');
    return ref.read(profileRepositoryProvider).getUserStats(user.id);
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final profileStatsProvider = AsyncNotifierProvider<ProfileStatsNotifier, UserStats>(
  ProfileStatsNotifier.new,
);
