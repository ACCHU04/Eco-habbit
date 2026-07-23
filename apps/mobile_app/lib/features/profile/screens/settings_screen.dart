import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/services/storage_service.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _themeMode = 'system';

  @override
  void initState() {
    super.initState();
    final storage = ref.read(storageServiceProvider);
    _themeMode = storage.getThemeMode();
  }

  Future<void> _setThemeMode(String mode) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setThemeMode(mode);
    setState(() => _themeMode = mode);
    // Rebuild app by recreating the router provider
    ref.invalidate(appRouterProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Appearance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('System default'),
                  subtitle: const Text('Follow device settings',
                      style: TextStyle(fontSize: 12)),
                  value: 'system',
                  groupValue: _themeMode,
                  onChanged: (v) => _setThemeMode(v!),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: const Text('Light'),
                  value: 'light',
                  groupValue: _themeMode,
                  onChanged: (v) => _setThemeMode(v!),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: const Text('Dark'),
                  value: 'dark',
                  groupValue: _themeMode,
                  onChanged: (v) => _setThemeMode(v!),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Notification Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Likes & Comments'),
                  subtitle: const Text('When someone interacts with your post',
                      style: TextStyle(fontSize: 12)),
                  value: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Marketplace Inquiries'),
                  subtitle: const Text(
                      'When someone messages about your listing',
                      style: TextStyle(fontSize: 12)),
                  value: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Reward Achievements'),
                  subtitle:
                      const Text('When you earn a new badge', style: TextStyle(fontSize: 12)),
                  value: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Community Updates'),
                  subtitle: const Text('New posts in your followed topics',
                      style: TextStyle(fontSize: 12)),
                  value: false,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
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
                  trailing: Icon(Icons.chevron_right,
                      color: Colors.grey[400]),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: Icon(Icons.chevron_right,
                      color: Colors.grey[400]),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Terms of Service'),
                  trailing: Icon(Icons.chevron_right,
                      color: Colors.grey[400]),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Delete Account',
                      style: TextStyle(color: Colors.red)),
                  trailing: Icon(Icons.chevron_right,
                      color: Colors.red[300]),
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
