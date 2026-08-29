import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/profile/providers/notification_preferences_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Notification Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          prefsAsync.when(
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (e, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('Could not load notification preferences',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.read(notificationPreferencesProvider.notifier).reload(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (prefs) => Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Likes & Comments'),
                    subtitle: const Text('When someone interacts with your post',
                        style: TextStyle(fontSize: 12)),
                    value: prefs.likeComment,
                    onChanged: (value) => ref
                        .read(notificationPreferencesProvider.notifier)
                        .updatePreference((p) => p.copyWith(likeComment: value)),
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Marketplace Inquiries'),
                    subtitle: const Text('When someone messages about your listing',
                        style: TextStyle(fontSize: 12)),
                    value: prefs.marketplaceInquiry,
                    onChanged: (value) => ref
                        .read(notificationPreferencesProvider.notifier)
                        .updatePreference((p) => p.copyWith(marketplaceInquiry: value)),
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Reward Achievements'),
                    subtitle: const Text('When you earn a new badge',
                        style: TextStyle(fontSize: 12)),
                    value: prefs.rewardAchievement,
                    onChanged: (value) => ref
                        .read(notificationPreferencesProvider.notifier)
                        .updatePreference((p) => p.copyWith(rewardAchievement: value)),
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Community Updates'),
                    subtitle: const Text('New posts in your followed topics',
                        style: TextStyle(fontSize: 12)),
                    value: prefs.communityUpdate,
                    onChanged: (value) => ref
                        .read(notificationPreferencesProvider.notifier)
                        .updatePreference((p) => p.copyWith(communityUpdate: value)),
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Edit Profile'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Terms of Service'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Delete Account',
                      style: TextStyle(color: Colors.red)),
                  trailing: Icon(Icons.chevron_right, color: Colors.red[300]),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
