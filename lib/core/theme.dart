import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─── Design Tokens ─────────────────────────────────────────────────
class AppDesignTokens {
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;
  static const double spacing80 = 80;

  static const double radius4 = 4;
  static const double radius8 = 8;
  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radius20 = 20;
  static const double radius24 = 24;
  static const double radius28 = 28;
  static const double radius32 = 32;
  static const double radiusFull = 100;

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);
  static const Duration durationPage = Duration(milliseconds: 400);

  static const double minTapTarget = 48;
  static const double maxContentWidth = 480;

  static const double elevationNone = 0;
  static const double elevationLow = 2;
  static const double elevationMedium = 4;
  static const double elevationHigh = 8;
}

/// ─── Color Palette – Matching reference images ─────────────────────
/// Pastel pink/mint wellness + bold SOS red-orange + dark mode teal
class AppColors {
  // Brand: Soft teal (from reference dark screens)
  static const Color primary = Color(0xFF2DD4A8);
  static const Color primaryDark = Color(0xFF0D9488);
  static const Color primaryLight = Color(0xFF5EEAD4);
  static const Color primarySoft = Color(0xFFECFDF5);

  // Accent: Pastel pink (from reference mood screens)
  static const Color accent = Color(0xFFF9A8D4);
  static const Color accentDark = Color(0xFFEC4899);
  static const Color accentSoft = Color(0xFFFDF2F8);

  // SOS / Critical: Bold red-orange (from reference SOS screens)
  static const Color criticalColor = Color(0xFFEF4444);
  static const Color criticalLight = Color(0xFFF87171);
  static const Color criticalDark = Color(0xFFB91C1C);
  static const Color criticalBackground = Color(0xFFFEF2F2);
  static const Color criticalGradientStart = Color(0xFFEF4444);
  static const Color criticalGradientEnd = Color(0xFF991B1B);

  // SOS badge (bright orange from reference)
  static const Color sosOrange = Color(0xFFEA580C);
  static const Color sosOrangeLight = Color(0xFFFB923C);

  // Calm / Safe
  static const Color calmColor = Color(0xFF10B981);
  static const Color calmLight = Color(0xFF34D399);
  static const Color calmDark = Color(0xFF059669);
  static const Color calmBackground = Color(0xFFECFDF5);
  static const Color calmSoft = Color(0xFFD1FAE5);

  // Warning
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningBackground = Color(0xFFFFFBEB);
  static const Color warningSoft = Color(0xFFFEF3C7);

  // Blue (from reference SOS screen)
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueLight = Color(0xFF93C5FD);
  static const Color blueSoft = Color(0xFFDBEAFE);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);

  // Surfaces
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardAlt = Color(0xFFF1F5F9);

  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF131927);
  static const Color darkCard = Color(0xFF1C2333);
  static const Color darkCardAlt = Color(0xFF232B3E);

  // Semantic
  static const Color success = calmColor;
  static const Color error = criticalColor;
  static const Color info = blue;
  static const Color infoLight = blueSoft;
  static const Color premiumGold = Color(0xFFF59E0B);
  static const Color premiumGoldLight = Color(0xFFFFFBEB);
}

/// ─── Text Styles ───────────────────────────────────────────────────
class AppTextStyles {
  static TextStyle displayLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 56,
          fontWeight: weight ?? FontWeight.w700,
          letterSpacing: -1.5,
          height: 1.1,
          color: color);
  static TextStyle displayMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 44,
          fontWeight: weight ?? FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.15,
          color: color);
  static TextStyle displaySmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 36,
          fontWeight: weight ?? FontWeight.w600,
          letterSpacing: -0.25,
          height: 1.2,
          color: color);
  static TextStyle headlineLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 32,
          fontWeight: weight ?? FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.25,
          color: color);
  static TextStyle headlineMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 28,
          fontWeight: weight ?? FontWeight.w600,
          letterSpacing: -0.25,
          height: 1.3,
          color: color);
  static TextStyle headlineSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 24,
          fontWeight: weight ?? FontWeight.w600,
          height: 1.35,
          color: color);
  static TextStyle titleLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 22,
          fontWeight: weight ?? FontWeight.w600,
          height: 1.35,
          color: color);
  static TextStyle titleMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 16,
          fontWeight: weight ?? FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.5,
          color: color);
  static TextStyle titleSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 14,
          fontWeight: weight ?? FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.45,
          color: color);
  static TextStyle bodyLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 16,
          fontWeight: weight ?? FontWeight.w400,
          letterSpacing: 0.15,
          height: 1.6,
          color: color);
  static TextStyle bodyMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 14,
          fontWeight: weight ?? FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.55,
          color: color);
  static TextStyle bodySmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 12,
          fontWeight: weight ?? FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.5,
          color: color);
  static TextStyle labelLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 14,
          fontWeight: weight ?? FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.45,
          color: color);
  static TextStyle labelMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 12,
          fontWeight: weight ?? FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.4,
          color: color);
  static TextStyle labelSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 11,
          fontWeight: weight ?? FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.4,
          color: color);
  static TextStyle overline({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
          fontSize: 10,
          fontWeight: weight ?? FontWeight.w700,
          letterSpacing: 1.5,
          height: 1.2,
          color: color ?? AppColors.grey400);
  static TextStyle countdownTimer({Color? color, double? fontSize}) =>
      GoogleFonts.jetBrainsMono(
          fontSize: fontSize ?? 120,
          fontWeight: FontWeight.w800,
          fontFeatures: const [FontFeature.tabularFigures()],
          height: 1.0,
          color: color ?? AppColors.white);
}

/// ─── App Theme ─────────────────────────────────────────────────────
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.accent,
        surface: AppColors.lightSurface,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.grey900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge(
            color: AppColors.grey900, weight: FontWeight.w700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull)),
          textStyle: AppTextStyles.labelLarge(weight: FontWeight.w600),
          minimumSize: const Size(0, 54),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.grey900,
          side: const BorderSide(color: AppColors.grey200, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull)),
          textStyle: AppTextStyles.labelLarge(weight: FontWeight.w600),
          minimumSize: const Size(0, 54),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelLarge(weight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
            borderSide: const BorderSide(color: AppColors.grey200, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
            borderSide: const BorderSide(color: AppColors.error)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.grey400),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius24)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall(
                color: AppColors.primary, weight: FontWeight.w600);
          }
          return AppTextStyles.labelSmall(color: AppColors.grey400);
        }),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.grey400, size: 24);
        }),
      ),
      dividerTheme:
          const DividerThemeData(color: AppColors.grey100, thickness: 1),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius24)),
        surfaceTintColor: Colors.transparent,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.white
                : AppColors.grey400),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.grey200),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        onPrimary: AppColors.white,
        secondary: AppColors.accent,
        surface: AppColors.darkSurface,
        error: AppColors.criticalLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge(
            color: AppColors.white, weight: FontWeight.w700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull)),
          textStyle: AppTextStyles.labelLarge(weight: FontWeight.w600),
          minimumSize: const Size(0, 54),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: BorderSide(color: AppColors.grey700, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull)),
          textStyle: AppTextStyles.labelLarge(weight: FontWeight.w600),
          minimumSize: const Size(0, 54),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
            borderSide:
                BorderSide(color: AppColors.grey700.withValues(alpha: 0.5))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
            borderSide:
                const BorderSide(color: AppColors.primaryLight, width: 2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.grey500),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius24)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall(
                color: AppColors.primaryLight, weight: FontWeight.w600);
          }
          return AppTextStyles.labelSmall(color: AppColors.grey600);
        }),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryLight, size: 24);
          }
          return const IconThemeData(color: AppColors.grey600, size: 24);
        }),
      ),
      dividerTheme: DividerThemeData(color: AppColors.grey800, thickness: 1),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.white
                : AppColors.grey500),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.primaryLight
                : AppColors.grey700),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}

/// ─── Safety Status Enum ────────────────────────────────────────────
enum SafetyStatus { calm, warning, critical }

extension SafetyStatusColors on SafetyStatus {
  Color get color {
    switch (this) {
      case SafetyStatus.calm:
        return AppColors.calmColor;
      case SafetyStatus.warning:
        return AppColors.warningColor;
      case SafetyStatus.critical:
        return AppColors.criticalColor;
    }
  }

  Color get lightColor {
    switch (this) {
      case SafetyStatus.calm:
        return AppColors.calmLight;
      case SafetyStatus.warning:
        return AppColors.warningLight;
      case SafetyStatus.critical:
        return AppColors.criticalLight;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case SafetyStatus.calm:
        return AppColors.calmBackground;
      case SafetyStatus.warning:
        return AppColors.warningBackground;
      case SafetyStatus.critical:
        return AppColors.criticalBackground;
    }
  }

  Color get softColor {
    switch (this) {
      case SafetyStatus.calm:
        return AppColors.calmSoft;
      case SafetyStatus.warning:
        return AppColors.warningSoft;
      case SafetyStatus.critical:
        return AppColors.criticalBackground;
    }
  }

  IconData get icon {
    switch (this) {
      case SafetyStatus.calm:
        return Icons.shield_rounded;
      case SafetyStatus.warning:
        return Icons.timer_outlined;
      case SafetyStatus.critical:
        return Icons.warning_rounded;
    }
  }
}

/// Helper decorations
class GlassmorphismDecoration {
  static BoxDecoration safeCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      borderRadius: BorderRadius.circular(AppDesignTokens.radius24),
      border: Border.all(
          color: isDark
              ? AppColors.grey800.withValues(alpha: 0.5)
              : AppColors.grey200.withValues(alpha: 0.7)),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                  color: AppColors.grey400.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8)),
            ],
    );
  }
}
