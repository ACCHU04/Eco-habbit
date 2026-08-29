import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/eco_error_view.dart';
import '../../../core/widgets/eco_empty_state.dart';
import '../../../core/widgets/eco_search_bar.dart';
import '../providers/admin_users_provider.dart';
import '../widgets/admin_user_tile.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminUsersProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: EcoTokens.spacing4,
              vertical: EcoTokens.spacing2,
            ),
            child: EcoSearchBar(
              controller: _searchController,
              hint: 'Search users...',
              onChanged: (q) =>
                  ref.read(adminUsersProvider.notifier).search(q),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: true,
                  onTap: () =>
                      ref.read(adminUsersProvider.notifier).filterByRole(null),
                ),
                _FilterChip(
                  label: 'Student',
                  onTap: () => ref
                      .read(adminUsersProvider.notifier)
                      .filterByRole('student'),
                ),
                _FilterChip(
                  label: 'Moderator',
                  onTap: () => ref
                      .read(adminUsersProvider.notifier)
                      .filterByRole('moderator'),
                ),
                _FilterChip(
                  label: 'Admin',
                  onTap: () => ref
                      .read(adminUsersProvider.notifier)
                      .filterByRole('admin'),
                ),
                _FilterChip(
                  label: 'Suspended',
                  onTap: () => ref
                      .read(adminUsersProvider.notifier)
                      .filterByStatus('suspended'),
                ),
              ],
            ),
          ),
          const SizedBox(height: EcoTokens.spacing2),
          Expanded(
            child: usersAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => EcoErrorView(
                message: 'Failed to load users',
                onRetry: () =>
                    ref.read(adminUsersProvider.notifier).reload(),
              ),
              data: (users) {
                if (users.isEmpty) {
                  return const EcoEmptyState(
                    icon: Icons.people_outline,
                    title: 'No users found',
                    subtitle: 'Try adjusting your search or filters',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(adminUsersProvider.notifier).reload();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return AdminUserTile(
                        user: user,
                        onTap: () =>
                            context.push('/admin/users/${user.id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: EcoTokens.spacing2),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
