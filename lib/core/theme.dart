import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Design Tokens - 2026 Modern UI/UX
class AppDesignTokens {
  // Spacing Scale (8pt grid system)
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;
  static const double spacing80 = 80.0;

  // Border Radius Scale
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radius28 = 28.0;
  static const double radius32 = 32.0;
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
  static const Duration durationPage = Duration(milliseconds: 400);

  // Animation Curves
  static const Curve curveDefault = Curves.easeInOutCubic;
  static const Curve curveSpring = Curves.elasticOut;
  static const Curve curveDecelerate = Curves.decelerate;

  // Breakpoints
  static const double breakpointSmall = 360.0;
  static const double breakpointMedium = 600.0;
  static const double breakpointLarge = 840.0;

  // Minimum tap target size (accessibility)
  static const double minTapTarget = 48.0;

  // Max content width for tablets
  static const double maxContentWidth = 480.0;
}

/// App Color Palette — Inspired by calm safety + modern wellness UI
class AppColors {
  // Primary: Deep Indigo – Trust, Calm Authority
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color primarySoft = Color(0xFFEEF2FF);

  // Accent: Warm Teal – Balance, Healing
  static const Color accent = Color(0xFF0D9488);
  static const Color accentLight = Color(0xFF5EEAD4);
  static const Color accentSoft = Color(0xFFF0FDFA);

  // Calm State - Emerald Green (Safe, Peaceful)
  static const Color calmColor = Color(0xFF059669);
  static const Color calmLight = Color(0xFF34D399);
  static const Color calmDark = Color(0xFF047857);
  static const Color calmBackground = Color(0xFFECFDF5);
  static const Color calmSoft = Color(0xFFD1FAE5);

  // Warning State - Warm Amber (Attention, soft urgency)
  static const Color warningColor = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFB45309);
  static const Color warningBackground = Color(0xFFFFFBEB);
  static const Color warningSoft = Color(0xFFFEF3C7);

  // Critical State - Deep Red-Orange (Urgent but not terrifying)
  static const Color criticalColor = Color(0xFFDC2626);
  static const Color criticalLight = Color(0xFFF87171);
  static const Color criticalDark = Color(0xFFB91C1C);
  static const Color criticalBackground = Color(0xFFFEF2F2);
  static const Color criticalGradientStart = Color(0xFFEF4444);
  static const Color criticalGradientEnd = Color(0xFF991B1B);

  // Neutral Colors — Slate palette for depth
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

  // Light Theme Surface Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardAlt = Color(0xFFF1F5F9);

  // Dark Theme Surface Colors
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF131927);
  static const Color darkCard = Color(0xFF1C2333);
  static const Color darkCardAlt = Color(0xFF232B3E);

  // Semantic Colors
  static const Color success = calmColor;
  static const Color error = criticalColor;
  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Premium Badge Colors
  static const Color premiumGold = Color(0xFFF59E0B);
  static const Color premiumGoldLight = Color(0xFFFFEDD5);

  // Glassmorphism tints
  static const Color glassTintLight = Color(0x30FFFFFF);
  static const Color glassTintDark = Color(0x20000000);
  static const Color glassBorderLight = Color(0x40FFFFFF);
  static const Color glassBorderDark = Color(0x20FFFFFF);
}

/// Text Styles — Inter for UI, JetBrains Mono for data
class AppTextStyles {
  // Display - Hero text
  static TextStyle displayLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 56,
        fontWeight: weight ?? FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.1,
        color: color,
      );

  static TextStyle displayMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 44,
        fontWeight: weight ?? FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.15,
        color: color,
      );

  static TextStyle displaySmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 36,
        fontWeight: weight ?? FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.2,
        color: color,
      );

  // Headlines
  static TextStyle headlineLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: weight ?? FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.25,
        color: color,
      );

  static TextStyle headlineMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: weight ?? FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.3,
        color: color,
      );

  static TextStyle headlineSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: weight ?? FontWeight.w600,
        height: 1.35,
        color: color,
      );

  // Titles
  static TextStyle titleLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 22,
        fontWeight: weight ?? FontWeight.w600,
        height: 1.35,
        color: color,
      );

  static TextStyle titleMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: weight ?? FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
        color: color,
      );

  static TextStyle titleSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.45,
        color: color,
      );

  // Body
  static TextStyle bodyLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.6,
        color: color,
      );

  static TextStyle bodyMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.55,
        color: color,
      );

  static TextStyle bodySmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.5,
        color: color,
      );

  // Labels
  static TextStyle labelLarge({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.45,
        color: color,
      );

  static TextStyle labelMedium({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: weight ?? FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: color,
      );

  static TextStyle labelSmall({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: weight ?? FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: color,
      );

  // Countdown Timer (Tabular Figures — JetBrains Mono for clarity)
  static TextStyle countdownTimer({Color? color, double? fontSize}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize ?? 120,
        fontWeight: FontWeight.w800,
        fontFeatures: const [FontFeature.tabularFigures()],
        height: 1.0,
        color: color ?? AppColors.white,
      );

  // Overline for section labels
  static TextStyle overline({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 10,
        fontWeight: weight ?? FontWeight.w700,
        letterSpacing: 1.5,
        height: 1.2,
        color: color ?? AppColors.grey400,
      );
}

/// App Theme — Material 3 with custom refinements
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
        onPrimary: AppColors.white,
        secondary: AppColors.accent,
        surface: AppColors.lightSurface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.grey900,
        elevation: AppDesignTokens.elevationNone,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge(
          color: AppColors.grey900,
          weight: FontWeight.w700,
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
          minimumSize: const Size(0, 54),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.grey200, width: 1.5),
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
          minimumSize: const Size(0, 54),
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
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          borderSide: const BorderSide(color: AppColors.grey200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacing20,
          vertical: AppDesignTokens.spacing16,
        ),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.grey400),
        labelStyle: AppTextStyles.bodyMedium(color: AppColors.grey500),
        floatingLabelStyle: AppTextStyles.labelMedium(color: AppColors.primary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: AppDesignTokens.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius20),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey100,
        thickness: 1,
        space: AppDesignTokens.spacing24,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacing20,
          vertical: AppDesignTokens.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        ),
        minVerticalPadding: AppDesignTokens.spacing4,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primarySoft,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall(
              color: AppColors.primary,
              weight: FontWeight.w600,
            );
          }
          return AppTextStyles.labelSmall(color: AppColors.grey400);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.grey400, size: 24);
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDesignTokens.radius28),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius24),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.grey200,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.white;
          return AppColors.grey400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.grey200;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
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
        onPrimary: AppColors.white,
        secondary: AppColors.accentLight,
        surface: AppColors.darkSurface,
        error: AppColors.criticalLight,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.white,
        elevation: AppDesignTokens.elevationNone,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge(
          color: AppColors.white,
          weight: FontWeight.w700,
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
          minimumSize: const Size(0, 54),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: BorderSide(
            color: AppColors.grey700,
            width: 1.5,
          ),
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
          minimumSize: const Size(0, 54),
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
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          borderSide: BorderSide(
            color: AppColors.grey700.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          borderSide: const BorderSide(color: AppColors.criticalLight),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacing20,
          vertical: AppDesignTokens.spacing16,
        ),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.grey500),
        labelStyle: AppTextStyles.bodyMedium(color: AppColors.grey400),
        floatingLabelStyle:
            AppTextStyles.labelMedium(color: AppColors.primaryLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: AppDesignTokens.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius20),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.grey800,
        thickness: 1,
        space: AppDesignTokens.spacing24,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacing20,
          vertical: AppDesignTokens.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        ),
        minVerticalPadding: AppDesignTokens.spacing4,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall(
              color: AppColors.primaryLight,
              weight: FontWeight.w600,
            );
          }
          return AppTextStyles.labelSmall(color: AppColors.grey600);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryLight, size: 24);
          }
          return const IconThemeData(color: AppColors.grey600, size: 24);
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDesignTokens.radius28),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radius24),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryLight,
        inactiveTrackColor: AppColors.grey700,
        thumbColor: AppColors.primaryLight,
        overlayColor: AppColors.primaryLight.withValues(alpha: 0.12),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.white;
          return AppColors.grey500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.grey700;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}

/// Glassmorphism Decoration Helpers
class GlassmorphismDecoration {
  static BoxDecoration glass({
    Color? tintColor,
    double opacity = 0.08,
    double blur = 20,
    double radius = 24,
  }) {
    return BoxDecoration(
      color: (tintColor ?? AppColors.white).withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: (tintColor ?? AppColors.white).withValues(alpha: 0.15),
        width: 1,
      ),
    );
  }

  static BoxDecoration criticalAlert() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
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
      borderRadius: BorderRadius.circular(AppDesignTokens.radius20),
      border: Border.all(
        color: isDark
            ? AppColors.grey800.withValues(alpha: 0.5)
            : AppColors.grey200.withValues(alpha: 0.7),
        width: 1,
      ),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: AppColors.grey400.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
    );
  }

  static BoxDecoration softElevated(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      borderRadius: BorderRadius.circular(AppDesignTokens.radius20),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? AppColors.black.withValues(alpha: 0.3)
              : AppColors.grey300.withValues(alpha: 0.3),
          blurRadius: 32,
          offset: const Offset(0, 12),
          spreadRadius: -4,
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

  String get label {
    switch (this) {
      case SafetyStatus.calm:
        return 'Safe';
      case SafetyStatus.warning:
        return 'Attention';
      case SafetyStatus.critical:
        return 'Critical';
    }
  }
}
