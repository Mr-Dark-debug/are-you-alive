import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../services/local_storage_service.dart';

// ═══════════════════════════════════════════════════════════════════
// MAIN SETTINGS SCREEN
// ═══════════════════════════════════════════════════════════════════
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile card
          _buildProfileCard(context, isDark).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),

          // Sections
          _SectionLabel('ACCOUNT'),
          const SizedBox(height: 10),
          _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  subtitle: 'Name, phone, DOB',
                  onTap: () => context.push('/settings/profile'))
              .animate()
              .fadeIn(delay: 100.ms),
          _SettingsTile(
                  icon: Icons.medical_information_outlined,
                  title: 'Medical Info',
                  subtitle: 'Blood group, allergies',
                  onTap: () => context.push('/settings/medical'))
              .animate()
              .fadeIn(delay: 150.ms),

          const SizedBox(height: 24),
          _SectionLabel('SAFETY'),
          const SizedBox(height: 10),
          _SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Safety Preferences',
                  subtitle: 'Check-in intervals, alerts',
                  onTap: () => context.push('/settings/safety'))
              .animate()
              .fadeIn(delay: 200.ms),
          _SettingsTile(
                  icon: Icons.people_outline,
                  title: 'Emergency Contacts',
                  subtitle: 'Manage your contacts',
                  onTap: () => context.push('/contacts'))
              .animate()
              .fadeIn(delay: 250.ms),

          const SizedBox(height: 24),
          _SectionLabel('APP'),
          const SizedBox(height: 10),
          _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Alert preferences',
                  onTap: () {})
              .animate()
              .fadeIn(delay: 300.ms),
          _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () {})
              .animate()
              .fadeIn(delay: 350.ms),

          const SizedBox(height: 24),

          // Sign out
          _SignOutButton(onTap: () {
            ref.read(localStorageServiceProvider).clearAll();
            context.go('/onboarding');
          }).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: GlassmorphismDecoration.safeCard(context),
      child: Row(children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.person, color: AppColors.white, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pearl',
                style: AppTextStyles.titleMedium(
                    color: isDark ? AppColors.white : AppColors.grey900,
                    weight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('pearl@example.com',
                style: AppTextStyles.bodySmall(color: AppColors.grey400)),
          ],
        )),
        Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// PROFILE SETTINGS
// ═══════════════════════════════════════════════════════════════════
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _nameController = TextEditingController(text: 'Pearl');
  final _phoneController = TextEditingController(text: '+1 234 567 8900');
  String _selectedGender = 'Female';

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: AppColors.white, size: 20),
          SizedBox(width: 10),
          Text('Profile saved!')
        ]),
        backgroundColor: AppColors.calmColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Avatar
          Center(
              child: Stack(children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.accent, AppColors.accentDark]),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.person, color: AppColors.white, size: 44),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground,
                          width: 3)),
                  child: const Icon(Icons.camera_alt,
                      size: 14, color: AppColors.white),
                )),
          ])),
          const SizedBox(height: 32),
          TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline, size: 20))),
          const SizedBox(height: 16),
          TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined, size: 20))),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedGender,
            decoration: const InputDecoration(
                labelText: 'Gender',
                prefixIcon: Icon(Icons.wc_outlined, size: 20)),
            items: ['Male', 'Female', 'Non-Binary', 'Prefer not to say']
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedGender = v);
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// MEDICAL SETTINGS
// ═══════════════════════════════════════════════════════════════════
class MedicalSettingsScreen extends StatefulWidget {
  const MedicalSettingsScreen({super.key});
  @override
  State<MedicalSettingsScreen> createState() => _MedicalSettingsScreenState();
}

class _MedicalSettingsScreenState extends State<MedicalSettingsScreen> {
  String _selectedBloodGroup = 'Unknown';
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _conditionsController = TextEditingController();

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: AppColors.white, size: 20),
          SizedBox(width: 10),
          Text('Medical info saved!')
        ]),
        backgroundColor: AppColors.calmColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    _medicationsController.dispose();
    _conditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Medical Info'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.infoLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline, color: AppColors.blue, size: 20),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                      'This info will be shared with emergency services when needed.',
                      style: AppTextStyles.bodySmall(color: AppColors.blue))),
            ]),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _selectedBloodGroup,
            decoration: const InputDecoration(
                labelText: 'Blood Group',
                prefixIcon: Icon(Icons.bloodtype_outlined, size: 20)),
            items: ['Unknown', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedBloodGroup = v);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
              controller: _allergiesController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Allergies',
                  prefixIcon: Icon(Icons.warning_amber_outlined, size: 20),
                  alignLabelWithHint: true)),
          const SizedBox(height: 16),
          TextFormField(
              controller: _medicationsController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Medications',
                  prefixIcon: Icon(Icons.medication_outlined, size: 20),
                  alignLabelWithHint: true)),
          const SizedBox(height: 16),
          TextFormField(
              controller: _conditionsController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Medical Conditions',
                  prefixIcon: Icon(Icons.local_hospital_outlined, size: 20),
                  alignLabelWithHint: true)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// SAFETY SETTINGS
// ═══════════════════════════════════════════════════════════════════
class SafetySettingsScreen extends ConsumerStatefulWidget {
  const SafetySettingsScreen({super.key});
  @override
  ConsumerState<SafetySettingsScreen> createState() =>
      _SafetySettingsScreenState();
}

class _SafetySettingsScreenState extends ConsumerState<SafetySettingsScreen> {
  int _checkInterval = 24;
  int _gracePeriod = 15;
  bool _emailAlerts = true;
  bool _pushAlerts = true;
  bool _soundAlerts = true;
  bool _vibrateAlerts = true;

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: AppColors.white, size: 20),
          SizedBox(width: 10),
          Text('Safety settings saved!')
        ]),
        backgroundColor: AppColors.calmColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Safety'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionLabel('CHECK-IN FREQUENCY'),
          const SizedBox(height: 12),
          Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [12, 24, 48, 72].map((h) {
                final label =
                    h >= 24 ? '${h ~/ 24} day${h > 24 ? 's' : ''}' : '$h hrs';
                return _Chip(
                    label: label,
                    isSelected: _checkInterval == h,
                    onTap: () => setState(() => _checkInterval = h));
              }).toList()),
          const SizedBox(height: 28),
          _SectionLabel('GRACE PERIOD'),
          const SizedBox(height: 12),
          Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [5, 10, 15, 30, 60].map((s) {
                final label = s >= 60 ? '${s ~/ 60} min' : '$s sec';
                return _Chip(
                    label: label,
                    isSelected: _gracePeriod == s,
                    onTap: () => setState(() => _gracePeriod = s));
              }).toList()),
          const SizedBox(height: 28),
          _SectionLabel('ALERT CHANNELS'),
          const SizedBox(height: 12),
          _SwitchTile(
              title: 'Email Alerts',
              subtitle: 'Send email to contacts',
              icon: Icons.email_outlined,
              value: _emailAlerts,
              isDark: isDark,
              onChanged: (v) => setState(() => _emailAlerts = v)),
          _SwitchTile(
              title: 'Push Notifications',
              subtitle: 'Send push alerts',
              icon: Icons.notifications_outlined,
              value: _pushAlerts,
              isDark: isDark,
              onChanged: (v) => setState(() => _pushAlerts = v)),
          _SwitchTile(
              title: 'Sound Alerts',
              subtitle: 'Play alarm sound',
              icon: Icons.volume_up_outlined,
              value: _soundAlerts,
              isDark: isDark,
              onChanged: (v) => setState(() => _soundAlerts = v)),
          _SwitchTile(
              title: 'Vibration',
              subtitle: 'Vibrate on alert',
              icon: Icons.vibration,
              value: _vibrateAlerts,
              isDark: isDark,
              onChanged: (v) => setState(() => _vibrateAlerts = v)),
        ],
      ),
    );
  }
}

// ─── SHARED WIDGETS ────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.overline(color: AppColors.grey400));
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _SettingsTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: GlassmorphismDecoration.safeCard(context),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isDark ? AppColors.grey800 : AppColors.grey100,
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.titleSmall(
                      color: isDark ? AppColors.white : AppColors.grey900)),
              Text(subtitle,
                  style: AppTextStyles.bodySmall(color: AppColors.grey400)),
            ],
          )),
          Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.grey400),
        ]),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final bool value, isDark;
  final ValueChanged<bool> onChanged;
  const _SwitchTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.value,
      required this.isDark,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: GlassmorphismDecoration.safeCard(context),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 14),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTextStyles.titleSmall(
                    color: isDark ? AppColors.white : AppColors.grey900)),
            Text(subtitle,
                style: AppTextStyles.bodySmall(color: AppColors.grey400)),
          ],
        )),
        Switch(value: value, onChanged: onChanged),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _Chip(
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
                      offset: const Offset(0, 3))
                ]
              : null,
        ),
        child: Text(label,
            style: AppTextStyles.labelMedium(
                color: isSelected
                    ? AppColors.white
                    : (isDark ? AppColors.grey300 : AppColors.grey600),
                weight: FontWeight.w600)),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SignOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.criticalColor),
          foregroundColor: AppColors.criticalColor,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20),
            SizedBox(width: 8),
            Text('Sign Out'),
          ],
        ),
      ),
    );
  }
}
