import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/eco_error_view.dart';
import '../../../core/widgets/eco_empty_state.dart';
import '../providers/admin_audit_provider.dart';

class AdminAuditScreen extends ConsumerStatefulWidget {
  const AdminAuditScreen({super.key});

  @override
  ConsumerState<AdminAuditScreen> createState() => _AdminAuditScreenState();
}

class _AdminAuditScreenState extends ConsumerState<AdminAuditScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminAuditProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auditAsync = ref.watch(adminAuditProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Log'),
      ),
      body: auditAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EcoErrorView(
          message: 'Failed to load audit log',
          onRetry: () =>
              ref.read(adminAuditProvider.notifier).reload(),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const EcoEmptyState(
              icon: Icons.history,
              title: 'No audit entries',
              subtitle: 'Admin actions will appear here',
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(adminAuditProvider.notifier).reload();
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: EcoTokens.spacing4,
                    vertical: EcoTokens.spacing1,
                  ),
                  child: ListTile(
                    leading: Icon(
                      _iconForAction(entry.action),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      entry.actionLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.resourceType} · ${entry.resourceId.substring(0, 8)}...',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        if (entry.adminName != null)
                          Text(
                            'by ${entry.adminName}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        if (entry.reason != null && entry.reason!.isNotEmpty)
                          Text(
                            entry.reason!,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    trailing: Text(
                      DateFormat.MMMd().add_jm().format(entry.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _iconForAction(String action) {
    if (action.contains('role')) return Icons.admin_panel_settings;
    if (action.contains('status')) return Icons.toggle_on;
    if (action.contains('post')) return Icons.article_outlined;
    if (action.contains('listing')) return Icons.store_outlined;
    if (action.contains('report')) return Icons.flag_outlined;
    return Icons.security;
  }
}
