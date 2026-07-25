import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/quests/providers/quests_provider.dart';
import 'package:mobile_app/features/quests/models/quest.dart';

class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allQuests = ref.watch(allQuestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Quests')),
      body: allQuests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load quests'),
              TextButton(
                onPressed: () => ref.read(allQuestsProvider.notifier).reload(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (quests) {
          if (quests.isEmpty) {
            return const Center(
              child: Text('No quests available', style: TextStyle(color: Colors.grey)),
            );
          }

          final daily = quests.where((q) => q.questType == 'daily').toList();
          final weekly = quests.where((q) => q.questType == 'weekly').toList();
          final challenge = quests.where((q) => q.questType == 'challenge').toList();

          return RefreshIndicator(
            onRefresh: () => ref.read(allQuestsProvider.notifier).reload(),
            child: ListView(
              padding: const EdgeInsets.all(EcoTokens.spacing4),
              children: [
                if (daily.isNotEmpty) ...[
                  const _SectionHeader(title: 'Daily', icon: Icons.today, color: AppColors.primary),
                  const SizedBox(height: EcoTokens.spacing2),
                  ...daily.map((q) => _QuestCard(quest: q)),
                  const SizedBox(height: EcoTokens.spacing4),
                ],
                if (weekly.isNotEmpty) ...[
                  const _SectionHeader(title: 'Weekly', icon: Icons.date_range, color: AppColors.info),
                  const SizedBox(height: EcoTokens.spacing2),
                  ...weekly.map((q) => _QuestCard(quest: q)),
                  const SizedBox(height: EcoTokens.spacing4),
                ],
                if (challenge.isNotEmpty) ...[
                  const _SectionHeader(title: 'Challenges', icon: Icons.emoji_events, color: AppColors.xpPurple),
                  const SizedBox(height: EcoTokens.spacing2),
                  ...challenge.map((q) => _QuestCard(quest: q)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: EcoTokens.spacing2),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
      ],
    );
  }
}

class _QuestCard extends StatelessWidget {
  final Quest quest;

  const _QuestCard({required this.quest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final difficultyColor = switch (quest.difficulty) {
      'easy' => AppColors.difficultyEasy,
      'medium' => AppColors.difficultyMedium,
      'hard' => AppColors.difficultyHard,
      'legendary' => AppColors.difficultyLegendary,
      _ => AppColors.primary,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: EcoTokens.spacing2),
      child: Padding(
        padding: const EdgeInsets.all(EcoTokens.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(quest.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing2, vertical: 2),
                  decoration: BoxDecoration(
                    color: difficultyColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                  ),
                  child: Text(
                    quest.difficulty[0].toUpperCase() + quest.difficulty.substring(1),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: difficultyColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: EcoTokens.spacing1),
            Text(
              quest.description,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: EcoTokens.spacing2),
            Row(
              children: [
                _RewardBadge(icon: Icons.star, value: '${quest.xpReward} XP', color: AppColors.xpPurple),
                const SizedBox(width: EcoTokens.spacing2),
                _RewardBadge(icon: Icons.monetization_on, value: '${quest.coinReward} coins', color: AppColors.coinGold),
                const SizedBox(width: EcoTokens.spacing2),
                _RewardBadge(icon: Icons.repeat, value: 'x${quest.targetCount}', color: Colors.grey),
              ],
            ),
            const SizedBox(height: EcoTokens.spacing2),
            LinearProgressIndicator(
              value: quest.progressPercent,
              backgroundColor: Colors.grey[200],
              color: difficultyColor,
              borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
              minHeight: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _RewardBadge({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}
