/// Check-in Model
class CheckIn {
  final String id;
  final String userId;
  final DateTime timestamp;
  final double? locationLat;
  final double? locationLong;
  final String? locationAddress;
  final bool isManual;
  final bool isAutomatic;
  final String? notes;
  final DateTime createdAt;

  const CheckIn({
    required this.id,
    required this.userId,
    required this.timestamp,
    this.locationLat,
    this.locationLong,
    this.locationAddress,
    this.isManual = false,
    this.isAutomatic = false,
    this.notes,
    required this.createdAt,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      locationLat: json['location_lat'] as double?,
      locationLong: json['location_long'] as double?,
      locationAddress: json['location_address'] as String?,
      isManual: json['is_manual'] as bool? ?? false,
      isAutomatic: json['is_automatic'] as bool? ?? false,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'location_lat': locationLat,
      'location_long': locationLong,
      'location_address': locationAddress,
      'is_manual': isManual,
      'is_automatic': isAutomatic,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Check if location is available
  bool get hasLocation => locationLat != null && locationLong != null;

  /// Get Google Maps URL
  String get googleMapsUrl {
    if (!hasLocation) return '';
    return 'https://www.google.com/maps?q=$locationLat,$locationLong';
  }

  /// Get Apple Maps URL
  String get appleMapsUrl {
    if (!hasLocation) return '';
    return 'https://maps.apple.com/?q=$locationLat,$locationLong';
  }
}
