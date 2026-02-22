/// Alert Status Enum
enum AlertStatus {
  pending,
  countdown,
  triggered,
  cancelled,
  sent,
  failed,
}

/// Alert Type Enum
enum AlertType {
  missedCheckIn,
  powerButtonSos,
  shakeToSos,
  walkWithMe,
  manual,
}

/// Alert Model
class Alert {
  final String id;
  final String userId;
  final AlertType type;
  final AlertStatus status;
  final DateTime triggeredAt;
  final DateTime? cancelledAt;
  final DateTime? sentAt;
  final double? locationLat;
  final double? locationLong;
  final String? locationAddress;
  final List<String> contactIdsNotified;
  final List<String> emailIds;
  final String? cancellationReason;
  final String? failureReason;
  final DateTime createdAt;

  const Alert({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.triggeredAt,
    this.cancelledAt,
    this.sentAt,
    this.locationLat,
    this.locationLong,
    this.locationAddress,
    this.contactIdsNotified = const [],
    this.emailIds = const [],
    this.cancellationReason,
    this.failureReason,
    required this.createdAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: AlertType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AlertType.missedCheckIn,
      ),
      status: AlertStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AlertStatus.pending,
      ),
      triggeredAt: DateTime.parse(json['triggered_at'] as String),
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : null,
      locationLat: json['location_lat'] as double?,
      locationLong: json['location_long'] as double?,
      locationAddress: json['location_address'] as String?,
      contactIdsNotified: (json['contact_ids_notified'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      emailIds:
          (json['email_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      cancellationReason: json['cancellation_reason'] as String?,
      failureReason: json['failure_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'status': status.name,
      'triggered_at': triggeredAt.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'sent_at': sentAt?.toIso8601String(),
      'location_lat': locationLat,
      'location_long': locationLong,
      'location_address': locationAddress,
      'contact_ids_notified': contactIdsNotified,
      'email_ids': emailIds,
      'cancellation_reason': cancellationReason,
      'failure_reason': failureReason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Alert copyWith({
    String? id,
    String? userId,
    AlertType? type,
    AlertStatus? status,
    DateTime? triggeredAt,
    DateTime? cancelledAt,
    DateTime? sentAt,
    double? locationLat,
    double? locationLong,
    String? locationAddress,
    List<String>? contactIdsNotified,
    List<String>? emailIds,
    String? cancellationReason,
    String? failureReason,
    DateTime? createdAt,
  }) {
    return Alert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      sentAt: sentAt ?? this.sentAt,
      locationLat: locationLat ?? this.locationLat,
      locationLong: locationLong ?? this.locationLong,
      locationAddress: locationAddress ?? this.locationAddress,
      contactIdsNotified: contactIdsNotified ?? this.contactIdsNotified,
      emailIds: emailIds ?? this.emailIds,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      failureReason: failureReason ?? this.failureReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if location is available
  bool get hasLocation => locationLat != null && locationLong != null;

  /// Get Google Maps URL
  String get googleMapsUrl {
    if (!hasLocation) return '';
    return 'https://www.google.com/maps?q=$locationLat,$locationLong';
  }

  /// Check if alert is still active (not resolved)
  bool get isActive =>
      status == AlertStatus.pending ||
      status == AlertStatus.countdown ||
      status == AlertStatus.triggered;

  /// Check if alert was resolved
  bool get isResolved =>
      status == AlertStatus.cancelled ||
      status == AlertStatus.sent ||
      status == AlertStatus.failed;

  /// Get status display text
  String get statusText {
    switch (status) {
      case AlertStatus.pending:
        return 'Pending';
      case AlertStatus.countdown:
        return 'Countdown Active';
      case AlertStatus.triggered:
        return 'Triggered';
      case AlertStatus.cancelled:
        return 'Cancelled';
      case AlertStatus.sent:
        return 'Sent';
      case AlertStatus.failed:
        return 'Failed';
    }
  }

  /// Get type display text
  String get typeText {
    switch (type) {
      case AlertType.missedCheckIn:
        return 'Missed Check-in';
      case AlertType.powerButtonSos:
        return 'Power Button SOS';
      case AlertType.shakeToSos:
        return 'Shake SOS';
      case AlertType.walkWithMe:
        return 'Walk With Me Alert';
      case AlertType.manual:
        return 'Manual Alert';
    }
  }
}
