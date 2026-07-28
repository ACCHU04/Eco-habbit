import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_empty_state.dart';
import 'package:mobile_app/core/widgets/eco_error_view.dart';
import 'package:mobile_app/core/widgets/eco_skeleton.dart';
import 'package:mobile_app/features/engagement/models/achievement_models.dart';
import 'package:mobile_app/features/engagement/providers/engagement_providers.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: achievementsAsync.when(
        loading: () => EcoSkeleton(
          enabled: true,
          child: ListView.builder(
            padding: const EdgeInsets.all(EcoTokens.spacing4),
            itemCount: 5,
            itemBuilder: (_, __) => const EcoSkeletonTile(),
          ),
        ),
        error: (e, _) => EcoErrorView(
          message: 'Failed to load achievements',
          onRetry: () => ref.invalidate(achievementsProvider),
        ),
        data: (achievements) {
          if (achievements.isEmpty) {
            return const EcoEmptyState(
              icon: Icons.emoji_events_outlined,
              title: 'No achievements yet',
              subtitle: 'Start taking eco actions to earn achievements!',
            );
          }

          final completed = achievements.where((a) => a.completed).toList();
          final inProgress = achievements.where((a) => !a.completed).toList();

          return ListView(
            padding: const EdgeInsets.all(EcoTokens.spacing4),
            children: [
              if (completed.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.check_circle, size: 20, color: EcoColors.success),
                    const SizedBox(width: EcoTokens.spacing2),
                    Text(
                      'Completed (${completed.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: EcoColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: EcoTokens.spacing2),
                ...completed.map((a) => _AchievementCard(achievement: a)),
                const SizedBox(height: EcoTokens.spacing6),
              ],
              if (inProgress.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.trending_up, size: 20, color: EcoColors.primary),
                    const SizedBox(width: EcoTokens.spacing2),
                    Text(
                      'In Progress (${inProgress.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: EcoColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: EcoTokens.spacing2),
                ...inProgress.map((a) => _AchievementCard(achievement: a)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: EcoTokens.spacing2),
      child: Padding(
        padding: const EdgeInsets.all(EcoTokens.spacing4),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: achievement.completed
                    ? EcoColors.success.withValues(alpha: 0.1)
                    : EcoColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: EcoTokens.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: achievement.completed ? EcoColors.success : null,
                    ),
                  ),
                  const SizedBox(height: EcoTokens.spacing1),
                  Text(
                    achievement.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: EcoColors.onSurfaceVariantLight,
                    ),
                  ),
                  const SizedBox(height: EcoTokens.spacing2),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                          child: LinearProgressIndicator(
                            value: achievement.progress.clamp(0.0, 1.0),
                            backgroundColor: EcoColors.surfaceContainerLight,
                            color: achievement.completed
                                ? EcoColors.success
                                : EcoColors.primary,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: EcoTokens.spacing2),
                      Text(
                        '${achievement.current}/${achievement.target}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (achievement.completed)
              const Padding(
                padding: EdgeInsets.only(left: EcoTokens.spacing2),
                child: Icon(Icons.check_circle, color: EcoColors.success, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
