import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permission helper utilities
class PermissionHelper {
  PermissionHelper._();

  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Request always allow location permission (for background)
  static Future<bool> requestAlwaysLocationPermission() async {
    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  /// Request notification permission
  static Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true; // iOS handles this automatically
  }

  /// Request camera permission (for profile photo)
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request storage permission (Android)
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  /// Request draw over other apps permission (Android - for lock screen overlay)
  static Future<bool> requestSystemAlertWindow() async {
    if (Platform.isAndroid) {
      final status = await Permission.systemAlertWindow.request();
      return status.isGranted;
    }
    return true; // iOS uses CallKit instead
  }

  /// Request ignore battery optimization (Android)
  static Future<bool> requestIgnoreBatteryOptimization() async {
    if (Platform.isAndroid) {
      final status = await Permission.ignoreBatteryOptimizations.request();
      return status.isGranted;
    }
    return true;
  }

  /// Check if location permission is granted
  static Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Check if notification permission is granted
  static Future<bool> hasNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return status.isGranted;
    }
    return true;
  }

  /// Check if system alert window is granted
  static Future<bool> hasSystemAlertWindow() async {
    if (Platform.isAndroid) {
      final status = await Permission.systemAlertWindow.status;
      return status.isGranted;
    }
    return true;
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Show permission denied dialog
  static Future<void> showPermissionDeniedDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Request all required permissions
  static Future<Map<Permission, bool>> requestAllPermissions() async {
    final results = <Permission, bool>{};

    // Location
    results[Permission.location] = await requestLocationPermission();

    // Always location for background
    results[Permission.locationAlways] = await requestAlwaysLocationPermission();

    // Notifications
    results[Permission.notification] = await requestNotificationPermission();

    // System alert window (Android only)
    if (Platform.isAndroid) {
      results[Permission.systemAlertWindow] = await requestSystemAlertWindow();
    }

    return results;
  }
}
