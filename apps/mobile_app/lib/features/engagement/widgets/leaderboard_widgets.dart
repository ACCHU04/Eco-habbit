import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';

class LeaderboardRankBadge extends StatelessWidget {
  final int rank;
  final double size;
  const LeaderboardRankBadge({super.key, required this.rank, this.size = 32});

  @override
  Widget build(BuildContext context) {
    if (rank <= 3) {
      final emojis = ['🥇', '🥈', '🥉'];
      final labels = ['Gold medal', 'Silver medal', 'Bronze medal'];
      return Semantics(
        label: labels[rank - 1],
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(emojis[rank - 1], style: TextStyle(fontSize: size * 0.6)),
          ),
        ),
      );
    }
        return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: EcoColors.surfaceContainerLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
            color: EcoColors.onSurfaceVariantLight,
          ),
        ),
      ),
    );
  }
}

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final String? profilePhoto;
  final int score;
  final String scoreLabel;
  final bool isCurrentUser;
  final VoidCallback? onTap;

  const LeaderboardTile({
    super.key,
    required this.rank,
    required this.name,
    this.profilePhoto,
    required this.score,
    this.scoreLabel = 'pts',
    this.isCurrentUser = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrentUser
          ? EcoColors.primary.withValues(alpha: 0.05)
          : null,
      margin: const EdgeInsets.only(bottom: EcoTokens.spacing2),
      child: ListTile(
        onTap: onTap,
        leading: LeaderboardRankBadge(rank: rank),
        title: Text(
          isCurrentUser ? '$name (You)' : name,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Text(
          '$score $scoreLabel',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: EcoColors.primary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class FilterChipRow extends StatelessWidget {
  final List<String> labels;
  final List<String> values;
  final String selected;
  final ValueChanged<String> onSelected;

  const FilterChipRow({
    super.key,
    required this.labels,
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: EcoTokens.spacing2),
        itemBuilder: (context, index) {
          final isSelected = values[index] == selected;
          return FilterChip(
            label: Text(labels[index]),
            selected: isSelected,
            onSelected: (_) => onSelected(values[index]),
            selectedColor: EcoColors.primary,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : cs.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          );
        },
      ),
    );
  }
}

class PeriodChipRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const PeriodChipRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _labels = ['Weekly', 'Monthly', 'All Time'];
  static const _values = ['weekly', 'monthly', 'allTime'];

  @override
  Widget build(BuildContext context) {
    return FilterChipRow(
      labels: _labels,
      values: _values,
      selected: selected,
      onSelected: onSelected,
    );
  }
}
