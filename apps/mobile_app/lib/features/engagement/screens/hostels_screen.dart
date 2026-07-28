import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_empty_state.dart';
import 'package:mobile_app/core/widgets/eco_error_view.dart';
import 'package:mobile_app/core/widgets/eco_skeleton.dart';
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
      loading: () => const _HostelSkeleton(),
      error: (e, _) => EcoErrorView(
        message: 'Failed to load hostels',
        onRetry: () => ref.invalidate(hostelsProvider),
      ),
      data: (hostels) {
        if (hostels.isEmpty) {
          return const EcoEmptyState(
            icon: Icons.apartment_outlined,
            title: 'No hostels found',
            subtitle: 'Join a hostel to compete with others!',
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
      loading: () => const _HostelSkeleton(),
      error: (e, _) => EcoErrorView(
        message: 'Failed to load battles',
        onRetry: () => ref.invalidate(battlesProvider),
      ),
      data: (battles) {
        if (battles.isEmpty) {
          return const EcoEmptyState(
            icon: Icons.sports_mma_outlined,
            title: 'No battles yet',
            subtitle: 'Start a battle between hostels!',
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

class _HostelSkeleton extends StatelessWidget {
  const _HostelSkeleton();

  @override
  Widget build(BuildContext context) {
    return EcoSkeleton(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(EcoTokens.spacing4),
        itemCount: 5,
        itemBuilder: (_, __) => const EcoSkeletonTile(),
      ),
    );
  }
}
