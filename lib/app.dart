import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'core/theme.dart';
import 'core/router.dart';

class AreYouAliveApp extends ConsumerWidget {
  const AreYouAliveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Are You Alive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.4),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBackground, const Color(0xFF0E1526)]
                : [AppColors.lightBackground, const Color(0xFFF0F4FF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark]),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 32,
                        offset: const Offset(0, 12))
                  ],
                ),
                child: const Icon(Icons.favorite_rounded,
                    color: AppColors.white, size: 48),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1.05, 1.05),
                  duration: 1500.ms,
                  curve: Curves.easeInOut),
              const SizedBox(height: 32),
              Text('Are You Alive',
                      style: AppTextStyles.headlineLarge(
                          color: isDark ? AppColors.white : AppColors.grey900,
                          weight: FontWeight.w800))
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 600.ms),
              const SizedBox(height: 8),
              Text('Your digital safety net',
                      style: AppTextStyles.bodyMedium(color: AppColors.grey400))
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 600.ms),
              const SizedBox(height: 48),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    strokeCap: StrokeCap.round,
                    color: AppColors.primary.withValues(alpha: 0.6)),
              ).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}
