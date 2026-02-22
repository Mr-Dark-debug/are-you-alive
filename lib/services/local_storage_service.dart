import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';

/// Local storage service for caching data
class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // ============ Onboarding ============

  bool get hasSeenOnboarding =>
      _prefs.getBool(AppConstants.keyHasSeenOnboarding) ?? false;

  Future<void> setHasSeenOnboarding(bool value) =>
      _prefs.setBool(AppConstants.keyHasSeenOnboarding, value);

  bool get hasCompletedSetup =>
      _prefs.getBool(AppConstants.keyHasCompletedSetup) ?? false;

  Future<void> setHasCompletedSetup(bool value) =>
      _prefs.setBool(AppConstants.keyHasCompletedSetup, value);

  // ============ User Profile ============

  Future<bool> saveUserProfile(UserProfile profile) async {
    return await _prefs.setString(
      AppConstants.keyUserProfile,
      jsonEncode(profile.toJson()),
    );
  }

  UserProfile? getUserProfile() {
    final json = _prefs.getString(AppConstants.keyUserProfile);
    if (json == null) return null;
    try {
      return UserProfile.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUserProfile() async {
    await _prefs.remove(AppConstants.keyUserProfile);
  }

  // ============ Safety Settings ============

  Future<bool> saveSafetySettings(SafetySettings settings) async {
    return await _prefs.setString(
      AppConstants.keySafetySettings,
      jsonEncode(settings.toJson()),
    );
  }

  SafetySettings? getSafetySettings() {
    final json = _prefs.getString(AppConstants.keySafetySettings);
    if (json == null) return null;
    try {
      return SafetySettings.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  // ============ Check-in ============

  Future<void> setLastCheckIn(DateTime dateTime) async {
    await _prefs.setString(
      AppConstants.keyLastCheckIn,
      dateTime.toIso8601String(),
    );
  }

  DateTime? getLastCheckIn() {
    final str = _prefs.getString(AppConstants.keyLastCheckIn);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  // ============ Away Mode ============

  bool getAwayModeEnabled() =>
      _prefs.getBool(AppConstants.keyAwayModeEnabled) ?? false;

  Future<void> setAwayModeEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyAwayModeEnabled, value);

  DateTime? getAwayModeUntil() {
    final str = _prefs.getString(AppConstants.keyAwayModeUntil);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  Future<void> setAwayModeUntil(DateTime? dateTime) async {
    if (dateTime == null) {
      await _prefs.remove(AppConstants.keyAwayModeUntil);
    } else {
      await _prefs.setString(
        AppConstants.keyAwayModeUntil,
        dateTime.toIso8601String(),
      );
    }
  }

  // ============ Feature Flags ============

  bool getNotificationEnabled() =>
      _prefs.getBool(AppConstants.keyNotificationEnabled) ?? true;

  Future<void> setNotificationEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyNotificationEnabled, value);

  bool getLocationEnabled() =>
      _prefs.getBool(AppConstants.keyLocationEnabled) ?? true;

  Future<void> setLocationEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyLocationEnabled, value);

  bool getEnhancedSafetyEnabled() =>
      _prefs.getBool(AppConstants.keyEnhancedSafetyEnabled) ?? false;

  Future<void> setEnhancedSafetyEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyEnhancedSafetyEnabled, value);

  bool getDiscreetModeEnabled() =>
      _prefs.getBool(AppConstants.keyDiscreetModeEnabled) ?? false;

  Future<void> setDiscreetModeEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyDiscreetModeEnabled, value);

  // ============ Custom Values ============

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);

  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // ============ Clear Data ============

  Future<void> clearAll() => _prefs.clear();

  Future<void> remove(String key) => _prefs.remove(key);

  bool containsKey(String key) => _prefs.containsKey(key);
}

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

/// Provider for LocalStorageService
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
});
