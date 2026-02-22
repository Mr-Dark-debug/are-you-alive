import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Location data model
class LocationData {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? speed;
  final DateTime timestamp;
  final String? address;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    required this.timestamp,
    this.address,
  });

  factory LocationData.fromPosition(Position position, {String? address}) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      speed: position.speed,
      timestamp: position.timestamp,
      address: address,
    );
  }

  String get googleMapsUrl =>
      'https://www.google.com/maps?q=$latitude,$longitude';
  String get appleMapsUrl => 'https://maps.apple.com/?q=$latitude,$longitude';
}

/// Location service for GPS operations
class LocationService {
  StreamSubscription<Position>? _positionStreamSubscription;
  LocationData? _lastKnownLocation;

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Request always allow permission (for background tracking)
  Future<LocationPermission> requestAlwaysPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse) {
      return await Geolocator.requestPermission();
    }
    return permission;
  }

  /// Get current location
  Future<LocationData?> getCurrentLocation() async {
    try {
      final permission = await checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      // Try to get address
      String? address;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address = '${place.street}, ${place.locality}, ${place.country}';
        }
      } catch (_) {
        // Address lookup failed, continue without
      }

      _lastKnownLocation =
          LocationData.fromPosition(position, address: address);
      return _lastKnownLocation;
    } catch (e) {
      return null;
    }
  }

  /// Get last known location
  Future<LocationData?> getLastKnownLocation() async {
    try {
      if (_lastKnownLocation != null) {
        return _lastKnownLocation;
      }

      final permission = await checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        _lastKnownLocation = LocationData.fromPosition(position);
        return _lastKnownLocation;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Start location stream for tracking
  Stream<LocationData> startLocationStream({
    int distanceFilter = 10,
    int intervalSeconds = 30,
  }) {
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilter,
      timeLimit: Duration(seconds: intervalSeconds),
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((position) {
      final location = LocationData.fromPosition(position);
      _lastKnownLocation = location;
      return location;
    });
  }

  /// Stop location stream
  void stopLocationStream() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  /// Calculate distance between two points in meters
  double calculateDistance(
    double startLat,
    double startLong,
    double endLat,
    double endLong,
  ) {
    return Geolocator.distanceBetween(startLat, startLong, endLat, endLong);
  }

  /// Calculate distance in kilometers
  double calculateDistanceKm(
    double startLat,
    double startLong,
    double endLat,
    double endLong,
  ) {
    return calculateDistance(startLat, startLong, endLat, endLong) / 1000;
  }

  /// Get address from coordinates
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Open device location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}

/// Provider for location service
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Provider for current location
final currentLocationProvider = FutureProvider<LocationData?>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return await locationService.getCurrentLocation();
});

/// Provider for last known location
final lastKnownLocationProvider = Provider<LocationData?>((ref) {
  // This would be updated by the location stream
  return null;
});
