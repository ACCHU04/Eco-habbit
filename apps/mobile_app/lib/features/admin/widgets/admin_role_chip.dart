import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/colors.dart';

class AdminRoleChip extends StatelessWidget {
  final String role;
  const AdminRoleChip({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      'super_admin' => AppColors.warning,
      'admin' => AppColors.primary,
      'moderator' => AppColors.info,
      'organization' => AppColors.secondary,
      'ngo' => AppColors.success,
      _ => Colors.grey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing3,
        vertical: EcoTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Text(
        role.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
