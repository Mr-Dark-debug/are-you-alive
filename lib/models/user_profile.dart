/// User Profile Model
class UserProfile {
  final String id;
  final String clerkId;
  final String name;
  final String phone;
  final String gender;
  final DateTime dateOfBirth;
  final String? email;
  final String? profileImageUrl;
  final int checkIntervalHours;
  final int gracePeriodSeconds;
  final DateTime? lastCheckIn;
  final DateTime? awayModeUntil;
  final bool showEnhancedSafety;
  final bool awayModeEnabled;
  final bool powerButtonSosEnabled;
  final bool walkWithMeEnabled;
  final bool fakeCallEnabled;
  final bool discreetModeEnabled;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    required this.clerkId,
    required this.name,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    this.email,
    this.profileImageUrl,
    required this.checkIntervalHours,
    required this.gracePeriodSeconds,
    this.lastCheckIn,
    this.awayModeUntil,
    this.showEnhancedSafety = false,
    this.awayModeEnabled = false,
    this.powerButtonSosEnabled = false,
    this.walkWithMeEnabled = false,
    this.fakeCallEnabled = false,
    this.discreetModeEnabled = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      clerkId: json['clerk_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      email: json['email'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      checkIntervalHours: json['check_interval_hours'] as int,
      gracePeriodSeconds: json['grace_period_seconds'] as int,
      lastCheckIn: json['last_check_in'] != null
          ? DateTime.parse(json['last_check_in'] as String)
          : null,
      awayModeUntil: json['away_mode_until'] != null
          ? DateTime.parse(json['away_mode_until'] as String)
          : null,
      showEnhancedSafety: json['show_enhanced_safety'] as bool? ?? false,
      awayModeEnabled: json['away_mode_enabled'] as bool? ?? false,
      powerButtonSosEnabled: json['power_button_sos_enabled'] as bool? ?? false,
      walkWithMeEnabled: json['walk_with_me_enabled'] as bool? ?? false,
      fakeCallEnabled: json['fake_call_enabled'] as bool? ?? false,
      discreetModeEnabled: json['discreet_mode_enabled'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clerk_id': clerkId,
      'name': name,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'email': email,
      'profile_image_url': profileImageUrl,
      'check_interval_hours': checkIntervalHours,
      'grace_period_seconds': gracePeriodSeconds,
      'last_check_in': lastCheckIn?.toIso8601String(),
      'away_mode_until': awayModeUntil?.toIso8601String(),
      'show_enhanced_safety': showEnhancedSafety,
      'away_mode_enabled': awayModeEnabled,
      'power_button_sos_enabled': powerButtonSosEnabled,
      'walk_with_me_enabled': walkWithMeEnabled,
      'fake_call_enabled': fakeCallEnabled,
      'discreet_mode_enabled': discreetModeEnabled,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? clerkId,
    String? name,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
    String? email,
    String? profileImageUrl,
    int? checkIntervalHours,
    int? gracePeriodSeconds,
    DateTime? lastCheckIn,
    DateTime? awayModeUntil,
    bool? showEnhancedSafety,
    bool? awayModeEnabled,
    bool? powerButtonSosEnabled,
    bool? walkWithMeEnabled,
    bool? fakeCallEnabled,
    bool? discreetModeEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      clerkId: clerkId ?? this.clerkId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      checkIntervalHours: checkIntervalHours ?? this.checkIntervalHours,
      gracePeriodSeconds: gracePeriodSeconds ?? this.gracePeriodSeconds,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      awayModeUntil: awayModeUntil ?? this.awayModeUntil,
      showEnhancedSafety: showEnhancedSafety ?? this.showEnhancedSafety,
      awayModeEnabled: awayModeEnabled ?? this.awayModeEnabled,
      powerButtonSosEnabled: powerButtonSosEnabled ?? this.powerButtonSosEnabled,
      walkWithMeEnabled: walkWithMeEnabled ?? this.walkWithMeEnabled,
      fakeCallEnabled: fakeCallEnabled ?? this.fakeCallEnabled,
      discreetModeEnabled: discreetModeEnabled ?? this.discreetModeEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if user needs to check in
  bool get needsCheckIn {
    if (lastCheckIn == null) return true;
    final nextCheckIn = lastCheckIn!.add(Duration(hours: checkIntervalHours));
    return DateTime.now().isAfter(nextCheckIn);
  }

  /// Get next check-in time
  DateTime get nextCheckIn {
    if (lastCheckIn == null) {
      return DateTime.now().add(Duration(hours: checkIntervalHours));
    }
    return lastCheckIn!.add(Duration(hours: checkIntervalHours));
  }

  /// Get time remaining until next check-in
  Duration get timeRemaining {
    final next = nextCheckIn;
    final remaining = next.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Check if away mode is active
  bool get isAwayModeActive {
    if (!awayModeEnabled || awayModeUntil == null) return false;
    return DateTime.now().isBefore(awayModeUntil!);
  }

  /// Check if enhanced safety features should be shown
  bool get shouldShowEnhancedSafety =>
      gender.toLowerCase() == 'female' || showEnhancedSafety;

  /// Get initials for avatar
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
