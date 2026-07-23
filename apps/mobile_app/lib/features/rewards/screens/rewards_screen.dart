import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_theme.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eco Rewards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.star, size: 48, color: AppColors.primary),
                  const SizedBox(height: 8),
                  const Text(
                    '1,250',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const Text('Total Points', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(label: 'Listings', value: '12'),
                      _StatItem(label: 'Sales', value: '3'),
                      _StatItem(label: 'Scans', value: '28'),
                      _StatItem(label: 'DIY', value: '5'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _BadgeChip(emoji: '🌱', label: 'First Sale', earned: true),
              _BadgeChip(emoji: '♻️', label: 'Recycler', earned: true),
              _BadgeChip(emoji: '🎨', label: 'Creator', earned: false),
              _BadgeChip(emoji: '💬', label: 'Community Star', earned: false),
              _BadgeChip(emoji: '🏆', label: 'Campus Champion', earned: false),
              _BadgeChip(emoji: '🌍', label: 'Eco Warrior', earned: false),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Leaderboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _LeaderboardItem(rank: 1, name: 'Priya M.', points: 2450, avatar: 'PM'),
          _LeaderboardItem(rank: 2, name: 'You', points: 1250, avatar: 'YO', isCurrentUser: true),
          _LeaderboardItem(rank: 3, name: 'Rahul K.', points: 980, avatar: 'RK'),
          _LeaderboardItem(rank: 4, name: 'Aisha S.', points: 750, avatar: 'AS'),
          _LeaderboardItem(rank: 5, name: 'Campus Green', points: 620, avatar: 'CG'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
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
        color: earned ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
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
  final String avatar;
  final bool isCurrentUser;
  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.points,
    required this.avatar,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrentUser ? AppColors.primary.withOpacity(0.05) : null,
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
