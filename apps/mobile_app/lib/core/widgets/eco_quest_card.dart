import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_card.dart';

/// A quest card showing title, description, XP reward, difficulty, and progress.
///
/// ```dart
/// EcoQuestCard(
///   title: 'Campus Cleanup',
///   description: 'Pick up 5 pieces of litter around campus',
///   xpReward: 150,
///   difficulty: QuestDifficulty.medium,
///   progress: 0.6,
///   onTap: () {},
/// )
/// ```
enum QuestDifficulty { easy, medium, hard, legendary }

class EcoQuestCard extends StatelessWidget {
  const EcoQuestCard({
    super.key,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.difficulty,
    this.progress,
    this.coinReward,
    this.onTap,
    this.completed = false,
  });

  final String title;
  final String description;
  final int xpReward;
  final QuestDifficulty difficulty;
  final double? progress;
  final int? coinReward;
  final VoidCallback? onTap;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (difficultyLabel, difficultyColor) = switch (difficulty) {
      QuestDifficulty.easy => ('Easy', EcoColors.difficultyEasy),
      QuestDifficulty.medium => ('Medium', EcoColors.difficultyMedium),
      QuestDifficulty.hard => ('Hard', EcoColors.difficultyHard),
      QuestDifficulty.legendary => ('Legendary', EcoColors.difficultyLegendary),
    };

    return EcoCard(
      onTap: onTap,
      borderColor: completed ? EcoColors.success.withValues(alpha: 0.3) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: EcoTokens.spacing2,
                  vertical: EcoTokens.spacing1,
                ),
                decoration: BoxDecoration(
                  color: difficultyColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                ),
                child: Text(
                  difficultyLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: difficultyColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              Icon(
                completed ? Icons.check_circle : Icons.play_circle_outline,
                color: completed ? EcoColors.success : cs.onSurfaceVariant,
                size: EcoTokens.iconSizeMd,
              ),
            ],
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: EcoTokens.spacing1),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Row(
            children: [
              const Icon(Icons.bolt, color: EcoColors.xpPurple, size: EcoTokens.iconSizeSm),
              const SizedBox(width: EcoTokens.spacing1),
              Text(
                '$xpReward XP',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: EcoColors.xpPurple,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (coinReward != null) ...[
                const SizedBox(width: EcoTokens.spacing3),
                const Icon(Icons.monetization_on, color: EcoColors.coinGold, size: EcoTokens.iconSizeSm),
                const SizedBox(width: EcoTokens.spacing1),
                Text(
                  '$coinReward',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: EcoColors.coinGold,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: EcoTokens.spacing3),
            LinearProgressIndicator(
              value: progress!.clamp(0.0, 1.0),
              backgroundColor: cs.primaryContainer,
              borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
              minHeight: 6,
            ),
          ],
        ],
      ),
    );
  }
}
