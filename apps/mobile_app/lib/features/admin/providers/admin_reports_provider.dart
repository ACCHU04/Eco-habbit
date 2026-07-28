import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_report.dart';
import 'admin_dashboard_provider.dart';

final adminReportsProvider =
    AsyncNotifierProvider<AdminReportsNotifier, List<AdminReport>>(
  AdminReportsNotifier.new,
);

class AdminReportsNotifier extends AsyncNotifier<List<AdminReport>> {
  String? _statusFilter;
  int _page = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  @override
  Future<List<AdminReport>> build() async {
    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.getReports(page: 1);
    _totalPages = result['pagination']['total_pages'] ?? 1;
    _hasMore = _page < _totalPages;
    return result['reports'] as List<AdminReport>;
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    _page = 1;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final result = await repo.getReports(status: _statusFilter);
      _totalPages = result['pagination']['total_pages'] ?? 1;
      _hasMore = _page < _totalPages;
      return result['reports'] as List<AdminReport>;
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _page++;
    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.getReports(status: _statusFilter, page: _page);
    _totalPages = result['pagination']['total_pages'] ?? 1;
    _hasMore = _page < _totalPages;
    final current = state.valueOrNull ?? [];
    state =
        AsyncValue.data([...current, ...result['reports'] as List<AdminReport>]);
  }

  Future<void> reload() async {
    _page = 1;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final result = await repo.getReports(status: _statusFilter);
      _totalPages = result['pagination']['total_pages'] ?? 1;
      _hasMore = _page < _totalPages;
      return result['reports'] as List<AdminReport>;
    });
  }
}
