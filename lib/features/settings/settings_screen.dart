import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../services/local_storage_service.dart';

/// Settings Screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _awayModeEnabled = false;
  bool _powerButtonSosEnabled = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final localStorage = ref.read(localStorageServiceProvider);
    setState(() {
      _awayModeEnabled = localStorage.getAwayModeEnabled();
      _notificationsEnabled = localStorage.getNotificationEnabled();
    });
  }

  Future<void> _setAwayMode(bool value) async {
    if (value) {
      // Show date picker for away mode end date
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
        helpText: 'When will you return?',
      );

      if (selectedDate != null) {
        final localStorage = ref.read(localStorageServiceProvider);
        await localStorage.setAwayModeEnabled(true);
        await localStorage.setAwayModeUntil(selectedDate);

        setState(() {
          _awayModeEnabled = true;
        });

        if (mounted) {
          SnackBarHelper.showSuccess(
            context,
            'Away mode enabled until ${selectedDate.day}/${selectedDate.month}',
          );
        }
      }
    } else {
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.setAwayModeEnabled(false);
      await localStorage.setAwayModeUntil(null);

      setState(() {
        _awayModeEnabled = false;
      });

      if (mounted) {
        SnackBarHelper.showInfo(context, 'Away mode disabled');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Account Section
          const SectionHeader(title: 'Account Settings'),
          NavigationTile(
            leading: const Icon(Icons.person_outline),
            title: 'Profile Details',
            subtitle: 'Name, phone, and personal info',
            onTap: () => context.push('/settings/profile'),
          ),
          NavigationTile(
            leading: const Icon(Icons.health_and_safety_outlined),
            title: 'Medical Information',
            subtitle: 'Blood type, allergies, medications',
            onTap: () => context.push('/settings/medical'),
          ),
          NavigationTile(
            leading: const Icon(Icons.contacts_outlined),
            title: 'Emergency Contacts',
            subtitle: 'Manage your trusted contacts',
            onTap: () => context.push('/contacts'),
          ),

          const SectionDivider(),

          // Safety Section
          const SectionHeader(title: 'Safety Features'),
          NavigationTile(
            leading: const Icon(Icons.timer_outlined),
            title: 'Check-in Preferences',
            subtitle: 'Frequency and grace period',
            onTap: () => context.push('/settings/safety'),
          ),
          ToggleTile(
            leading: const Icon(Icons.power_settings_new_outlined),
            title: 'Power Button SOS',
            subtitle: 'Press 3 times to trigger alert (Android)',
            value: _powerButtonSosEnabled,
            onChanged: (value) {
              setState(() {
                _powerButtonSosEnabled = value;
              });
            },
          ),

          const SectionDivider(),

          // Notifications Section
          const SectionHeader(title: 'Notifications'),
          ToggleTile(
            leading: const Icon(Icons.notifications_outlined),
            title: 'Push Notifications',
            subtitle: 'Check-in reminders and alerts',
            value: _notificationsEnabled,
            onChanged: (value) async {
              final localStorage = ref.read(localStorageServiceProvider);
              await localStorage.setNotificationEnabled(value);
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          PremiumTile(
            leading: const Icon(Icons.sms_outlined),
            title: 'SMS Alerts',
            subtitle: 'Coming Soon',
            onTap: () {
              SnackBarHelper.showPremium(context, 'SMS Alerts');
            },
          ),

          const SectionDivider(),

          // Travel Section
          const SectionHeader(title: 'Travel & Pauses'),
          ToggleTile(
            leading: Icon(
              Icons.flight_takeoff_outlined,
              color: _awayModeEnabled ? AppColors.warningColor : null,
            ),
            title: 'Away Mode',
            subtitle: _awayModeEnabled
                ? 'Check-ins paused'
                : 'Pause alerts while traveling',
            value: _awayModeEnabled,
            onChanged: _setAwayMode,
          ),

          const SectionDivider(),

          // Enhanced Safety (conditional)
          const SectionHeader(title: 'Enhanced Safety'),
          NavigationTile(
            leading: const Icon(Icons.directions_walk_outlined),
            title: 'Walk With Me',
            subtitle: 'Live location sharing',
            onTap: () => context.push('/walk-with-me'),
          ),
          NavigationTile(
            leading: const Icon(Icons.phone_in_talk_outlined),
            title: 'Fake Call',
            subtitle: 'Trigger a realistic fake call',
            onTap: () => context.push('/fake-call'),
          ),
          ToggleTile(
            leading: const Icon(Icons.visibility_off_outlined),
            title: 'Discreet Mode',
            subtitle: 'Change app appearance',
            value: false,
            onChanged: null,
            showPremiumBadge: true,
            onPremiumTap: () {
              SnackBarHelper.showPremium(context, 'Discreet Mode');
            },
          ),

          const SectionDivider(),

          // Support Section
          const SectionHeader(title: 'Support'),
          NavigationTile(
            leading: const Icon(Icons.help_outline),
            title: 'Help Center',
            onTap: () {},
          ),
          NavigationTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: 'Privacy Policy',
            onTap: () {},
          ),
          NavigationTile(
            leading: const Icon(Icons.description_outlined),
            title: 'Terms of Service',
            onTap: () {},
          ),
          NavigationTile(
            leading: const Icon(Icons.info_outline),
            title: 'About',
            subtitle: 'Version 1.0.0',
            showChevron: false,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Are You Alive',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 Are You Alive',
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'A digital safety net for you and your loved ones.',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppDesignTokens.spacing24),

          // Sign Out Button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignTokens.spacing24,
            ),
            child: SecondaryButton(
              text: 'Sign Out',
              icon: Icons.logout,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text(
                      'Are you sure you want to sign out?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.criticalColor,
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.go('/auth');
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppDesignTokens.spacing40),
        ],
      ),
    );
  }
}

/// Profile Settings Screen
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _phoneController = TextEditingController(text: '+1234567890');
  String _selectedGender = 'Male';
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        actions: [
          TextButton(
            onPressed: () {
              // Save changes
              Navigator.pop(context);
              SnackBarHelper.showSuccess(context, 'Profile updated!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.spacing24),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDesignTokens.spacing32),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: AppDesignTokens.spacing16),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),

            const SizedBox(height: AppDesignTokens.spacing16),

            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                prefixIcon: Icon(Icons.wc_outlined),
              ),
              items: ['Male', 'Female', 'Non-Binary', 'Prefer not to say']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedGender = value;
                  });
                }
              },
            ),

            const SizedBox(height: AppDesignTokens.spacing16),

            ListTile(
              leading: const Icon(Icons.cake_outlined),
              title: const Text('Date of Birth'),
              subtitle: Text(
                _dateOfBirth != null
                    ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                    : 'Not set',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dateOfBirth ??
                      DateTime.now().subtract(
                        const Duration(days: 365 * 25),
                      ),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _dateOfBirth = date;
                  });
                }
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

/// Medical Info Settings Screen
class MedicalSettingsScreen extends ConsumerStatefulWidget {
  const MedicalSettingsScreen({super.key});

  @override
  ConsumerState<MedicalSettingsScreen> createState() =>
      _MedicalSettingsScreenState();
}

class _MedicalSettingsScreenState extends ConsumerState<MedicalSettingsScreen> {
  String _selectedBloodGroup = 'Unknown';
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _conditionsController = TextEditingController();

  @override
  void dispose() {
    _allergiesController.dispose();
    _medicationsController.dispose();
    _conditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Information'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SnackBarHelper.showSuccess(context, 'Medical info saved!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.spacing24),
        child: Column(
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(AppDesignTokens.spacing16),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
                border:
                    Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This information will be shared with emergency contacts during an alert.',
                      style: AppTextStyles.bodySmall(color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDesignTokens.spacing24),

            DropdownButtonFormField<String>(
              initialValue: _selectedBloodGroup,
              decoration: const InputDecoration(
                labelText: 'Blood Group',
                prefixIcon: Icon(Icons.bloodtype_outlined),
              ),
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
              ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBloodGroup = value;
                  });
                }
              },
            ),

            const SizedBox(height: AppDesignTokens.spacing16),

            TextField(
              controller: _allergiesController,
              decoration: const InputDecoration(
                labelText: 'Allergies',
                prefixIcon: Icon(Icons.warning_amber_outlined),
                hintText: 'e.g., Peanuts, Penicillin',
              ),
              maxLines: 2,
            ),

            const SizedBox(height: AppDesignTokens.spacing16),

            TextField(
              controller: _medicationsController,
              decoration: const InputDecoration(
                labelText: 'Current Medications',
                prefixIcon: Icon(Icons.medication_outlined),
                hintText: 'e.g., Insulin, Aspirin',
              ),
              maxLines: 2,
            ),

            const SizedBox(height: AppDesignTokens.spacing16),

            TextField(
              controller: _conditionsController,
              decoration: const InputDecoration(
                labelText: 'Medical Conditions',
                prefixIcon: Icon(Icons.health_and_safety_outlined),
                hintText: 'e.g., Diabetes, Heart Condition',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// Safety Settings Screen
class SafetySettingsScreen extends ConsumerStatefulWidget {
  const SafetySettingsScreen({super.key});

  @override
  ConsumerState<SafetySettingsScreen> createState() =>
      _SafetySettingsScreenState();
}

class _SafetySettingsScreenState extends ConsumerState<SafetySettingsScreen> {
  int _checkIntervalHours = 24;
  int _gracePeriodSeconds = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Preferences'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SnackBarHelper.showSuccess(context, 'Preferences saved!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.spacing24),
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
              style: AppTextStyles.bodyMedium(color: AppColors.grey500),
            ),
            const SizedBox(height: AppDesignTokens.spacing16),
            Slider(
              value: _checkIntervalHours.toDouble(),
              min: 12,
              max: 72,
              divisions: 5,
              label: '$_checkIntervalHours hours',
              onChanged: (value) {
                setState(() {
                  _checkIntervalHours = value.toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('12h', style: AppTextStyles.bodySmall()),
                Text(
                  '$_checkIntervalHours hours',
                  style: AppTextStyles.titleSmall(color: AppColors.primary),
                ),
                Text('72h', style: AppTextStyles.bodySmall()),
              ],
            ),

            const SizedBox(height: AppDesignTokens.spacing40),

            // Grace period
            Text(
              'Grace Period',
              style: AppTextStyles.titleSmall(),
            ),
            const SizedBox(height: AppDesignTokens.spacing8),
            Text(
              'How long to wait before alerting contacts?',
              style: AppTextStyles.bodyMedium(color: AppColors.grey500),
            ),
            const SizedBox(height: AppDesignTokens.spacing16),
            Slider(
              value: _gracePeriodSeconds.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              label: '$_gracePeriodSeconds seconds',
              onChanged: (value) {
                setState(() {
                  _gracePeriodSeconds = value.toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('5s', style: AppTextStyles.bodySmall()),
                Text(
                  '$_gracePeriodSeconds seconds',
                  style: AppTextStyles.titleSmall(color: AppColors.primary),
                ),
                Text('60s', style: AppTextStyles.bodySmall()),
              ],
            ),

            const Spacer(),

            // Info card
            AppCard(
              backgroundColor: AppColors.warningBackground,
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.warningColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'A shorter grace period means faster alerts, but may cause more false alarms.',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.warningDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
