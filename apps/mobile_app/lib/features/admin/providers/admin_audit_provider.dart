import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_audit_entry.dart';
import 'admin_dashboard_provider.dart';

final adminAuditProvider =
    AsyncNotifierProvider<AdminAuditNotifier, List<AdminAuditEntry>>(
  AdminAuditNotifier.new,
);

class AdminAuditNotifier extends AsyncNotifier<List<AdminAuditEntry>> {
  int _page = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  @override
  Future<List<AdminAuditEntry>> build() async {
    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.getAuditLog(page: 1);
    _totalPages = result['pagination']['total_pages'] ?? 1;
    _hasMore = _page < _totalPages;
    return result['entries'] as List<AdminAuditEntry>;
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _page++;
    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.getAuditLog(page: _page);
    _totalPages = result['pagination']['total_pages'] ?? 1;
    _hasMore = _page < _totalPages;
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([
      ...current,
      ...result['entries'] as List<AdminAuditEntry>,
    ]);
  }

  Future<void> reload() async {
    _page = 1;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final result = await repo.getAuditLog();
      _totalPages = result['pagination']['total_pages'] ?? 1;
      _hasMore = _page < _totalPages;
      return result['entries'] as List<AdminAuditEntry>;
    });
  }
}
