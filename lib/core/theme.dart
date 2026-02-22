import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Design Tokens - 2026 Modern UI/UX
class AppDesignTokens {
  // Spacing Scale (8pt grid system)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Border Radius Scale
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radius28 = 28.0;
  static const double radiusFull = 100.0;

  // Elevation Scale
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationHighest = 16.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);

  // Breakpoints
  static const double breakpointSmall = 360.0;
  static const double breakpointMedium = 600.0;
  static const double breakpointLarge = 840.0;

  // Minimum tap target size (accessibility)
  static const double minTapTarget = 48.0;
}

/// App Color Palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo - Calm, trustworthy
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Calm State - Green/Teal (Safe)
  static const Color calmColor = Color(0xFF10B981);
  static const Color calmLight = Color(0xFF34D399);
  static const Color calmDark = Color(0xFF059669);
  static const Color calmBackground = Color(0xFFECFDF5);

  // Warning State - Amber/Orange (Attention needed)
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningBackground = Color(0xFFFFFBEB);

  // Critical State - Deep Red (Urgent)
  static const Color criticalColor = Color(0xFFEF4444);
  static const Color criticalLight = Color(0xFFF87171);
  static const Color criticalDark = Color(0xFFDC2626);
  static const Color criticalBackground = Color(0xFFFEF2F2);
  static const Color criticalGradientStart = Color(0xFFEF4444);
  static const Color criticalGradientEnd = Color(0xFFB91C1C);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Light Theme
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Dark Theme
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF252525);

  // Semantic Colors
  static const Color success = calmColor;
  static const Color error = criticalColor;
  static const Color info = Color(0xFF3B82F6);

  // Premium Badge
  static const Color premiumGold = Color(0xFFF59E0B);
  static const Color premiumGoldLight = Color(0xFFFFEDD5);
}

/// Text Styles
class AppTextStyles {
  // Display
  static TextStyle displayLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 57,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: -0.25,
        color: color,
      );

  static TextStyle displayMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 45,
        fontWeight: weight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle displaySmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 36,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: 0.5,
        color: color,
      );

  // Headlines
  static TextStyle headlineLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: weight ?? FontWeight.w600,
        color: color,
      );

  static TextStyle headlineMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: weight ?? FontWeight.w600,
        color: color,
      );

  static TextStyle headlineSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: weight ?? FontWeight.w600,
        color: color,
      );

  // Titles
  static TextStyle titleLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 22,
        fontWeight: weight ?? FontWeight.w500,
        color: color,
      );

  static TextStyle titleMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: weight ?? FontWeight.w500,
        letterSpacing: 0.15,
        color: color,
      );

  static TextStyle titleSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w500,
        letterSpacing: 0.1,
        color: color,
      );

  // Body
  static TextStyle bodyLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: 0.5,
        color: color,
      );

  static TextStyle bodyMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: 0.25,
        color: color,
      );

  static TextStyle bodySmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: 0.4,
        color: color,
      );

  // Labels
  static TextStyle labelLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w500,
        letterSpacing: 0.1,
        color: color,
      );

  static TextStyle labelMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: weight ?? FontWeight.w500,
        letterSpacing: 0.5,
        color: color,
      );

  static TextStyle labelSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: weight ?? FontWeight.w500,
        letterSpacing: 0.5,
        color: color,
      );

  // Countdown Timer (Tabular Figures)
  static TextStyle countdownTimer({Color? color, double? fontSize}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize ?? 120,
        fontWeight: FontWeight.w900,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color ?? AppColors.white,
      );
}

/// App Theme
class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        surface: AppColors.lightSurface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.grey900,
        elevation: AppDesignTokens.elevationNone,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge(
          color: AppColors.grey900,
          weight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: AppDesignTokens.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacing24,
            vertical: AppDesignTokens.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          ),
          textStyle: AppTextStyles.labelLarge(
            color: AppColors.white,
            weight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacing24,
            vertical: AppDesignTokens.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          ),
          textStyle: AppTextStyles.labelLarge(
            color: AppColors.primary,
            weight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacing16,
            vertical: AppDesignTokens.spacing8,
          ),
          textStyle: AppTextStyles.labelLarge(
            color: AppColors.primary,
            weight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacing16,
          vertical: AppDesignTokens.spacing16,
        ),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.grey400),
        labelStyle: AppTextStyles.bodyMedium(color: AppColors.grey600),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: AppDesignTokens.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey200,
        thickness: 1,
        space: AppDesignTokens.spacing24,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacing16,
          vertical: AppDesignTokens.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey400,
        type: BottomNavigationBarType.fixed,
        elevation: AppDesignTokens.elevationNone,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        surface: AppColors.darkSurface,
        error: AppColors.criticalLight,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.white,
        elevation: AppDesignTokens.elevationNone,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge(
          color: AppColors.white,
          weight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.white,
          elevation: AppDesignTokens.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacing24,
            vertical: AppDesignTokens.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          ),
          textStyle: AppTextStyles.labelLarge(
            color: AppColors.white,
            weight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacing24,
            vertical: AppDesignTokens.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          ),
          textStyle: AppTextStyles.labelLarge(
            color: AppColors.primaryLight,
            weight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacing16,
            vertical: AppDesignTokens.spacing8,
          ),
          textStyle: AppTextStyles.labelLarge(
            color: AppColors.primaryLight,
            weight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
          borderSide: const BorderSide(color: AppColors.criticalLight),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacing16,
          vertical: AppDesignTokens.spacing16,
        ),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.grey500),
        labelStyle: AppTextStyles.bodyMedium(color: AppColors.grey400),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: AppDesignTokens.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.grey800,
        thickness: 1,
        space: AppDesignTokens.spacing24,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacing16,
          vertical: AppDesignTokens.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.grey600,
        type: BottomNavigationBarType.fixed,
        elevation: AppDesignTokens.elevationNone,
      ),
    );
  }
}

/// Glassmorphism Decoration
class GlassmorphismDecoration {
  static BoxDecoration glass({
    Color? tintColor,
    double opacity = 0.1,
    double blur = 20,
    double radius = 24,
  }) {
    return BoxDecoration(
      color: (tintColor ?? AppColors.white).withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: (tintColor ?? AppColors.white).withValues(alpha: 0.2),
        width: 1,
      ),
      // Note: backdropFilter needs to be applied via ClipRRect + BackdropFilter
    );
  }

  static BoxDecoration criticalAlert() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.criticalGradientStart,
          AppColors.criticalGradientEnd,
        ],
      ),
    );
  }

  static BoxDecoration safeCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? AppColors.black.withValues(alpha: 0.3)
              : AppColors.grey400.withValues(alpha: 0.15),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

/// Status Colors Helper
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
}
