import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../services/local_storage_service.dart';

final onboardingPageProvider = StateProvider<int>((ref) => 0);

class OnboardingData {
  String name = '';
  String phone = '';
  String gender = '';
  DateTime? dateOfBirth;
  int checkIntervalHours = 24;
  int gracePeriodSeconds = 15;
}

final onboardingDataProvider =
    StateProvider<OnboardingData>((ref) => OnboardingData());

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  static const _totalPages = 4;

  void _nextPage() {
    final currentPage = ref.read(onboardingPageProvider);
    if (currentPage < _totalPages - 1) {
      _pageController.nextPage(
          duration: AppDesignTokens.durationPage, curve: Curves.easeInOutCubic);
      ref.read(onboardingPageProvider.notifier).state = currentPage + 1;
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    final currentPage = ref.read(onboardingPageProvider);
    if (currentPage > 0) {
      _pageController.previousPage(
          duration: AppDesignTokens.durationPage, curve: Curves.easeInOutCubic);
      ref.read(onboardingPageProvider.notifier).state = currentPage - 1;
    }
  }

  void _completeOnboarding() {
    ref.read(localStorageServiceProvider).setHasSeenOnboarding(true);
    context.go('/auth');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingPageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgress(currentPage, isDark),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) =>
                    ref.read(onboardingPageProvider.notifier).state = i,
                children: [
                  _WelcomeStep(onNext: _nextPage),
                  _ProfileStep(onNext: _nextPage, onBack: _previousPage),
                  _SafetyStep(onNext: _nextPage, onBack: _previousPage),
                  _CompletionStep(onComplete: _completeOnboarding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(int currentPage, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: List.generate(_totalPages, (i) {
          final isActive = i <= currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : (isDark ? AppColors.grey800 : AppColors.grey200),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// STEP 1 — WELCOME
// ═══════════════════════════════════════════════════════════════════
class _WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomeStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Big smiley (like reference)
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.primaryDark.withValues(alpha: 0.2)
                      ]
                    : [const Color(0xFFFCE7F3), const Color(0xFFFDF2F8)],
              ),
              shape: BoxShape.circle,
            ),
            child:
                const Center(child: Text('💚', style: TextStyle(fontSize: 64))),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.6, 0.6), curve: Curves.easeOutBack),

          const SizedBox(height: 40),

          Text('Peace of mind\nfor you and yours.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge(
                      color: isDark ? AppColors.white : AppColors.grey900))
              .animate()
              .fadeIn(delay: 300.ms),

          const SizedBox(height: 14),

          Text('We check in so you don\'t have to worry.\nYour safety is our priority.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge(color: AppColors.grey500))
              .animate()
              .fadeIn(delay: 500.ms),

          const SizedBox(height: 48),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onNext,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Get Started'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 700.ms),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// STEP 2 — PROFILE (with working DOB picker)
// ═══════════════════════════════════════════════════════════════════
class _ProfileStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _ProfileStep({required this.onNext, required this.onBack});

  @override
  ConsumerState<_ProfileStep> createState() => _ProfileStepState();
}

class _ProfileStepState extends ConsumerState<_ProfileStep> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingDataProvider);
    _nameController.text = data.name;
    _phoneController.text = data.phone;
    _selectedGender = data.gender.isEmpty ? null : data.gender;
    if (data.dateOfBirth != null) {
      _dobController.text = DateFormat('MMM d, yyyy').format(data.dateOfBirth!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDOB() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'SELECT DATE OF BIRTH',
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: Theme.of(ctx).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: AppColors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _dobController.text = DateFormat('MMM d, yyyy').format(picked);
      });
      final data = ref.read(onboardingDataProvider);
      data.dateOfBirth = picked;
      ref.read(onboardingDataProvider.notifier).state = data;
    }
  }

  void _save() {
    final data = ref.read(onboardingDataProvider);
    data.name = _nameController.text;
    data.phone = _phoneController.text;
    data.gender = _selectedGender ?? '';
    ref.read(onboardingDataProvider.notifier).state = data;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Your Profile',
              style: AppTextStyles.headlineSmall(
                  color: isDark ? AppColors.white : AppColors.grey900)),
          const SizedBox(height: 6),
          Text('Let\'s get to know you.',
              style: AppTextStyles.bodyMedium(color: AppColors.grey500)),
          const SizedBox(height: 28),

          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined, size: 20),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // ── DOB PICKER (FIXED!) ──
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDOB,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.cake_outlined, size: 20),
                    suffixIcon: Icon(Icons.calendar_today, size: 18),
                  ),
                ),
                const SizedBox(height: 16),

                // Gender dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc_outlined, size: 20),
                  ),
                  items: ['Male', 'Female', 'Non-Binary', 'Prefer not to say']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGender = v),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(children: [
            OutlinedButton(
                onPressed: widget.onBack,
                child: const Icon(Icons.arrow_back_rounded, size: 20)),
            const SizedBox(width: 12),
            Expanded(
                child: SizedBox(
              height: 54,
              child: ElevatedButton(
                  onPressed: _save, child: const Text('Continue')),
            )),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// STEP 3 — SAFETY SETTINGS
// ═══════════════════════════════════════════════════════════════════
class _SafetyStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _SafetyStep({required this.onNext, required this.onBack});

  @override
  ConsumerState<_SafetyStep> createState() => _SafetyStepState();
}

class _SafetyStepState extends ConsumerState<_SafetyStep> {
  int _selectedInterval = 24;
  int _selectedGrace = 15;

  final _intervalOptions = [12, 24, 48, 72];
  final _graceOptions = [5, 10, 15, 30, 60];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Safety Settings',
              style: AppTextStyles.headlineSmall(
                  color: isDark ? AppColors.white : AppColors.grey900)),
          const SizedBox(height: 6),
          Text('Configure how often we check on you.',
              style: AppTextStyles.bodyMedium(color: AppColors.grey500)),
          const SizedBox(height: 28),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CHECK-IN FREQUENCY',
                        style:
                            AppTextStyles.overline(color: AppColors.grey400)),
                    const SizedBox(height: 12),
                    Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _intervalOptions.map((h) {
                          final label = h >= 24
                              ? '${h ~/ 24} day${h > 24 ? 's' : ''}'
                              : '$h hrs';
                          return _SelectChip(
                            label: label,
                            isSelected: _selectedInterval == h,
                            onTap: () => setState(() => _selectedInterval = h),
                          );
                        }).toList()),
                    const SizedBox(height: 32),
                    Text('GRACE PERIOD',
                        style:
                            AppTextStyles.overline(color: AppColors.grey400)),
                    const SizedBox(height: 6),
                    Text('How long before we alert your contacts.',
                        style:
                            AppTextStyles.bodySmall(color: AppColors.grey500)),
                    const SizedBox(height: 12),
                    Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _graceOptions.map((s) {
                          final label = s >= 60 ? '${s ~/ 60} min' : '$s sec';
                          return _SelectChip(
                            label: label,
                            isSelected: _selectedGrace == s,
                            onTap: () => setState(() => _selectedGrace = s),
                          );
                        }).toList()),
                  ]),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            OutlinedButton(
                onPressed: widget.onBack,
                child: const Icon(Icons.arrow_back_rounded, size: 20)),
            const SizedBox(width: 12),
            Expanded(
                child: SizedBox(
              height: 54,
              child: ElevatedButton(
                  onPressed: () {
                    final data = ref.read(onboardingDataProvider);
                    data.checkIntervalHours = _selectedInterval;
                    data.gracePeriodSeconds = _selectedGrace;
                    ref.read(onboardingDataProvider.notifier).state = data;
                    widget.onNext();
                  },
                  child: const Text('Continue')),
            )),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// STEP 4 — COMPLETION
// ═══════════════════════════════════════════════════════════════════
class _CompletionStep extends StatelessWidget {
  final VoidCallback onComplete;
  const _CompletionStep({required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.calmBackground,
              shape: BoxShape.circle,
            ),
            child:
                const Center(child: Text('✅', style: TextStyle(fontSize: 56))),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),
          const SizedBox(height: 40),
          Text('You\'re all set!',
                  style: AppTextStyles.headlineLarge(
                      color: isDark ? AppColors.white : AppColors.grey900))
              .animate()
              .fadeIn(delay: 300.ms),
          const SizedBox(height: 12),
          Text('Your digital safety net is ready.\nLet\'s keep you safe.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge(color: AppColors.grey500))
              .animate()
              .fadeIn(delay: 500.ms),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onComplete,
              child: const Text('Start Using App'),
            ),
          ).animate().fadeIn(delay: 700.ms),
        ],
      ),
    );
  }
}

// ─── SHARED WIDGETS ────────────────────────────────────────────────

class _SelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _SelectChip(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : AppColors.white),
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? AppColors.grey700 : AppColors.grey200),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3)),
                ]
              : null,
        ),
        child: Text(label,
            style: AppTextStyles.labelMedium(
              color: isSelected
                  ? AppColors.white
                  : (isDark ? AppColors.grey300 : AppColors.grey600),
              weight: FontWeight.w600,
            )),
      ),
    );
  }
}
