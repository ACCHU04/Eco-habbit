import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';
import '../models/campus.dart';

class CampusAvatar extends StatelessWidget {
  final Campus campus;
  final double size;

  const CampusAvatar({
    super.key,
    required this.campus,
    this.size = EcoTokens.iconSizeLg,
  });

  @override
  Widget build(BuildContext context) {
    if (campus.logoUrl != null && campus.logoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(campus.logoUrl!),
        onBackgroundImageError: (_, __) => _buildFallback(context),
      );
    }
    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        campus.shortName ?? campus.name.substring(0, 2).toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
