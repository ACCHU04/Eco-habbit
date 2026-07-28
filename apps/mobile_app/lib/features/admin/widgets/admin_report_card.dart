import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/colors.dart';
import '../models/admin_report.dart';

class AdminReportCard extends StatelessWidget {
  final AdminReport report;
  final VoidCallback? onTap;
  final VoidCallback? onResolve;
  final VoidCallback? onDismiss;

  const AdminReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.onResolve,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing4,
        vertical: EcoTokens.spacing2,
      ),
      child: Padding(
        padding: EcoTokens.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ContentTypeBadge(contentType: report.contentType),
                const SizedBox(width: EcoTokens.spacing2),
                _ReasonBadge(reason: report.reason),
                const Spacer(),
                _StatusBadge(status: report.status),
              ],
            ),
            const SizedBox(height: EcoTokens.spacing3),
            Text(
              'Reported by ${report.reporterName ?? 'Unknown'}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (report.description != null &&
                report.description!.isNotEmpty) ...[
              const SizedBox(height: EcoTokens.spacing2),
              Text(
                report.description!,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (report.isPending) ...[
              const SizedBox(height: EcoTokens.spacing3),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDismiss,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Dismiss'),
                    ),
                  ),
                  const SizedBox(width: EcoTokens.spacing2),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onResolve,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Resolve'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContentTypeBadge extends StatelessWidget {
  final String contentType;
  const _ContentTypeBadge({required this.contentType});

  @override
  Widget build(BuildContext context) {
    final color = switch (contentType) {
      'post' => AppColors.postTypeDiy,
      'marketplace_listing' => AppColors.coinGold,
      'comment' => AppColors.info,
      _ => Colors.grey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing2,
        vertical: EcoTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
      ),
      child: Text(
        contentType.replaceAll('_', ' '),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ReasonBadge extends StatelessWidget {
  final String reason;
  const _ReasonBadge({required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing2,
        vertical: EcoTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(25),
        borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
      ),
      child: Text(
        reason,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.error,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'pending' => AppColors.warning,
      'resolved' => AppColors.success,
      'dismissed' => Colors.grey,
      _ => Colors.grey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing2,
        vertical: EcoTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
