/// Blood group options
enum BloodGroup {
  aPositive('A+', 'A Positive'),
  aNegative('A-', 'A Negative'),
  bPositive('B+', 'B Positive'),
  bNegative('B-', 'B Negative'),
  abPositive('AB+', 'AB Positive'),
  abNegative('AB-', 'AB Negative'),
  oPositive('O+', 'O Positive'),
  oNegative('O-', 'O Negative'),
  unknown('Unknown', 'Unknown');

  final String value;
  final String displayName;

  const BloodGroup(this.value, this.displayName);

  static BloodGroup fromString(String value) {
    return BloodGroup.values.firstWhere(
      (e) => e.value == value || e.displayName == value,
      orElse: () => BloodGroup.unknown,
    );
  }
}

/// Medical Info Model
class MedicalInfo {
  final String id;
  final String userId;
  final String bloodGroup;
  final String allergies;
  final String medications;
  final String conditions;
  final String emergencyNotes;
  final String? organDonor;
  final bool hasPacemaker;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const MedicalInfo({
    required this.id,
    required this.userId,
    required this.bloodGroup,
    this.allergies = '',
    this.medications = '',
    this.conditions = '',
    this.emergencyNotes = '',
    this.organDonor,
    this.hasPacemaker = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory MedicalInfo.fromJson(Map<String, dynamic> json) {
    return MedicalInfo(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bloodGroup: json['blood_group'] as String,
      allergies: json['allergies'] as String? ?? '',
      medications: json['medications'] as String? ?? '',
      conditions: json['conditions'] as String? ?? '',
      emergencyNotes: json['emergency_notes'] as String? ?? '',
      organDonor: json['organ_donor'] as String?,
      hasPacemaker: json['has_pacemaker'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'blood_group': bloodGroup,
      'allergies': allergies,
      'medications': medications,
      'conditions': conditions,
      'emergency_notes': emergencyNotes,
      'organ_donor': organDonor,
      'has_pacemaker': hasPacemaker,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MedicalInfo copyWith({
    String? id,
    String? userId,
    String? bloodGroup,
    String? allergies,
    String? medications,
    String? conditions,
    String? emergencyNotes,
    String? organDonor,
    bool? hasPacemaker,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      conditions: conditions ?? this.conditions,
      emergencyNotes: emergencyNotes ?? this.emergencyNotes,
      organDonor: organDonor ?? this.organDonor,
      hasPacemaker: hasPacemaker ?? this.hasPacemaker,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if has any allergies
  bool get hasAllergies => allergies.isNotEmpty;

  /// Check if on any medications
  bool get hasMedications => medications.isNotEmpty;

  /// Check if has any conditions
  bool get hasConditions => conditions.isNotEmpty;

  /// Get summary for emergency display
  String get emergencySummary {
    final parts = <String>[];
    if (bloodGroup != 'Unknown') parts.add('Blood: $bloodGroup');
    if (hasAllergies) parts.add('Allergies: $allergies');
    if (hasMedications) parts.add('Meds: $medications');
    if (hasConditions) parts.add('Conditions: $conditions');
    return parts.join(' | ');
  }
}
