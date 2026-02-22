/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Are You Alive';
  static const String appVersion = '1.0.0';

  // Timer Defaults
  static const int defaultCheckIntervalHours = 24;
  static const int defaultGracePeriodSeconds = 15;
  static const int defaultWarningHoursBefore = 2;

  // Timer Constraints
  static const int minCheckIntervalHours = 12;
  static const int maxCheckIntervalHours = 72;
  static const int minGracePeriodSeconds = 5;
  static const int maxGracePeriodSeconds = 60;

  // Check-in Interval Options (hours)
  static const List<int> checkIntervalOptions = [12, 24, 48, 72];

  // Grace Period Options (seconds)
  static const List<int> gracePeriodOptions = [5, 10, 15, 20, 30, 45, 60];

  // Background Service
  static const Duration backgroundCheckInterval = Duration(minutes: 15);
  static const String workManagerTaskName = 'are-you-alive-check-task';

  // Notifications
  static const int alertNotificationId = 1001;
  static const int warningNotificationId = 1002;
  static const String alertChannelId = 'are-you-alive-alerts';
  static const String alertChannelName = 'Safety Alerts';
  static const String alertChannelDescription =
      'Critical safety alert notifications';

  // Location
  static const int locationAccuracyMeters = 10;
  static const int locationUpdateIntervalSeconds = 30;
  static const Duration locationTimeout = Duration(seconds: 30);

  // Contacts
  static const int minContactsRequired = 1;
  static const int maxContactsAllowed = 5;

  // Walk With Me
  static const int defaultJourneyMinutes = 15;
  static const int maxJourneyMinutes = 120;
  static const int journeyCheckpointIntervalSeconds = 60;

  // Fake Call
  static const int fakeCallDelaySeconds = 5;
  static const int fakeCallRingDurationSeconds = 30;

  // Power Button SOS
  static const int powerButtonPressCount = 3;
  static const Duration powerButtonPressWindow = Duration(milliseconds: 1500);

  // Shake Detection
  static const double shakeThresholdGravity = 2.7;
  static const int shakeSlopTimeMs = 500;
  static const int shakeCountResetTimeMs = 3000;
  static const int requiredShakeCount = 3;

  // API Endpoints
  static const String brevoApiUrl = 'https://api.brevo.com/v3/smtp/email';

  // Email Templates
  static const String emailSenderName = 'Are You Alive';
  static const String emailSenderAddress = 'noreply@areyoualive.app';
  static const String emergencyEmailSubject = 'EMERGENCY ALERT: {name} needs help';
  static const String verificationEmailSubject =
      'You have been added as an emergency contact';

  // Shared Preferences Keys
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyHasCompletedSetup = 'has_completed_setup';
  static const String keyLastCheckIn = 'last_check_in';
  static const String keyUserProfile = 'user_profile';
  static const String keySafetySettings = 'safety_settings';
  static const String keyAwayModeEnabled = 'away_mode_enabled';
  static const String keyAwayModeUntil = 'away_mode_until';
  static const String keyNotificationEnabled = 'notification_enabled';
  static const String keyLocationEnabled = 'location_enabled';
  static const String keyEnhancedSafetyEnabled = 'enhanced_safety_enabled';
  static const String keyDiscreetModeEnabled = 'discreet_mode_enabled';

  // Lottie Animation URLs (from lottiefiles.com)
  static const String shieldAnimationUrl =
      'https://lottie.host/cf13428e-8f3a-4ec3-b8f4-5f8d6d3e9b7c/shield-pulse.json';
  static const String successAnimationUrl =
      'https://lottie.host/e8a6e5d2-7b4c-4f3a-9c1d-5e7f8a9b0c1d/success-check.json';
  static const String alertAnimationUrl =
      'https://lottie.host/a1b2c3d4-e5f6-7890-abcd-ef1234567890/alert-pulse.json';
  static const String locationAnimationUrl =
      'https://lottie.host/12345678-90ab-cdef-1234-567890abcdef/location-pin.json';

  // Placeholder Animation URLs (will work with any valid Lottie URL)
  static const String loadingAnimationUrl =
      'https://assets2.lottiefiles.com/packages/lf20_usmfx6bp.json';
  static const String heartPulseAnimationUrl =
      'https://assets10.lottiefiles.com/packages/lf20_xyadoh9h.json';
}

/// Environment variable keys
class EnvKeys {
  EnvKeys._();

  static const String supabaseUrl = 'SUPABASE_URL';
  static const String supabaseAnonKey = 'SUPABASE_ANON_KEY';
  static const String clerkPublishableKey = 'CLERK_PUBLISHABLE_KEY';
  static const String brevoApiKey = 'BREVO_API_KEY';
}
