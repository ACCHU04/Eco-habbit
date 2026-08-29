import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/colors.dart';
import '../models/admin_user.dart';

class AdminUserTile extends StatelessWidget {
  final AdminUser user;
  final VoidCallback? onTap;

  const AdminUserTile({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing4,
        vertical: EcoTokens.spacing2,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: user.role == 'super_admin'
              ? AppColors.warning
              : user.role == 'admin'
                  ? AppColors.primary
                  : theme.colorScheme.surfaceContainerHighest,
          child: Text(
            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
            style: TextStyle(
              color: user.role == 'super_admin' || user.role == 'admin'
                  ? Colors.white
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${user.email} · ${user.role}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: _StatusChip(status: user.status),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'active' => AppColors.success,
      'suspended' => AppColors.warning,
      'deactivated' => AppColors.error,
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
        border: Border.all(color: color.withAlpha(77)),
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
