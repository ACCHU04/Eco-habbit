import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_user.dart';
import 'admin_dashboard_provider.dart';

final adminUsersProvider =
    AsyncNotifierProvider<AdminUsersNotifier, List<AdminUser>>(
  AdminUsersNotifier.new,
);

class AdminUsersNotifier extends AsyncNotifier<List<AdminUser>> {
  String _search = '';
  String? _roleFilter;
  String? _statusFilter;
  int _page = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  @override
  Future<List<AdminUser>> build() async {
    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.getUsers(page: 1);
    _totalPages = result['pagination']['total_pages'] ?? 1;
    _hasMore = _page < _totalPages;
    return result['users'] as List<AdminUser>;
  }

  Future<void> search(String query) async {
    _search = query;
    _page = 1;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final result = await repo.getUsers(
        search: _search,
        role: _roleFilter,
        status: _statusFilter,
      );
      _totalPages = result['pagination']['total_pages'] ?? 1;
      _hasMore = _page < _totalPages;
      return result['users'] as List<AdminUser>;
    });
  }

  Future<void> filterByRole(String? role) async {
    _roleFilter = role;
    _page = 1;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final result = await repo.getUsers(
        search: _search,
        role: _roleFilter,
        status: _statusFilter,
      );
      _totalPages = result['pagination']['total_pages'] ?? 1;
      _hasMore = _page < _totalPages;
      return result['users'] as List<AdminUser>;
    });
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    _page = 1;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final result = await repo.getUsers(
        search: _search,
        role: _roleFilter,
        status: _statusFilter,
      );
      _totalPages = result['pagination']['total_pages'] ?? 1;
      _hasMore = _page < _totalPages;
      return result['users'] as List<AdminUser>;
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _page++;
    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.getUsers(
      search: _search,
      role: _roleFilter,
      status: _statusFilter,
      page: _page,
    );
    _totalPages = result['pagination']['total_pages'] ?? 1;
    _hasMore = _page < _totalPages;
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([...current, ...result['users'] as List<AdminUser>]);
  }

  Future<void> reload() async {
    _page = 1;
    ref.read(adminDashboardProvider.notifier).reload();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final result = await repo.getUsers(
        search: _search,
        role: _roleFilter,
        status: _statusFilter,
      );
      _totalPages = result['pagination']['total_pages'] ?? 1;
      _hasMore = _page < _totalPages;
      return result['users'] as List<AdminUser>;
    });
  }
}
