import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/eco_error_view.dart';
import '../../../core/widgets/eco_empty_state.dart';
import '../providers/admin_reports_provider.dart';
import '../providers/admin_dashboard_provider.dart';
import '../widgets/admin_report_card.dart';

class AdminReportsScreen extends ConsumerStatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  ConsumerState<AdminReportsScreen> createState() =>
      _AdminReportsScreenState();
}

class _AdminReportsScreenState extends ConsumerState<AdminReportsScreen> {
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
      ref.read(adminReportsProvider.notifier).loadMore();
    }
  }

  Future<void> _resolveReport(String reportId) async {
    try {
      final repo = ref.read(adminRepositoryProvider);
      await repo.resolveReport(reportId, status: 'resolved');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report resolved')),
        );
        ref.read(adminReportsProvider.notifier).reload();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _dismissReport(String reportId) async {
    try {
      final repo = ref.read(adminRepositoryProvider);
      await repo.resolveReport(reportId, status: 'dismissed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report dismissed')),
        );
        ref.read(adminReportsProvider.notifier).reload();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(adminReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: EcoTokens.spacing4,
                vertical: EcoTokens.spacing2,
              ),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: true,
                  onTap: () => ref
                      .read(adminReportsProvider.notifier)
                      .filterByStatus(null),
                ),
                _FilterChip(
                  label: 'Pending',
                  onTap: () => ref
                      .read(adminReportsProvider.notifier)
                      .filterByStatus('pending'),
                ),
                _FilterChip(
                  label: 'Resolved',
                  onTap: () => ref
                      .read(adminReportsProvider.notifier)
                      .filterByStatus('resolved'),
                ),
                _FilterChip(
                  label: 'Dismissed',
                  onTap: () => ref
                      .read(adminReportsProvider.notifier)
                      .filterByStatus('dismissed'),
                ),
              ],
            ),
          ),
          Expanded(
            child: reportsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => EcoErrorView(
                message: 'Failed to load reports',
                onRetry: () =>
                    ref.read(adminReportsProvider.notifier).reload(),
              ),
              data: (reports) {
                if (reports.isEmpty) {
                  return const EcoEmptyState(
                    icon: Icons.flag_outlined,
                    title: 'No reports found',
                    subtitle: 'All clear!',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(adminReportsProvider.notifier).reload();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return AdminReportCard(
                        report: report,
                        onResolve: () => _resolveReport(report.id),
                        onDismiss: () => _dismissReport(report.id),
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
