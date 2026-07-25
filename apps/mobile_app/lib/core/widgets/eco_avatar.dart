import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A circular avatar with network image support, fallback icon, and status ring.
///
/// ```dart
/// EcoAvatar(
///   imageUrl: 'https://example.com/photo.jpg',
///   name: 'Chandu',
///   size: EcoAvatarSize.md,
/// )
/// ```
enum EcoAvatarSize { xs, sm, md, lg, xl }

class EcoAvatar extends StatelessWidget {
  const EcoAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = EcoAvatarSize.md,
    this.showStatusRing = false,
    this.statusColor,
    this.onTap,
  });

  final String? imageUrl;
  final String name;
  final EcoAvatarSize size;
  final bool showStatusRing;
  final Color? statusColor;
  final VoidCallback? onTap;

  double get _dimension => switch (size) {
        EcoAvatarSize.xs => 28,
        EcoAvatarSize.sm => 36,
        EcoAvatarSize.md => 44,
        EcoAvatarSize.lg => 56,
        EcoAvatarSize.xl => 72,
      };

  double get _fontSize => switch (size) {
        EcoAvatarSize.xs => 10,
        EcoAvatarSize.sm => 12,
        EcoAvatarSize.md => 16,
        EcoAvatarSize.lg => 20,
        EcoAvatarSize.xl => 28,
      };

  double get _ringWidth => size == EcoAvatarSize.xl ? 3 : 2;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ringColor = statusColor ?? cs.primary;

    final avatar = ClipOval(
      child: SizedBox(
        width: _dimension,
        height: _dimension,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _FallbackAvatar(
                  initials: _initials,
                  fontSize: _fontSize,
                  dimension: _dimension,
                  backgroundColor: cs.primaryContainer,
                  foregroundColor: cs.onPrimaryContainer,
                ),
                errorWidget: (_, __, ___) => _FallbackAvatar(
                  initials: _initials,
                  fontSize: _fontSize,
                  dimension: _dimension,
                  backgroundColor: cs.primaryContainer,
                  foregroundColor: cs.onPrimaryContainer,
                ),
              )
            : _FallbackAvatar(
                initials: _initials,
                fontSize: _fontSize,
                dimension: _dimension,
                backgroundColor: cs.primaryContainer,
                foregroundColor: cs.onPrimaryContainer,
              ),
      ),
    );

    Widget result = showStatusRing
        ? Container(
            padding: EdgeInsets.all(_ringWidth),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ringColor, width: _ringWidth),
            ),
            child: avatar,
          )
        : avatar;

    if (onTap != null) {
      result = InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: result,
      );
    }

    return result;
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({
    required this.initials,
    required this.fontSize,
    required this.dimension,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String initials;
  final double fontSize;
  final double dimension;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
          height: 1,
        ),
      ),
    );
  }
}
