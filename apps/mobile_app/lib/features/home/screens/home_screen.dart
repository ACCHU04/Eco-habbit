import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/coins/providers/coins_provider.dart';
import 'package:mobile_app/features/home/providers/home_provider.dart';
import 'package:mobile_app/features/profile/providers/profile_provider.dart';
import 'package:mobile_app/features/quests/providers/quests_provider.dart';
import 'package:mobile_app/features/quests/models/quest.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).valueOrNull?.user;
    final dashboardAsync = ref.watch(dashboardProvider);
    final todayQuests = ref.watch(todayQuestsProvider);
    final coinBalance = ref.watch(coinBalanceProvider);
    final statsAsync = ref.watch(profileStatsProvider);
    final firstName = (user?.fullName ?? '').trim().split(' ').first;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(todayQuestsProvider.notifier).reload();
        ref.read(coinBalanceProvider.notifier).reload();
        ref.read(dashboardProvider.notifier).reload();
        ref.read(profileStatsProvider.notifier).reload();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(context, theme, firstName, user?.college, statsAsync, coinBalance, dashboardAsync),
            _buildQuickActions(context, theme),
            _buildTodayQuests(context, ref, theme, todayQuests),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(
    BuildContext context,
    ThemeData theme,
    String firstName,
    String? college,
    AsyncValue statsAsync,
    AsyncValue coinBalance,
    AsyncValue dashboardAsync,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(EcoTokens.spacing5),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${firstName.isNotEmpty ? firstName : 'Student'}!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (college != null && college.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: EcoTokens.spacing1),
              child: Text(
                college,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          const SizedBox(height: EcoTokens.spacing4),
          Row(
            children: [
              _HeroStat(
                icon: Icons.star_outline,
                value: statsAsync.when(
                  data: (s) => '${s.totalPoints}',
                  loading: () => '--',
                  error: (_, __) => '0',
                ),
                label: 'Points',
              ),
              const SizedBox(width: EcoTokens.spacing5),
              _HeroStat(
                icon: Icons.monetization_on_outlined,
                value: coinBalance.when(
                  data: (b) => '${b.totalCoins}',
                  loading: () => '--',
                  error: (_, __) => '0',
                ),
                label: 'Coins',
              ),
              const SizedBox(width: EcoTokens.spacing5),
              _HeroStat(
                icon: Icons.military_tech_outlined,
                value: statsAsync.when(
                  data: (s) => '${s.badgesCount}',
                  loading: () => '--',
                  error: (_, __) => '0',
                ),
                label: 'Badges',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(EcoTokens.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.camera_alt_outlined,
                  label: 'Scan Item',
                  onTap: () => context.go('/scanner'),
                ),
              ),
              const SizedBox(width: EcoTokens.spacing3),
              Expanded(
                child: _QuickAction(
                  icon: Icons.add_circle_outline,
                  label: 'Sell Item',
                  onTap: () => context.push('/create-listing'),
                ),
              ),
              const SizedBox(width: EcoTokens.spacing3),
              Expanded(
                child: _QuickAction(
                  icon: Icons.build_outlined,
                  label: 'DIY Projects',
                  onTap: () => context.push('/diy'),
                ),
              ),
              const SizedBox(width: EcoTokens.spacing3),
              Expanded(
                child: _QuickAction(
                  icon: Icons.leaderboard_outlined,
                  label: 'Social',
                  onTap: () => context.push('/engage'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayQuests(BuildContext context, WidgetRef ref, ThemeData theme, AsyncValue<List<Quest>> todayQuests) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Quests",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => context.push('/quests'),
                child: const Text('View All'),
              ),
            ],
          ),
          todayQuests.when(
            loading: () => const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => SizedBox(
              height: 120,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Could not load quests', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => ref.read(todayQuestsProvider.notifier).reload(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (quests) {
              if (quests.isEmpty) {
                return const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text('No quests available today', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return Column(
                children: quests.map((quest) => Padding(
                  padding: const EdgeInsets.only(bottom: EcoTokens.spacing2),
                  child: _QuestTile(
                    quest: quest,
                    onComplete: () async {
                      final result = await ref.read(todayQuestsProvider.notifier).completeQuest(quest.id);
                      if (context.mounted && result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result.completed
                                  ? 'Quest complete! +${result.xpAwarded} XP, +${result.coinsAwarded} coins${result.leveledUp ? ' Level Up!' : ''}'
                                  : 'Progress: ${result.currentCount}/${quest.targetCount}',
                            ),
                            backgroundColor: result.completed ? AppColors.success : AppColors.primary,
                          ),
                        );
                      }
                    },
                  ),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HeroStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.9)),
        const SizedBox(width: EcoTokens.spacing1),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: EcoTokens.spacing4),
          child: Column(
            children: [
              Icon(icon, size: EcoTokens.iconSizeLg, color: theme.colorScheme.primary),
              const SizedBox(height: EcoTokens.spacing2),
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestTile extends StatelessWidget {
  final Quest quest;
  final VoidCallback onComplete;

  const _QuestTile({required this.quest, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color difficultyColor;
    switch (quest.difficulty) {
      case 'easy':
        difficultyColor = AppColors.success;
      case 'medium':
        difficultyColor = AppColors.warning;
      case 'hard':
        difficultyColor = Colors.deepOrange;
      case 'legendary':
        difficultyColor = Colors.amber;
      default:
        difficultyColor = AppColors.primary;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(EcoTokens.spacing3),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: quest.completed ? AppColors.success : difficultyColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: EcoTokens.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          quest.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: quest.completed ? TextDecoration.lineThrough : null,
                            color: quest.completed ? Colors.grey : null,
                          ),
                        ),
                      ),
                      _QuestRewardChip(xp: quest.xpReward, coins: quest.coinReward),
                    ],
                  ),
                  const SizedBox(height: EcoTokens.spacing1),
                  Text(
                    quest.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  if (!quest.completed && quest.targetCount > 1) ...[
                    const SizedBox(height: EcoTokens.spacing2),
                    LinearProgressIndicator(
                      value: quest.progressPercent,
                      backgroundColor: Colors.grey[200],
                      color: difficultyColor,
                      borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                      minHeight: 6,
                    ),
                    const SizedBox(height: EcoTokens.spacing1),
                    Text(
                      '${quest.progress}/${quest.targetCount}',
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: EcoTokens.spacing2),
            quest.completed
                ? const Icon(Icons.check_circle, color: AppColors.success, size: 28)
                : SizedBox(
                    height: 36,
                    child: FilledButton(
                      onPressed: onComplete,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing3),
                      ),
                      child: const Text('Go', style: TextStyle(fontSize: 12)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _QuestRewardChip extends StatelessWidget {
  final int xp;
  final int coins;

  const _QuestRewardChip({required this.xp, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing2, vertical: EcoTokens.spacing1),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 12, color: AppColors.primary),
          const SizedBox(width: 2),
          Text('$xp', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
          const SizedBox(width: EcoTokens.spacing1),
          const Icon(Icons.monetization_on, size: 12, color: AppColors.warning),
          const SizedBox(width: 2),
          Text('$coins', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning)),
        ],
      ),
    );
  }
}
