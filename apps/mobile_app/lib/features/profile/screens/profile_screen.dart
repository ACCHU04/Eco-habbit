import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/campus/providers/campus_provider.dart';
import 'package:mobile_app/features/campus/widgets/campus_avatar.dart';
import 'package:mobile_app/features/profile/providers/profile_provider.dart';

String _computeInitials(String fullName) {
  final trimmed = fullName.trim();
  if (trimmed.isEmpty) return '?';
  final parts = trimmed.split(RegExp(r'\s+'));
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.valueOrNull?.user;
    final statsAsync = ref.watch(profileStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(EcoTokens.spacing4),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Text(
                _computeInitials(user?.fullName ?? ''),
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Center(
            child: Text(
              user?.fullName ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              user?.college ?? '',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Center(
            child: Consumer(
              builder: (context, ref, _) {
                final campus = ref.watch(selectedCampusProvider);
                if (campus == null) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () => context.push('/campus-picker'),
                  child: Chip(
                    avatar: CampusAvatar(campus: campus, size: 20),
                    label: Text(campus.displayName),
                    deleteIcon: const Icon(Icons.edit, size: 16),
                    onDeleted: () => context.push('/campus-picker'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: EcoTokens.spacing5),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(EcoTokens.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Impact Stats', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: EcoTokens.spacing3),
                  statsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Column(
                        children: [
                          const Text('Could not load stats', style: TextStyle(color: Colors.grey)),
                          TextButton(
                            onPressed: () => ref.read(profileStatsProvider.notifier).reload(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    data: (stats) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(icon: Icons.storefront, label: 'Listings', value: '${stats.listingsCount}'),
                        _StatItem(icon: Icons.star, label: 'Points', value: '${stats.totalPoints}', color: AppColors.xpPurple),
                        _StatItem(icon: Icons.military_tech, label: 'Badges', value: '${stats.badgesCount}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Card(
            child: Column(
              children: [
                _ProfileMenuItem(
                  icon: Icons.monetization_on,
                  title: 'Wallet',
                  onTap: () => context.push('/wallet'),
                ),
                const Divider(height: 1),
                _ProfileMenuItem(
                  icon: Icons.eco,
                  title: 'Eco Passport',
                  onTap: () => context.push('/passport'),
                ),
                const Divider(height: 1),
                _ProfileMenuItem(
                  icon: Icons.task_alt,
                  title: 'Quest History',
                  onTap: () => context.push('/quests'),
                ),
                const Divider(height: 1),
                _ProfileMenuItem(
                  icon: Icons.bookmark_outline,
                  title: 'Bookmarks',
                  onTap: () => context.push('/bookmarks'),
                ),
                const Divider(height: 1),
                _ProfileMenuItem(
                  icon: Icons.storefront,
                  title: 'My Listings',
                  onTap: () => context.push('/my-listings'),
                ),
              ],
            ),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Card(
            child: Column(
              children: [
                _ProfileMenuItem(
                  icon: Icons.star,
                  title: 'Eco Rewards',
                  onTap: () => context.push('/rewards'),
                ),
                const Divider(height: 1),
                _ProfileMenuItem(
                  icon: Icons.bookmark,
                  title: 'Saved DIY Projects',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Card(
            child: Column(
              children: [
                _ProfileMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () => context.push('/notifications'),
                ),
                if (user?.role == 'admin' || user?.role == 'super_admin') ...[
                  const Divider(height: 1),
                  _ProfileMenuItem(
                    icon: Icons.admin_panel_settings,
                    title: 'Admin Panel',
                    color: Colors.deepPurple,
                    onTap: () => context.push('/admin'),
                  ),
                ],
                const Divider(height: 1),
                _ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  color: Colors.red,
                  onTap: () => ref.read(authProvider.notifier).logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  const _StatItem({required this.icon, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppColors.primary, size: 24),
        const SizedBox(height: EcoTokens.spacing1),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: color)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}
