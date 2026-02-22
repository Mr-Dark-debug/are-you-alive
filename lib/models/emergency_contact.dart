/// Common relationship types
enum ContactRelationship {
  mother('Mother'),
  father('Father'),
  sister('Sister'),
  brother('Brother'),
  spouse('Spouse'),
  partner('Partner'),
  child('Child'),
  friend('Friend'),
  colleague('Colleague'),
  neighbor('Neighbor'),
  doctor('Doctor'),
  other('Other');

  final String displayName;

  const ContactRelationship(this.displayName);
}

/// Emergency Contact Model
class EmergencyContact {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String? email;
  final String relationship;
  final bool isVerified;
  final int priority;
  final String? verificationToken;
  final DateTime? verifiedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const EmergencyContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    required this.relationship,
    this.isVerified = false,
    this.priority = 1,
    this.verificationToken,
    this.verifiedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      relationship: json['relationship'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      priority: json['priority'] as int? ?? 1,
      verificationToken: json['verification_token'] as String?,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
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
      'name': name,
      'phone': phone,
      'email': email,
      'relationship': relationship,
      'is_verified': isVerified,
      'priority': priority,
      'verification_token': verificationToken,
      'verified_at': verifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  EmergencyContact copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? relationship,
    bool? isVerified,
    int? priority,
    String? verificationToken,
    DateTime? verifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      isVerified: isVerified ?? this.isVerified,
      priority: priority ?? this.priority,
      verificationToken: verificationToken ?? this.verificationToken,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get initials for avatar
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Get display subtitle
  String get subtitle {
    if (email != null && email!.isNotEmpty) {
      return '$relationship • $email';
    }
    return '$relationship • $phone';
  }
}
