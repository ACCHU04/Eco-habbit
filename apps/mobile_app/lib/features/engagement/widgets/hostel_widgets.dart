import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/engagement/models/hostel_models.dart';

class BattleCard extends StatelessWidget {
  final HostelBattle battle;
  final VoidCallback? onTap;

  const BattleCard({super.key, required this.battle, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = battle.isActive;
    final statusColor = isActive ? EcoColors.primary : EcoColors.onSurfaceVariantLight;
    final statusText = isActive ? 'Active' : (battle.status == 'completed' ? 'Completed' : 'Cancelled');

    return Card(
      margin: const EdgeInsets.only(bottom: EcoTokens.spacing3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      battle.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: EcoTokens.spacing2,
                      vertical: EcoTokens.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: EcoTokens.spacing2),
              Text(
                battle.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: EcoTokens.spacing3),
              Row(
                children: [
                  _BattleHostelBadge(
                    name: battle.hosteler?.name ?? 'Hostel A',
                    score: battle.startScoreHosteler,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing3),
                    child: Semantics(
                      label: 'Versus',
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: EcoColors.streakFlame,
                        ),
                      ),
                    ),
                  ),
                  _BattleHostelBadge(
                    name: battle.challenger?.name ?? 'Hostel B',
                    score: battle.startScoreChallenger,
                  ),
                  const Spacer(),
                  if (isActive)
                    Text(
                      _formatDuration(battle.endsAt.difference(DateTime.now())),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: EcoColors.warning,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d left';
    if (d.inHours > 0) return '${d.inHours}h left';
    return '${d.inMinutes}m left';
  }
}

class _BattleHostelBadge extends StatelessWidget {
  final String name;
  final int score;

  const _BattleHostelBadge({required this.name, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Text(
          '$score pts',
          style: const TextStyle(
            fontSize: 12,
            color: EcoColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class HostelCard extends StatelessWidget {
  final String name;
  final int totalScore;
  final int memberCount;
  final int rank;
  final bool isUserHostel;
  final VoidCallback? onTap;

  const HostelCard({
    super.key,
    required this.name,
    required this.totalScore,
    required this.memberCount,
    required this.rank,
    this.isUserHostel = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isUserHostel ? EcoColors.primary.withValues(alpha: 0.05) : null,
      margin: const EdgeInsets.only(bottom: EcoTokens.spacing2),
        child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isUserHostel
              ? EcoColors.primary.withValues(alpha: 0.15)
              : EcoColors.surfaceContainerLight,
          child: Semantics(
            label: rank <= 3 ? 'Rank $rank medal' : 'Rank $rank',
            child: Text(
              rank <= 3 ? ['🥇', '🥈', '🥉'][rank - 1] : '#$rank',
              style: TextStyle(
                fontSize: rank <= 3 ? 18 : 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          isUserHostel ? '$name (Your Hostel)' : name,
          style: TextStyle(
            fontWeight: isUserHostel ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text('$memberCount members'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$totalScore pts',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: EcoColors.primary,
              ),
            ),
            Text(
              '${(totalScore / (memberCount > 0 ? memberCount : 1)).round()} avg',
              style: const TextStyle(
                fontSize: 11,
                color: EcoColors.onSurfaceVariantLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
