import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Notification Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Likes & Comments'),
                  subtitle: const Text('When someone interacts with your post', style: TextStyle(fontSize: 12)),
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Marketplace Inquiries'),
                  subtitle: const Text('When someone messages about your listing', style: TextStyle(fontSize: 12)),
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Reward Achievements'),
                  subtitle: const Text('When you earn a new badge', style: TextStyle(fontSize: 12)),
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Community Updates'),
                  subtitle: const Text('New posts in your followed topics', style: TextStyle(fontSize: 12)),
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
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
