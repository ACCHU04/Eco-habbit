import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/engagement/screens/leaderboard_screen.dart';
import 'package:mobile_app/features/engagement/screens/hostels_screen.dart';
import 'package:mobile_app/features/engagement/screens/challenges_screen.dart';
import 'package:mobile_app/features/engagement/screens/achievements_screen.dart';

class EngagementHubScreen extends ConsumerStatefulWidget {
  const EngagementHubScreen({super.key});

  @override
  ConsumerState<EngagementHubScreen> createState() => _EngagementHubScreenState();
}

class _EngagementHubScreenState extends ConsumerState<EngagementHubScreen> {
  int _selectedIndex = 0;

  static const _screens = [
    LeaderboardScreen(),
    HostelsScreen(),
    ChallengesScreen(),
    AchievementsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.apartment_outlined),
            selectedIcon: Icon(Icons.apartment),
            label: 'Hostels',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports),
            label: 'Challenges',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
        ],
      ),
    );
  }
}
