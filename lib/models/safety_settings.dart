/// Safety Settings Model
class SafetySettings {
  final String userId;
  final int checkIntervalHours;
  final int gracePeriodSeconds;
  final int warningHoursBefore;
  final bool alertWithEmail;
  final bool alertWithSms;
  final bool alertWithPush;
  final bool playAlarmSound;
  final bool vibrateOnAlert;
  final bool powerButtonSosEnabled;
  final bool shakeToSosEnabled;
  final bool walkWithMeEnabled;
  final bool fakeCallEnabled;
  final bool discreetModeEnabled;
  final bool awayModeEnabled;
  final DateTime? awayModeUntil;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SafetySettings({
    required this.userId,
    this.checkIntervalHours = 24,
    this.gracePeriodSeconds = 15,
    this.warningHoursBefore = 2,
    this.alertWithEmail = true,
    this.alertWithSms = false,
    this.alertWithPush = true,
    this.playAlarmSound = true,
    this.vibrateOnAlert = true,
    this.powerButtonSosEnabled = false,
    this.shakeToSosEnabled = false,
    this.walkWithMeEnabled = false,
    this.fakeCallEnabled = false,
    this.discreetModeEnabled = false,
    this.awayModeEnabled = false,
    this.awayModeUntil,
    required this.createdAt,
    this.updatedAt,
  });

  factory SafetySettings.fromJson(Map<String, dynamic> json) {
    return SafetySettings(
      userId: json['user_id'] as String,
      checkIntervalHours: json['check_interval_hours'] as int? ?? 24,
      gracePeriodSeconds: json['grace_period_seconds'] as int? ?? 15,
      warningHoursBefore: json['warning_hours_before'] as int? ?? 2,
      alertWithEmail: json['alert_with_email'] as bool? ?? true,
      alertWithSms: json['alert_with_sms'] as bool? ?? false,
      alertWithPush: json['alert_with_push'] as bool? ?? true,
      playAlarmSound: json['play_alarm_sound'] as bool? ?? true,
      vibrateOnAlert: json['vibrate_on_alert'] as bool? ?? true,
      powerButtonSosEnabled: json['power_button_sos_enabled'] as bool? ?? false,
      shakeToSosEnabled: json['shake_to_sos_enabled'] as bool? ?? false,
      walkWithMeEnabled: json['walk_with_me_enabled'] as bool? ?? false,
      fakeCallEnabled: json['fake_call_enabled'] as bool? ?? false,
      discreetModeEnabled: json['discreet_mode_enabled'] as bool? ?? false,
      awayModeEnabled: json['away_mode_enabled'] as bool? ?? false,
      awayModeUntil: json['away_mode_until'] != null
          ? DateTime.parse(json['away_mode_until'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'check_interval_hours': checkIntervalHours,
      'grace_period_seconds': gracePeriodSeconds,
      'warning_hours_before': warningHoursBefore,
      'alert_with_email': alertWithEmail,
      'alert_with_sms': alertWithSms,
      'alert_with_push': alertWithPush,
      'play_alarm_sound': playAlarmSound,
      'vibrate_on_alert': vibrateOnAlert,
      'power_button_sos_enabled': powerButtonSosEnabled,
      'shake_to_sos_enabled': shakeToSosEnabled,
      'walk_with_me_enabled': walkWithMeEnabled,
      'fake_call_enabled': fakeCallEnabled,
      'discreet_mode_enabled': discreetModeEnabled,
      'away_mode_enabled': awayModeEnabled,
      'away_mode_until': awayModeUntil?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SafetySettings copyWith({
    String? userId,
    int? checkIntervalHours,
    int? gracePeriodSeconds,
    int? warningHoursBefore,
    bool? alertWithEmail,
    bool? alertWithSms,
    bool? alertWithPush,
    bool? playAlarmSound,
    bool? vibrateOnAlert,
    bool? powerButtonSosEnabled,
    bool? shakeToSosEnabled,
    bool? walkWithMeEnabled,
    bool? fakeCallEnabled,
    bool? discreetModeEnabled,
    bool? awayModeEnabled,
    DateTime? awayModeUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SafetySettings(
      userId: userId ?? this.userId,
      checkIntervalHours: checkIntervalHours ?? this.checkIntervalHours,
      gracePeriodSeconds: gracePeriodSeconds ?? this.gracePeriodSeconds,
      warningHoursBefore: warningHoursBefore ?? this.warningHoursBefore,
      alertWithEmail: alertWithEmail ?? this.alertWithEmail,
      alertWithSms: alertWithSms ?? this.alertWithSms,
      alertWithPush: alertWithPush ?? this.alertWithPush,
      playAlarmSound: playAlarmSound ?? this.playAlarmSound,
      vibrateOnAlert: vibrateOnAlert ?? this.vibrateOnAlert,
      powerButtonSosEnabled: powerButtonSosEnabled ?? this.powerButtonSosEnabled,
      shakeToSosEnabled: shakeToSosEnabled ?? this.shakeToSosEnabled,
      walkWithMeEnabled: walkWithMeEnabled ?? this.walkWithMeEnabled,
      fakeCallEnabled: fakeCallEnabled ?? this.fakeCallEnabled,
      discreetModeEnabled: discreetModeEnabled ?? this.discreetModeEnabled,
      awayModeEnabled: awayModeEnabled ?? this.awayModeEnabled,
      awayModeUntil: awayModeUntil ?? this.awayModeUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Default settings
  static SafetySettings defaults({required String userId}) => SafetySettings(
        userId: userId,
        createdAt: DateTime.now(),
      );

  /// Get check interval options
  static List<int> get checkIntervalOptions => [12, 24, 48, 72];

  /// Get grace period options (in seconds)
  static List<int> get gracePeriodOptions => [5, 10, 15, 20, 30, 45, 60];

  /// Get formatted check interval
  String get formattedCheckInterval {
    if (checkIntervalHours >= 24) {
      final days = checkIntervalHours ~/ 24;
      return days == 1 ? 'Every day' : 'Every $days days';
    }
    return 'Every $checkIntervalHours hours';
  }

  /// Get formatted grace period
  String get formattedGracePeriod {
    if (gracePeriodSeconds < 60) {
      return '$gracePeriodSeconds seconds';
    }
    final minutes = gracePeriodSeconds ~/ 60;
    return minutes == 1 ? '1 minute' : '$minutes minutes';
  }
}
