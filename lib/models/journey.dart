/// Journey Status Enum
enum JourneyStatus {
  active,
  completed,
  cancelled,
  alertTriggered,
}

/// Journey Checkpoint Model
class JourneyCheckpoint {
  final double lat;
  final double long;
  final DateTime timestamp;
  final double? accuracy;
  final double? speed;

  const JourneyCheckpoint({
    required this.lat,
    required this.long,
    required this.timestamp,
    this.accuracy,
    this.speed,
  });

  factory JourneyCheckpoint.fromJson(Map<String, dynamic> json) {
    return JourneyCheckpoint(
      lat: json['lat'] as double,
      long: json['long'] as double,
      timestamp: DateTime.parse(json['timestamp'] as String),
      accuracy: json['accuracy'] as double?,
      speed: json['speed'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
      'timestamp': timestamp.toIso8601String(),
      'accuracy': accuracy,
      'speed': speed,
    };
  }
}

/// Journey Model
class Journey {
  final String id;
  final String userId;
  final DateTime startedAt;
  final DateTime? estimatedArrivalAt;
  final DateTime? completedAt;
  final double? startLat;
  final double? startLong;
  final double? destinationLat;
  final double? destinationLong;
  final String? destinationAddress;
  final JourneyStatus status;
  final List<JourneyCheckpoint> checkpoints;
  final int estimatedMinutes;
  final String? emergencyContactId;
  final DateTime createdAt;

  const Journey({
    required this.id,
    required this.userId,
    required this.startedAt,
    this.estimatedArrivalAt,
    this.completedAt,
    this.startLat,
    this.startLong,
    this.destinationLat,
    this.destinationLong,
    this.destinationAddress,
    required this.status,
    this.checkpoints = const [],
    this.estimatedMinutes = 15,
    this.emergencyContactId,
    required this.createdAt,
  });

  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      estimatedArrivalAt: json['estimated_arrival_at'] != null
          ? DateTime.parse(json['estimated_arrival_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      startLat: json['start_lat'] as double?,
      startLong: json['start_long'] as double?,
      destinationLat: json['destination_lat'] as double?,
      destinationLong: json['destination_long'] as double?,
      destinationAddress: json['destination_address'] as String?,
      status: JourneyStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => JourneyStatus.active,
      ),
      checkpoints: (json['checkpoints'] as List<dynamic>?)
              ?.map((e) => JourneyCheckpoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      estimatedMinutes: json['estimated_minutes'] as int? ?? 15,
      emergencyContactId: json['emergency_contact_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'started_at': startedAt.toIso8601String(),
      'estimated_arrival_at': estimatedArrivalAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'start_lat': startLat,
      'start_long': startLong,
      'destination_lat': destinationLat,
      'destination_long': destinationLong,
      'destination_address': destinationAddress,
      'status': status.name,
      'checkpoints': checkpoints.map((e) => e.toJson()).toList(),
      'estimated_minutes': estimatedMinutes,
      'emergency_contact_id': emergencyContactId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Journey copyWith({
    String? id,
    String? userId,
    DateTime? startedAt,
    DateTime? estimatedArrivalAt,
    DateTime? completedAt,
    double? startLat,
    double? startLong,
    double? destinationLat,
    double? destinationLong,
    String? destinationAddress,
    JourneyStatus? status,
    List<JourneyCheckpoint>? checkpoints,
    int? estimatedMinutes,
    String? emergencyContactId,
    DateTime? createdAt,
  }) {
    return Journey(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startedAt: startedAt ?? this.startedAt,
      estimatedArrivalAt: estimatedArrivalAt ?? this.estimatedArrivalAt,
      completedAt: completedAt ?? this.completedAt,
      startLat: startLat ?? this.startLat,
      startLong: startLong ?? this.startLong,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLong: destinationLong ?? this.destinationLong,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      status: status ?? this.status,
      checkpoints: checkpoints ?? this.checkpoints,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      emergencyContactId: emergencyContactId ?? this.emergencyContactId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if journey is active
  bool get isActive => status == JourneyStatus.active;

  /// Get elapsed duration
  Duration get elapsedDuration {
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  /// Check if overdue
  bool get isOverdue {
    if (estimatedArrivalAt == null) return false;
    return DateTime.now().isAfter(estimatedArrivalAt!);
  }

  /// Get remaining time (negative if overdue)
  Duration get remainingTime {
    if (estimatedArrivalAt == null) return Duration.zero;
    return estimatedArrivalAt!.difference(DateTime.now());
  }

  /// Get latest checkpoint
  JourneyCheckpoint? get latestCheckpoint {
    if (checkpoints.isEmpty) return null;
    return checkpoints.last;
  }
}
