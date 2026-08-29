import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_repository.dart';
import '../models/admin_dashboard_stats.dart';
import '../../auth/providers/auth_provider.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return AdminRepository(api);
});

final adminDashboardProvider =
    AsyncNotifierProvider<AdminDashboardNotifier, AdminDashboardStats?>(
  AdminDashboardNotifier.new,
);

class AdminDashboardNotifier extends AsyncNotifier<AdminDashboardStats?> {
  @override
  Future<AdminDashboardStats?> build() async {
    final repo = ref.read(adminRepositoryProvider);
    try {
      return await repo.getDashboard();
    } catch (_) {
      return null;
    }
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      return await repo.getDashboard();
    });
  }
}
