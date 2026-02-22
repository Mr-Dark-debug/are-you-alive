import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/widgets.dart';
import '../../services/local_storage_service.dart';

/// Onboarding state provider
final onboardingPageProvider = StateProvider<int>((ref) => 0);

/// Onboarding data provider
final onboardingDataProvider = StateProvider<OnboardingData>((ref) {
  return OnboardingData();
});

/// Onboarding data model
class OnboardingData {
  String name = '';
  String phone = '';
  String gender = '';
  DateTime? dateOfBirth;
  String bloodGroup = 'Unknown';
  String allergies = '';
  String medications = '';
  String conditions = '';
  int checkIntervalHours = 24;
  int gracePeriodSeconds = 15;
  bool powerButtonSosEnabled = false;
  bool walkWithMeEnabled = false;
  bool fakeCallEnabled = false;
  bool discreetModeEnabled = false;
  bool locationPermissionGranted = false;
  bool notificationPermissionGranted = false;
  bool overlayPermissionGranted = false;
}

/// Main onboarding screen with PageView
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final int _totalPages = 8;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final currentPage = ref.read(onboardingPageProvider);
    if (currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: AppDesignTokens.durationNormal,
        curve: Curves.easeInOut,
      );
      ref.read(onboardingPageProvider.notifier).state = currentPage + 1;
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    final currentPage = ref.read(onboardingPageProvider);
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: AppDesignTokens.durationNormal,
        curve: Curves.easeInOut,
      );
      ref.read(onboardingPageProvider.notifier).state = currentPage - 1;
    }
  }

  void _completeOnboarding() {
    ref.read(localStorageServiceProvider).setHasSeenOnboarding(true);
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingPageProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(currentPage),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  ref.read(onboardingPageProvider.notifier).state = index;
                },
                children: [
                  _WelcomeStep(onNext: _nextPage),
                  _ProfileStep(onNext: _nextPage, onBack: _previousPage),
                  _MedicalStep(onNext: _nextPage, onBack: _previousPage),
                  _SafetyStep(onNext: _nextPage, onBack: _previousPage),
                  _EnhancedSafetyStep(onNext: _nextPage, onBack: _previousPage),
                  _ContactsStep(onNext: _nextPage, onBack: _previousPage),
                  _PermissionsStep(onNext: _nextPage, onBack: _previousPage),
                  _CompletionStep(onComplete: _completeOnboarding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentPage) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing16),
      child: Row(
        children: List.generate(_totalPages, (index) {
          final isActive = index <= currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.grey200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Step 1: Welcome
class _WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;

  const _WelcomeStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation
          Builder(
            builder: (context) {
              final widget = Lottie.network(
                AppConstants.heartPulseAnimationUrl,
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: AppColors.calmBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 80,
                    color: AppColors.calmColor,
                  ),
                ),
              );
              return Animate(child: widget).fadeIn(duration: 600.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 600.ms,
                  );
            },
          ),

          const SizedBox(height: AppDesignTokens.spacing40),

          // Title
          Text(
            'Peace of mind for you,\nrelief for your family.',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLarge(),
          ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(
                begin: 0.3,
                duration: 600.ms,
              ),

          const SizedBox(height: AppDesignTokens.spacing16),

          // Subtitle
          Text(
            'We check in so you don\'t have to worry.\nYour safety is our priority.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge(color: AppColors.grey500),
          ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

          const SizedBox(height: AppDesignTokens.spacing40),

          // Get Started button
          PrimaryButton(
            text: 'Get Started',
            onPressed: onNext,
            icon: Icons.arrow_forward,
          ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
        ],
      ),
    );
  }
}

/// Step 2: Profile Information
class _ProfileStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _ProfileStep({required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);

    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Basic Profile',
            style: AppTextStyles.headlineSmall(),
          ),
          const SizedBox(height: AppDesignTokens.spacing8),
          Text(
            'Let\'s get to know you better.',
            style: AppTextStyles.bodyMedium(color: AppColors.grey500),
          ),
          const SizedBox(height: AppDesignTokens.spacing32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    initialValue: data.name,
                    onChanged: (value) {
                      final newData = data..name = value;
                      ref.read(onboardingDataProvider.notifier).state =
                          OnboardingData();
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    initialValue: data.phone,
                    onChanged: (value) {
                      final newData = data..phone = value;
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc_outlined),
                    ),
                    initialValue: data.gender.isEmpty ? null : data.gender,
                    items: ['Male', 'Female', 'Non-Binary', 'Prefer not to say']
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final newData = data..gender = value;
                        ref.read(onboardingDataProvider.notifier).state =
                            newData;
                      }
                    },
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.cake_outlined),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 18)),
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        final newData = data..dateOfBirth = date;
                        ref.read(onboardingDataProvider.notifier).state =
                            newData;
                      }
                    },
                    controller: TextEditingController(
                      text: data.dateOfBirth != null
                          ? '${data.dateOfBirth!.day}/${data.dateOfBirth!.month}/${data.dateOfBirth!.year}'
                          : '',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacing16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Back',
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: AppDesignTokens.spacing16),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Next',
                  onPressed: data.name.isNotEmpty && data.gender.isNotEmpty
                      ? onNext
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Step 3: Medical Information
class _MedicalStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _MedicalStep({required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);

    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Medical Information',
            style: AppTextStyles.headlineSmall(),
          ),
          const SizedBox(height: AppDesignTokens.spacing8),
          Text(
            'This helps first responders in case of emergency.',
            style: AppTextStyles.bodyMedium(color: AppColors.grey500),
          ),
          const SizedBox(height: AppDesignTokens.spacing32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Blood Group',
                      prefixIcon: Icon(Icons.bloodtype_outlined),
                    ),
                    initialValue: data.bloodGroup,
                    items: [
                      'A+',
                      'A-',
                      'B+',
                      'B-',
                      'AB+',
                      'AB-',
                      'O+',
                      'O-',
                      'Unknown'
                    ]
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final newData = data..bloodGroup = value;
                        ref.read(onboardingDataProvider.notifier).state =
                            newData;
                      }
                    },
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Allergies',
                      prefixIcon: Icon(Icons.warning_amber_outlined),
                      hintText: 'e.g., Peanuts, Penicillin',
                    ),
                    initialValue: data.allergies,
                    onChanged: (value) {
                      final newData = data..allergies = value;
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Current Medications',
                      prefixIcon: Icon(Icons.medication_outlined),
                      hintText: 'e.g., Insulin, Aspirin',
                    ),
                    initialValue: data.medications,
                    onChanged: (value) {
                      final newData = data..medications = value;
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Medical Conditions',
                      prefixIcon: Icon(Icons.health_and_safety_outlined),
                      hintText: 'e.g., Diabetes, Heart Condition',
                    ),
                    initialValue: data.conditions,
                    onChanged: (value) {
                      final newData = data..conditions = value;
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacing16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Back',
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: AppDesignTokens.spacing16),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Next',
                  onPressed: onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Step 4: Safety Settings
class _SafetyStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _SafetyStep({required this.onNext, required this.onBack});

  @override
  ConsumerState<_SafetyStep> createState() => _SafetyStepState();
}

class _SafetyStepState extends ConsumerState<_SafetyStep> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingDataProvider);

    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Safety Settings',
            style: AppTextStyles.headlineSmall(),
          ),
          const SizedBox(height: AppDesignTokens.spacing8),
          Text(
            'Configure your check-in schedule and grace period.',
            style: AppTextStyles.bodyMedium(color: AppColors.grey500),
          ),
          const SizedBox(height: AppDesignTokens.spacing32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Check-in frequency
                  Text(
                    'Check-in Frequency',
                    style: AppTextStyles.titleSmall(),
                  ),
                  const SizedBox(height: AppDesignTokens.spacing8),
                  Text(
                    'How often should we check in on you?',
                    style: AppTextStyles.bodySmall(color: AppColors.grey500),
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  Slider(
                    value: data.checkIntervalHours.toDouble(),
                    min: 12,
                    max: 72,
                    divisions: 5,
                    label: '${data.checkIntervalHours} hours',
                    onChanged: (value) {
                      final newData = data..checkIntervalHours = value.toInt();
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('12h', style: AppTextStyles.bodySmall()),
                      Text(
                        '${data.checkIntervalHours} hours',
                        style: AppTextStyles.titleSmall(
                          color: AppColors.primary,
                        ),
                      ),
                      Text('72h', style: AppTextStyles.bodySmall()),
                    ],
                  ),

                  const SizedBox(height: AppDesignTokens.spacing32),

                  // Grace period
                  Text(
                    'Grace Period',
                    style: AppTextStyles.titleSmall(),
                  ),
                  const SizedBox(height: AppDesignTokens.spacing8),
                  Text(
                    'How long to wait before alerting contacts?',
                    style: AppTextStyles.bodySmall(color: AppColors.grey500),
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  Slider(
                    value: data.gracePeriodSeconds.toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 11,
                    label: '${data.gracePeriodSeconds}s',
                    onChanged: (value) {
                      final newData = data..gracePeriodSeconds = value.toInt();
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5s', style: AppTextStyles.bodySmall()),
                      Text(
                        '${data.gracePeriodSeconds} seconds',
                        style: AppTextStyles.titleSmall(
                          color: AppColors.primary,
                        ),
                      ),
                      Text('60s', style: AppTextStyles.bodySmall()),
                    ],
                  ),

                  const SizedBox(height: AppDesignTokens.spacing32),

                  // Power Button SOS
                  SwitchListTile(
                    title: const Text('Power Button SOS'),
                    subtitle: const Text(
                      'Press power button 3 times to trigger alert (Android only)',
                    ),
                    value: data.powerButtonSosEnabled,
                    onChanged: (value) {
                      final newData = data..powerButtonSosEnabled = value;
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacing16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Back',
                  onPressed: widget.onBack,
                ),
              ),
              const SizedBox(width: AppDesignTokens.spacing16),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Next',
                  onPressed: widget.onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Step 5: Enhanced Safety (for females)
class _EnhancedSafetyStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _EnhancedSafetyStep({
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);

    // Only show this step for females
    final isFemale = data.gender.toLowerCase() == 'female';
    final showStep = isFemale || data.gender.isEmpty;

    if (!showStep) {
      // Skip this step for non-females
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onNext();
      });
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.security,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDesignTokens.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enhanced Safety',
                      style: AppTextStyles.headlineSmall(),
                    ),
                    Text(
                      'Extra protection features',
                      style: AppTextStyles.bodySmall(color: AppColors.grey500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesignTokens.spacing32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SafetyFeatureTile(
                    icon: Icons.directions_walk,
                    title: 'Walk With Me',
                    subtitle:
                        'Share your live location during walks. Contacts will be alerted if you don\'t arrive on time.',
                    value: data.walkWithMeEnabled,
                    onChanged: (value) {
                      final newData = data..walkWithMeEnabled = value;
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  _SafetyFeatureTile(
                    icon: Icons.phone_in_talk,
                    title: 'Fake Call',
                    subtitle:
                        'Trigger a realistic fake incoming call to escape uncomfortable situations.',
                    value: data.fakeCallEnabled,
                    onChanged: (value) {
                      final newData = data..fakeCallEnabled = value;
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                  ),
                  const SizedBox(height: AppDesignTokens.spacing16),
                  _SafetyFeatureTile(
                    icon: Icons.visibility_off,
                    title: 'Discreet Mode',
                    subtitle:
                        'Change the app icon to look like a calculator or weather app.',
                    value: data.discreetModeEnabled,
                    onChanged: (value) {
                      final newData = data..discreetModeEnabled = value;
                      ref.read(onboardingDataProvider.notifier).state = newData;
                    },
                    badge: const BetaBadge(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacing16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Back',
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: AppDesignTokens.spacing16),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Next',
                  onPressed: onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SafetyFeatureTile extends StatelessWidget {
  const _SafetyFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDesignTokens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        border: Border.all(
          color: value ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: value
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.grey200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? AppColors.primary : AppColors.grey500,
            ),
          ),
          const SizedBox(width: AppDesignTokens.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTextStyles.titleSmall()),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      badge!,
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall(color: AppColors.grey500),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

/// Step 6: Emergency Contacts
class _ContactsStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _ContactsStep({
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<_ContactsStep> createState() => _ContactsStepState();
}

class _ContactsStepState extends ConsumerState<_ContactsStep> {
  final List<Map<String, String>> _contacts = [];

  void _addContact() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDesignTokens.radius24),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: AppDesignTokens.spacing24,
          right: AppDesignTokens.spacing24,
          top: AppDesignTokens.spacing24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Emergency Contact',
              style: AppTextStyles.headlineSmall(),
            ),
            const SizedBox(height: AppDesignTokens.spacing24),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: AppDesignTokens.spacing16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppDesignTokens.spacing16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email (optional)',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppDesignTokens.spacing16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Relationship',
                prefixIcon: Icon(Icons.people_outline),
              ),
              items: [
                'Mother',
                'Father',
                'Sister',
                'Brother',
                'Spouse',
                'Friend',
                'Other'
              ].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: AppDesignTokens.spacing24),
            PrimaryButton(
              text: 'Add Contact',
              onPressed: () {
                setState(() {
                  _contacts.add({
                    'name': 'New Contact',
                    'phone': '+1234567890',
                    'relationship': 'Friend',
                  });
                });
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: AppDesignTokens.spacing24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Trusted Contacts',
            style: AppTextStyles.headlineSmall(),
          ),
          const SizedBox(height: AppDesignTokens.spacing8),
          Text(
            'Add people who will be notified in an emergency.',
            style: AppTextStyles.bodyMedium(color: AppColors.grey500),
          ),
          const SizedBox(height: AppDesignTokens.spacing32),
          Expanded(
            child: _contacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contacts_outlined,
                          size: 64,
                          color: AppColors.grey300,
                        ),
                        const SizedBox(height: AppDesignTokens.spacing16),
                        Text(
                          'No contacts added yet',
                          style:
                              AppTextStyles.bodyLarge(color: AppColors.grey500),
                        ),
                        const SizedBox(height: AppDesignTokens.spacing8),
                        Text(
                          'Add at least one emergency contact',
                          style:
                              AppTextStyles.bodySmall(color: AppColors.grey400),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      final contact = _contacts[index];
                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: AppDesignTokens.spacing12,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              contact['name']![0],
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(contact['name']!),
                          subtitle: Text(contact['phone']!),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.criticalColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _contacts.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: AppDesignTokens.spacing16),
          OutlinedButton.icon(
            onPressed: _addContact,
            icon: const Icon(Icons.add),
            label: const Text('Add Contact'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacing16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Back',
                  onPressed: widget.onBack,
                ),
              ),
              const SizedBox(width: AppDesignTokens.spacing16),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Next',
                  onPressed: _contacts.isNotEmpty ? widget.onNext : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Step 7: Permissions
class _PermissionsStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _PermissionsStep({
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<_PermissionsStep> createState() => _PermissionsStepState();
}

class _PermissionsStepState extends ConsumerState<_PermissionsStep> {
  bool _locationGranted = false;
  bool _notificationGranted = false;
  bool _overlayGranted = false;

  Future<void> _requestLocation() async {
    // Would use permission_handler
    setState(() => _locationGranted = true);
  }

  Future<void> _requestNotifications() async {
    // Would use flutter_local_notifications
    setState(() => _notificationGranted = true);
  }

  Future<void> _requestOverlay() async {
    // Would use flutter_overlay_window
    setState(() => _overlayGranted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Permissions',
            style: AppTextStyles.headlineSmall(),
          ),
          const SizedBox(height: AppDesignTokens.spacing8),
          Text(
            'We need a few permissions to keep you safe.',
            style: AppTextStyles.bodyMedium(color: AppColors.grey500),
          ),
          const SizedBox(height: AppDesignTokens.spacing32),
          Expanded(
            child: Column(
              children: [
                _PermissionTile(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  subtitle:
                      'To share your location during emergencies with your contacts.',
                  isGranted: _locationGranted,
                  onTap: _requestLocation,
                ),
                const SizedBox(height: AppDesignTokens.spacing16),
                _PermissionTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle:
                      'To alert you with loud alarms and bypass silent mode.',
                  isGranted: _notificationGranted,
                  onTap: _requestNotifications,
                ),
                const SizedBox(height: AppDesignTokens.spacing16),
                _PermissionTile(
                  icon: Icons.layers_outlined,
                  title: 'Display Over Apps',
                  subtitle:
                      'To show alerts even when your phone is locked (Android).',
                  isGranted: _overlayGranted,
                  onTap: _requestOverlay,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacing16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Back',
                  onPressed: widget.onBack,
                ),
              ),
              const SizedBox(width: AppDesignTokens.spacing16),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Next',
                  onPressed: widget.onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isGranted,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGranted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDesignTokens.spacing16),
      decoration: BoxDecoration(
        color: isGranted
            ? AppColors.calmBackground
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        border: Border.all(
          color: isGranted ? AppColors.calmColor : AppColors.grey200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isGranted
                  ? AppColors.calmColor.withValues(alpha: 0.1)
                  : AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isGranted ? AppColors.calmColor : AppColors.grey500,
            ),
          ),
          const SizedBox(width: AppDesignTokens.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall()),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall(color: AppColors.grey500),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDesignTokens.spacing8),
          if (isGranted)
            const Icon(Icons.check_circle, color: AppColors.calmColor)
          else
            TextButton(
              onPressed: onTap,
              child: const Text('Allow'),
            ),
        ],
      ),
    );
  }
}

/// Step 8: Completion
class _CompletionStep extends StatelessWidget {
  final VoidCallback onComplete;

  const _CompletionStep({required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              final widget = Lottie.network(
                AppConstants.successAnimationUrl,
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: AppColors.calmBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 100,
                    color: AppColors.calmColor,
                  ),
                ),
              );
              return Animate(child: widget).scale(duration: 600.ms);
            },
          ),
          const SizedBox(height: AppDesignTokens.spacing40),
          Text(
            'You\'re All Set!',
            style: AppTextStyles.headlineLarge(),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
          const SizedBox(height: AppDesignTokens.spacing16),
          Text(
            'Remember to check in before your timer runs out.\nYour safety contacts will be notified if you miss a check-in.',
            style: AppTextStyles.bodyLarge(color: AppColors.grey500),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: AppDesignTokens.spacing40),
          PrimaryButton(
            text: 'Go to Dashboard',
            onPressed: onComplete,
            icon: Icons.arrow_forward,
          ).animate().fadeIn(delay: 700.ms),
        ],
      ),
    );
  }
}
