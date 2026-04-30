import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:states_app/core/global/constants/app_colors.dart';
import 'package:states_app/core/global/style/style.dart';

class ThemeApp {
  ThemeApp._();

  static ThemeData get light => _build(colorScheme: _lightColorScheme);

  static ThemeData get dark => _build(colorScheme: _darkColorScheme);

  static final ColorScheme _lightColorScheme =
      ColorScheme.light(
        
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
      ).copyWith(
        outline: AppColors.divider,
        surfaceTint: AppColors.primary,
        surfaceContainerHighest: AppColors.surface,
      );

  static final ColorScheme _darkColorScheme =
      ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnPrimary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        error: AppColors.danger,
      ).copyWith(
        outline: AppColors.darkDivider,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        surfaceTint: AppColors.darkPrimary,
      );

  static ThemeData _build({required ColorScheme colorScheme}) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final typography = AppTypography.textTheme(colorScheme);

    return ThemeData(
      navigationBarTheme: NavigationBarThemeData(backgroundColor: colorScheme.surface),
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      scaffoldBackgroundColor: isDark
          ? colorScheme.surface
          : AppColors.background,
      canvasColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textTheme: typography,
      primaryTextTheme: typography,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        actionsIconTheme: IconThemeData(color: colorScheme.onPrimary),
        toolbarTextStyle: typography.titleLarge,
        titleTextStyle: typography.titleLarge,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withOpacity(0.4),
          disabledForegroundColor: colorScheme.onPrimary.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: typography.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: typography.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: typography.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.7),
        showUnselectedLabels: true,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        elevation: 6,
        color: colorScheme.surface,
        shadowColor: AppColors.gradientEnd.withOpacity(0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surface,
        contentTextStyle: typography.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: colorScheme.outline),
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primary,
        labelStyle: typography.labelLarge,
        secondaryLabelStyle: typography.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        secondarySelectedColor: colorScheme.primaryContainer,
        brightness: colorScheme.brightness,
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        titleTextStyle: typography.titleLarge,
        contentTextStyle: typography.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outline, thickness: 1),
    );
  }
}

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(ColorScheme colorScheme) {
    final base = colorScheme.brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final textTheme = base.apply(fontFamily: Styles.fontFamily);

    final themed = textTheme.copyWith(
      headlineLarge: _override(
        textTheme.headlineLarge,
        colorScheme,
        weight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      titleLarge: _override(
        textTheme.titleLarge,
        colorScheme,
        weight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      bodyMedium: _override(
        textTheme.bodyMedium,
        colorScheme,
        weight: FontWeight.w400,
      ),
      bodySmall: _override(textTheme.bodySmall, colorScheme),
      labelLarge: _override(
        textTheme.labelLarge,
        colorScheme,
        weight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );

    return themed.apply(
      fontFamily: Styles.fontFamily,
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
  }

  static TextStyle _override(
    TextStyle? style,
    ColorScheme scheme, {
    FontWeight? weight,
    double? letterSpacing,
  }) {
    final fallback = FontWeight.w400;

    return (style ?? const TextStyle()).copyWith(
      fontFamily: Styles.fontFamily,
      fontWeight: weight ?? style?.fontWeight ?? fallback,
      letterSpacing: letterSpacing ?? style?.letterSpacing,
      color: style?.color ?? scheme.onSurface,
    );
  }
}
