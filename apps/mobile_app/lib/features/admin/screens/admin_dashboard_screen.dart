import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/eco_error_view.dart';
import '../providers/admin_dashboard_provider.dart';
import '../widgets/admin_stat_card.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dashboardAsync = ref.watch(adminDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(adminDashboardProvider.notifier).reload(),
          ),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EcoErrorView(
          message: 'Failed to load dashboard',
          onRetry: () => ref.read(adminDashboardProvider.notifier).reload(),
        ),
        data: (stats) {
          if (stats == null) {
            return const Center(child: Text('No data available'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(adminDashboardProvider.notifier).reload();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EcoTokens.paddingPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: EcoTokens.spacing3),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: EcoTokens.spacing3,
                    crossAxisSpacing: EcoTokens.spacing3,
                    childAspectRatio: 1.4,
                    children: [
                      AdminStatCard(
                        icon: Icons.people_outline,
                        label: 'Total Users',
                        value: stats.totalUsers.toString(),
                        color: AppColors.primary,
                      ),
                      AdminStatCard(
                        icon: Icons.article_outlined,
                        label: 'Total Posts',
                        value: stats.totalPosts.toString(),
                        color: AppColors.info,
                      ),
                      AdminStatCard(
                        icon: Icons.flag_outlined,
                        label: 'Pending Reports',
                        value: stats.pendingReports.toString(),
                        color: AppColors.warning,
                      ),
                      AdminStatCard(
                        icon: Icons.store_outlined,
                        label: 'Active Listings',
                        value: stats.activeListings.toString(),
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: EcoTokens.spacing5),
                  Text(
                    'Quick Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: EcoTokens.spacing3),
                  _ActionTile(
                    icon: Icons.people_alt_outlined,
                    title: 'Manage Users',
                    subtitle: 'View and manage user accounts',
                    onTap: () => context.push('/admin/users'),
                  ),
                  _ActionTile(
                    icon: Icons.flag_outlined,
                    title: 'Reports',
                    subtitle: 'Review reported content',
                    onTap: () => context.push('/admin/reports'),
                    badge: stats.pendingReports > 0
                        ? stats.pendingReports.toString()
                        : null,
                  ),
                  _ActionTile(
                    icon: Icons.history,
                    title: 'Audit Log',
                    subtitle: 'View admin action history',
                    onTap: () => context.push('/admin/audit'),
                  ),
                  if (stats.roleBreakdown.isNotEmpty) ...[
                    const SizedBox(height: EcoTokens.spacing5),
                    Text(
                      'Role Breakdown',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: EcoTokens.spacing3),
                    ...stats.roleBreakdown.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: EcoTokens.spacing2),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.key.replaceAll('_', ' '),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              e.value.toString(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: EcoTokens.spacing2,
                  vertical: EcoTokens.spacing1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
