import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/home/data/home_repository.dart';
import 'package:mobile_app/features/home/models/dashboard_data.dart';

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async {
    return ref.read(homeRepositoryProvider).getDashboard();
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardData>(
  DashboardNotifier.new,
);
