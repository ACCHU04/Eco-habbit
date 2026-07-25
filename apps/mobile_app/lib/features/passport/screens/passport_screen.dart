import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/passport/providers/passport_provider.dart';
import 'package:mobile_app/features/passport/models/passport_data.dart';
import 'package:mobile_app/features/passport/widgets/share_card.dart';

class PassportScreen extends ConsumerWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final impactAsync = ref.watch(impactProvider);
    final streakAsync = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Passport'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final impact = impactAsync.valueOrNull;
              if (impact != null) {
                ShareCard.show(context, impact);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(impactProvider.notifier).reload();
          ref.read(streakProvider.notifier).reload();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLevelHero(context, theme, impactAsync),
              _buildStreakSection(context, theme, streakAsync),
              _buildImpactGrid(context, theme, impactAsync),
              _buildActionSummary(context, theme, impactAsync),
              _buildAchievementsSection(context, ref, theme),
              _buildTimelineLink(context, theme),
              const SizedBox(height: EcoTokens.spacing8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelHero(BuildContext context, ThemeData theme, AsyncValue<ImpactData> impactAsync) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(EcoTokens.spacing6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: impactAsync.when(
        loading: () => const SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
        error: (_, __) => const SizedBox(height: 80, child: Center(child: Text('Error', style: TextStyle(color: Colors.white)))),
        data: (impact) => Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
              ),
              child: Center(
                child: Text(
                  '${impact.level}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: EcoTokens.spacing3),
            Text(
              'Level ${impact.level}',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: EcoTokens.spacing2),
            _XpProgressBar(currentXp: impact.totalXp),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakSection(BuildContext context, ThemeData theme, AsyncValue<StreakData> streakAsync) {
    return streakAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (streak) {
        if (streak.currentStreak == 0) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.all(EcoTokens.spacing4),
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.streakFlame.withValues(alpha: 0.1),
                AppColors.coinGold.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
            border: Border.all(color: AppColors.streakFlame.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Text(
                _streakEmoji(streak.currentStreak),
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(width: EcoTokens.spacing4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${streak.currentStreak}-Day Streak!',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.streakFlame,
                      ),
                    ),
                    Text(
                      'Best: ${streak.longestStreak} days',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _streakEmoji(int days) {
    if (days >= 30) return '🌟';
    if (days >= 14) return '🔥';
    if (days >= 7) return '🔥';
    if (days >= 3) return '⚡';
    return '✨';
  }

  Widget _buildImpactGrid(BuildContext context, ThemeData theme, AsyncValue<ImpactData> impactAsync) {
    return impactAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox(
        height: 200,
        child: Center(child: Text('Could not load impact')),
      ),
      data: (impact) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Environmental Impact',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: EcoTokens.spacing3),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: EcoTokens.spacing2,
              crossAxisSpacing: EcoTokens.spacing2,
              childAspectRatio: 1.6,
              children: [
                _ImpactTile(metric: impact.co2, color: AppColors.impactCarbon, icon: Icons.cloud_outlined),
                _ImpactTile(metric: impact.waste, color: AppColors.impactWaste, icon: Icons.delete_outline),
                _ImpactTile(metric: impact.water, color: AppColors.impactWater, icon: Icons.water_drop_outlined),
                _ImpactTile(metric: impact.energy, color: AppColors.impactEnergy, icon: Icons.bolt_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSummary(BuildContext context, ThemeData theme, AsyncValue<ImpactData> impactAsync) {
    return impactAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (impact) => Padding(
        padding: const EdgeInsets.all(EcoTokens.spacing4),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(EcoTokens.spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Actions Completed', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: EcoTokens.spacing3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionStat(icon: Icons.recycling, label: 'Recycled', value: impact.itemsRecycled),
                    _ActionStat(icon: Icons.storefront, label: 'Sold', value: impact.itemsSold),
                    _ActionStat(icon: Icons.build, label: 'DIY', value: impact.diyCompleted),
                    _ActionStat(icon: Icons.camera_alt, label: 'Scans', value: impact.scansCompleted),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => context.push('/rewards'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: EcoTokens.spacing2),
          _buildBadgeChips(ref),
        ],
      ),
    );
  }

  Widget _buildBadgeChips(WidgetRef ref) {
    const badgeDisplay = {
      'first_sale': ('🌱', 'First Sale'),
      'recycler': ('♻️', 'Recycler'),
      'creator': ('🎨', 'Creator'),
      'community_star': ('💬', 'Community Star'),
      'campus_champion': ('🏆', 'Campus Champion'),
      'eco_warrior': ('🌍', 'Eco Warrior'),
    };

    return Wrap(
      spacing: EcoTokens.spacing2,
      runSpacing: EcoTokens.spacing2,
      children: badgeDisplay.entries.map((e) {
        final (emoji, label) = e.value;
        return Chip(
          avatar: Text(emoji, style: const TextStyle(fontSize: 16)),
          label: Text(label, style: const TextStyle(fontSize: 12)),
          backgroundColor: AppColors.primary.withValues(alpha: 0.08),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
        );
      }).toList(),
    );
  }

  Widget _buildTimelineLink(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.timeline, color: AppColors.primary),
          title: const Text('Activity Timeline'),
          subtitle: const Text('View your complete history'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/passport/timeline'),
        ),
      ),
    );
  }
}

class _XpProgressBar extends StatelessWidget {
  final int currentXp;

  const _XpProgressBar({required this.currentXp});

  static const thresholds = [
    0, 100, 300, 600, 1000, 1500, 2200, 3000, 4000, 5200,
    6600, 8200, 10000, 12200, 14800, 17800, 21200, 25000, 29200, 34000,
  ];

  @override
  Widget build(BuildContext context) {
    int level = 1;
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (currentXp >= thresholds[i]) {
        level = i + 1;
        break;
      }
    }

    final currentThreshold = thresholds[(level - 1).clamp(0, thresholds.length - 1)];
    final nextThreshold = level < thresholds.length ? thresholds[level] : thresholds.last;
    final xpInLevel = currentXp - currentThreshold;
    final xpNeeded = nextThreshold - currentThreshold;
    final progress = xpNeeded > 0 ? (xpInLevel / xpNeeded).clamp(0.0, 1.0) : 1.0;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: EcoTokens.spacing1),
        Text(
          '$xpInLevel / $xpNeeded XP to Level ${level + 1}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _ImpactTile extends StatelessWidget {
  final ImpactMetric metric;
  final Color color;
  final IconData icon;

  const _ImpactTile({required this.metric, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(EcoTokens.spacing3),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: EcoTokens.spacing2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${metric.displayValue} ${metric.unit}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    metric.label,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _ActionStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: EcoTokens.spacing1),
        Text(
          '$value',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      ],
    );
  }
}
