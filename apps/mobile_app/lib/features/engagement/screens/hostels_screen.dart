import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/engagement/providers/engagement_providers.dart';
import 'package:mobile_app/features/engagement/widgets/hostel_widgets.dart';

class HostelsScreen extends ConsumerStatefulWidget {
  const HostelsScreen({super.key});

  @override
  ConsumerState<HostelsScreen> createState() => _HostelsScreenState();
}

class _HostelsScreenState extends ConsumerState<HostelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostels'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Leaderboard'),
            Tab(text: 'Battles'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _HostelLeaderboardTab(),
          _BattlesTab(),
        ],
      ),
    );
  }
}

class _HostelLeaderboardTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostelsAsync = ref.watch(hostelsProvider);

    return hostelsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (hostels) {
        if (hostels.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.apartment, size: 48, color: EcoColors.onSurfaceVariantLight),
                SizedBox(height: EcoTokens.spacing3),
                Text('No hostels found'),
                SizedBox(height: EcoTokens.spacing1),
                Text(
                  'Join a hostel to compete with others!',
                  style: TextStyle(color: EcoColors.onSurfaceVariantLight),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          itemCount: hostels.length,
          itemBuilder: (context, index) {
            final h = hostels[index];
            return HostelCard(
              name: h.name,
              totalScore: h.totalScore,
              memberCount: h.memberCount,
              rank: index + 1,
            );
          },
        );
      },
    );
  }
}

class _BattlesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battlesAsync = ref.watch(battlesProvider);

    return battlesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (battles) {
        if (battles.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sports_mma, size: 48, color: EcoColors.onSurfaceVariantLight),
                SizedBox(height: EcoTokens.spacing3),
                Text('No battles yet'),
                SizedBox(height: EcoTokens.spacing1),
                Text(
                  'Start a battle between hostels!',
                  style: TextStyle(color: EcoColors.onSurfaceVariantLight),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          itemCount: battles.length,
          itemBuilder: (context, index) {
            return BattleCard(battle: battles[index]);
          },
        );
      },
    );
  }
}
