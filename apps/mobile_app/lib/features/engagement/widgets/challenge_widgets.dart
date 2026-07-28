import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/engagement/models/challenge_models.dart';

class ChallengeCard extends StatelessWidget {
  final FriendChallenge challenge;
  final bool isChallenger;
  final VoidCallback? onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.isChallenger,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final myProgress = isChallenger
        ? challenge.challengerProgress
        : challenge.challengeeProgress;
    final theirProgress = isChallenger
        ? challenge.challengeeProgress
        : challenge.challengerProgress;
    final opponent = isChallenger
        ? challenge.challengee
        : challenge.challenger;
    final progress = challenge.goalCount > 0
        ? myProgress / challenge.goalCount
        : 0.0;

    final statusColor = switch (challenge.status) {
      'active' => EcoColors.primary,
      'pending' => EcoColors.warning,
      'completed' => EcoColors.info,
      _ => EcoColors.onSurfaceVariantLight,
    };

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
                      challenge.title,
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
                      challenge.status[0].toUpperCase() + challenge.status.substring(1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: EcoTokens.spacing1),
              Text(
                'vs ${opponent?.fullName ?? 'Unknown'}',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: EcoTokens.spacing2),
              Text(
                challenge.goalActionLabel,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: EcoTokens.spacing2),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'You: $myProgress/${challenge.goalCount}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Them: $theirProgress/${challenge.goalCount}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: EcoColors.onSurfaceVariantLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: EcoTokens.spacing1),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: EcoColors.surfaceContainerLight,
                            color: EcoColors.primary,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: EcoTokens.spacing2),
              Row(
                children: [
                  _RewardChip(
                    icon: Icons.star,
                    label: '${challenge.xpReward} XP',
                    color: EcoColors.xpPurple,
                  ),
                  const SizedBox(width: EcoTokens.spacing2),
                  _RewardChip(
                    icon: Icons.monetization_on,
                    label: '${challenge.coinReward} coins',
                    color: EcoColors.coinGold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _RewardChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing2,
        vertical: EcoTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: EcoTokens.spacing1),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  final String name;
  final String? profilePhoto;
  final String friendshipId;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const FriendTile({
    super.key,
    required this.name,
    this.profilePhoto,
    required this.friendshipId,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: EcoColors.primary.withValues(alpha: 0.15),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: EcoColors.primary,
          ),
        ),
      ),
      title: Text(name),
      trailing: onRemove != null
          ? IconButton(
              icon: const Icon(Icons.person_remove, color: EcoColors.error),
              onPressed: onRemove,
            )
          : null,
    );
  }
}

class FriendRequestTile extends StatelessWidget {
  final String name;
  final String? profilePhoto;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const FriendRequestTile({
    super.key,
    required this.name,
    this.profilePhoto,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: EcoColors.warning.withValues(alpha: 0.15),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: EcoColors.warning,
          ),
        ),
      ),
      title: Text(name),
      subtitle: const Text('wants to be your friend'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: EcoColors.success),
            onPressed: onAccept,
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: EcoColors.error),
            onPressed: onDecline,
          ),
        ],
      ),
    );
  }
}
