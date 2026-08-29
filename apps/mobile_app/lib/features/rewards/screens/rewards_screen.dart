import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/rewards/models/reward_models.dart';
import 'package:mobile_app/features/rewards/providers/rewards_provider.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Eco Rewards'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Points'),
            Tab(text: 'Badges'),
            Tab(text: 'Leaderboard'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PointsTab(),
          _BadgesTab(),
          _LeaderboardTab(),
        ],
      ),
    );
  }
}

class _PointsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(pointsProvider);
    final historyAsync = ref.watch(pointsHistoryProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: pointsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (points) => Column(
                children: [
                  const Icon(Icons.star, size: 48, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Text(
                    points.totalPoints.toString(),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const Text('Total Points', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Points History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (history) {
            if (history.items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No points history yet')),
              );
            }
            return Column(
              children: [
                ...history.items.map((item) => _PointsHistoryTile(item: item)),
                if (history.hasMore)
                  TextButton(
                    onPressed: () => ref.read(pointsHistoryProvider.notifier).loadMore(),
                    child: const Text('Load more'),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PointsHistoryTile extends StatelessWidget {
  final PointsHistoryItem item;
  const _PointsHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: const Icon(Icons.star, size: 16, color: AppColors.primary),
      ),
      title: Text(item.actionLabel, style: const TextStyle(fontSize: 14)),
      trailing: Text(
        '+${item.points}',
        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }
}

class _BadgesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesProvider);

    return badgesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (earnedBadges) {
        final earnedTypes = earnedBadges.map((b) => b.badgeType).toSet();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: badgeDisplay.entries.map((entry) {
                final earned = earnedTypes.contains(entry.key);
                return _BadgeChip(
                  emoji: entry.value.$1,
                  label: entry.value.$2,
                  earned: earned,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final currentUserId = ref.watch(authProvider).valueOrNull?.user?.id;

    return leaderboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(child: Text('No leaderboard data yet'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return _LeaderboardItem(
              rank: entry.rank,
              name: entry.userId == currentUserId ? '${entry.fullName} (You)' : entry.fullName,
              points: entry.totalPoints,
              isCurrentUser: entry.userId == currentUserId,
            );
          },
        );
      },
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool earned;
  const _BadgeChip({required this.emoji, required this.label, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: earned ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: earned ? AppColors.primary : Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 16, color: earned ? null : Colors.grey)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: earned ? AppColors.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final bool isCurrentUser;
  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.points,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrentUser ? AppColors.primary.withValues(alpha: 0.05) : null,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: SizedBox(
          width: 32,
          child: Text(
            rank <= 3 ? ['🥇', '🥈', '🥉'][rank - 1] : '#$rank',
            style: TextStyle(
              fontSize: rank <= 3 ? 20 : 14,
              fontWeight: FontWeight.bold,
              color: rank <= 3 ? null : Colors.grey,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Text(
          '$points pts',
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
      ),
    );
  }
}
