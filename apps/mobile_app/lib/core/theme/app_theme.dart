import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/typography.dart';
import 'package:mobile_app/core/theme/tokens.dart';

export 'colors.dart';
export 'tokens.dart';
export 'typography.dart';

class AppTheme {
  AppTheme._();

  // ───────────────────── LIGHT ─────────────────────

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: EcoColors.primary,
      brightness: Brightness.light,
      primary: EcoColors.primary,
      onPrimary: EcoColors.onPrimary,
      primaryContainer: EcoColors.primaryContainer,
      onPrimaryContainer: EcoColors.onPrimaryContainer,
      secondary: EcoColors.secondary,
      secondaryContainer: EcoColors.secondaryContainer,
      tertiary: EcoColors.tertiary,
      tertiaryContainer: EcoColors.tertiaryContainer,
      surface: EcoColors.surfaceLight,
      surfaceContainer: EcoColors.surfaceContainerLight,
      onSurface: EcoColors.onSurfaceLight,
      onSurfaceVariant: EcoColors.onSurfaceVariantLight,
      outline: EcoColors.outlineLight,
      outlineVariant: EcoColors.outlineVariantLight,
      error: EcoColors.error,
      errorContainer: EcoColors.errorContainer,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  // ───────────────────── DARK ──────────────────────

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: EcoColors.primary,
      brightness: Brightness.dark,
      primary: EcoColors.primaryLight,
      onPrimary: EcoColors.backgroundDark,
      primaryContainer: EcoColors.onPrimaryContainer,
      onPrimaryContainer: EcoColors.primaryContainer,
      secondary: EcoColors.secondaryLight,
      secondaryContainer: EcoColors.secondaryContainer,
      tertiary: EcoColors.tertiaryLight,
      tertiaryContainer: EcoColors.tertiaryContainer,
      surface: EcoColors.surfaceDark,
      surfaceContainer: EcoColors.surfaceContainerDark,
      onSurface: EcoColors.onSurfaceDark,
      onSurfaceVariant: EcoColors.onSurfaceVariantDark,
      outline: EcoColors.outlineDark,
      outlineVariant: EcoColors.outlineVariantDark,
      error: EcoColors.errorLight,
      errorContainer: EcoColors.errorContainer,
      surfaceTint: EcoColors.surfaceTintDark,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  // ───────────────────── SHARED ────────────────────

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scaffoldBg = isLight ? EcoColors.backgroundLight : EcoColors.backgroundDark;
    final onBg = isLight ? EcoColors.onBackgroundLight : EcoColors.onBackgroundDark;

    final textTheme = _buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: textTheme,

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: onBg,
        elevation: 0,
        scrolledUnderElevation: EcoTokens.elevationXs,
        centerTitle: false,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        titleTextStyle: textTheme.titleLarge,
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: EcoTokens.elevationXs,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size(64, EcoTokens.touchTargetComfortable),
          elevation: EcoTokens.elevationNone,
          padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── Filled Button ──
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, EcoTokens.touchTargetComfortable),
          elevation: EcoTokens.elevationNone,
          padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(64, EcoTokens.touchTargetComfortable),
          side: BorderSide(color: colorScheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, EcoTokens.touchTargetMin),
          padding: const EdgeInsets.symmetric(
            horizontal: EcoTokens.spacing3,
            vertical: EcoTokens.spacing2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── Icon Button ──
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            EcoTokens.touchTargetComfortable,
            EcoTokens.touchTargetComfortable,
          ),
        ),
      ),

      // ── Input Decoration ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? EcoColors.surfaceContainerLight
            : EcoColors.surfaceContainerDark,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: EcoTokens.spacing4,
          vertical: EcoTokens.spacing3,
        ),
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.08),
        labelStyle: textTheme.labelMedium,
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: EcoTokens.spacing3,
          vertical: EcoTokens.spacing1,
        ),
        showCheckmark: false,
      ),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: EcoTokens.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusLg),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        elevation: EcoTokens.elevationLg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(EcoTokens.radiusXl),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant,
        constraints: BoxConstraints(
          maxHeight: MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first,
          ).size.height * 0.9,
        ),
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isLight ? EcoColors.onBackgroundLight : EcoColors.onBackgroundDark,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isLight ? EcoColors.backgroundLight : EcoColors.backgroundDark,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
        ),
        elevation: EcoTokens.elevationMd,
      ),

      // ── Bottom Navigation ──
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        elevation: EcoTokens.elevationSm,
        indicatorColor: colorScheme.primaryContainer,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary, size: EcoTokens.iconSizeMd);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant, size: EcoTokens.iconSizeMd);
        }),
      ),

      // ── ListTile ──
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: EcoTokens.spacing4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
        ),
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // ── Progress Indicator ──
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primaryContainer,
        circularTrackColor: colorScheme.primaryContainer,
      ),

      // ── Floating Action Button ──
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: EcoTokens.elevationMd,
        shape: const CircleBorder(),
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: EcoTypography.displayLarge.copyWith(color: colorScheme.onSurface),
      displayMedium: EcoTypography.displayMedium.copyWith(color: colorScheme.onSurface),
      displaySmall: EcoTypography.displaySmall.copyWith(color: colorScheme.onSurface),
      headlineLarge: EcoTypography.headlineLarge.copyWith(color: colorScheme.onSurface),
      headlineMedium: EcoTypography.headlineMedium.copyWith(color: colorScheme.onSurface),
      headlineSmall: EcoTypography.headlineSmall.copyWith(color: colorScheme.onSurface),
      titleLarge: EcoTypography.titleLarge.copyWith(color: colorScheme.onSurface),
      titleMedium: EcoTypography.titleMedium.copyWith(color: colorScheme.onSurface),
      titleSmall: EcoTypography.titleSmall.copyWith(color: colorScheme.onSurface),
      bodyLarge: EcoTypography.bodyLarge.copyWith(color: colorScheme.onSurface),
      bodyMedium: EcoTypography.bodyMedium.copyWith(color: colorScheme.onSurface),
      bodySmall: EcoTypography.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
      labelLarge: EcoTypography.labelLarge.copyWith(color: colorScheme.onSurface),
      labelMedium: EcoTypography.labelMedium.copyWith(color: colorScheme.onSurfaceVariant),
      labelSmall: EcoTypography.labelSmall.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }
}
