import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/passport/providers/passport_provider.dart';
import 'package:mobile_app/features/passport/models/passport_data.dart';

class ActivityTimelineScreen extends ConsumerWidget {
  const ActivityTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timelineAsync = ref.watch(timelineProvider);
    final notifier = ref.read(timelineProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity Timeline')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(timelineProvider.notifier).reload(),
        child: timelineAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load timeline'),
                TextButton(
                  onPressed: () => ref.read(timelineProvider.notifier).reload(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (entries) {
            if (entries.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timeline, size: 64, color: Colors.grey),
                    SizedBox(height: EcoTokens.spacing3),
                    Text('No activity yet', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    SizedBox(height: EcoTokens.spacing1),
                    Text('Complete quests to see your timeline', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            final grouped = _groupByDay(entries);

            return ListView.builder(
              padding: const EdgeInsets.all(EcoTokens.spacing4),
              itemCount: grouped.length + (notifier.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == grouped.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(EcoTokens.spacing4),
                      child: TextButton(
                        onPressed: () => notifier.loadMore(),
                        child: const Text('Load more'),
                      ),
                    ),
                  );
                }

                final group = grouped[index];
                final dateLabel = group['label'] as String;
                final items = group['entries'] as List<TimelineEntry>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: EcoTokens.spacing2),
                      child: Text(
                        dateLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    ...items.map((entry) => _TimelineTile(entry: entry)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _groupByDay(List<TimelineEntry> entries) {
    final groups = <String, List<TimelineEntry>>{};

    for (final entry in entries) {
      final key = '${entry.createdAt.year}-${entry.createdAt.month}-${entry.createdAt.day}';
      groups.putIfAbsent(key, () => []).add(entry);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final result = <Map<String, dynamic>>[];
    for (final entry in entries) {
      final date = DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      final key = '${date.year}-${date.month}-${date.day}';
      if (groups.containsKey(key)) {
        String label;
        if (date == today) {
          label = 'Today';
        } else if (date == yesterday) {
          label = 'Yesterday';
        } else {
          final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          label = '${months[date.month - 1]} ${date.day}';
        }
        result.add({'label': label, 'entries': groups.remove(key)!});
      }
    }

    return result;
  }
}

class _TimelineTile extends StatelessWidget {
  final TimelineEntry entry;

  const _TimelineTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: EcoTokens.spacing2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(_actionIcon(entry.action), size: 20, color: AppColors.primary),
        ),
        title: Text(
          entry.displayLabel,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Text(
          '${entry.createdAt.hour.toString().padLeft(2, '0')}:${entry.createdAt.minute.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (entry.points > 0) ...[
              const Icon(Icons.star, size: 14, color: AppColors.xpPurple),
              const SizedBox(width: 2),
              Text('${entry.points}', style: const TextStyle(fontSize: 12, color: AppColors.xpPurple, fontWeight: FontWeight.w600)),
            ],
            if (entry.coinValue > 0) ...[
              const SizedBox(width: EcoTokens.spacing2),
              const Icon(Icons.monetization_on, size: 14, color: AppColors.coinGold),
              const SizedBox(width: 2),
              Text('${entry.coinValue}', style: const TextStyle(fontSize: 12, color: AppColors.coinGold, fontWeight: FontWeight.w600)),
            ],
          ],
        ),
      ),
    );
  }

  IconData _actionIcon(String action) {
    switch (action) {
      case 'list_item':
        return Icons.add_box;
      case 'complete_sale':
        return Icons.storefront;
      case 'complete_donation':
        return Icons.volunteer_activism;
      case 'recycle_item':
        return Icons.recycling;
      case 'post_community':
        return Icons.article;
      case 'like_post':
        return Icons.favorite;
      case 'comment_post':
        return Icons.comment;
      case 'ai_scan':
        return Icons.camera_alt;
      case 'complete_diy':
        return Icons.build;
      case 'refer_friend':
        return Icons.person_add;
      default:
        return action.startsWith('quest_complete:') ? Icons.task_alt : Icons.star;
    }
  }
}
