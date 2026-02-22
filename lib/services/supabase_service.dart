import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Comprehensive Supabase service
class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ============ User Profile ============

  /// Get user by Clerk ID
  Future<UserProfile?> getUserByClerkId(String clerkId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('clerk_id', clerkId)
          .maybeSingle();

      if (response == null) return null;
      return UserProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Get user by ID
  Future<UserProfile?> getUserById(String userId) async {
    try {
      final response =
          await _client.from('users').select().eq('id', userId).maybeSingle();

      if (response == null) return null;
      return UserProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Create user profile
  Future<UserProfile> createUserProfile({
    required String clerkId,
    required String email,
    required String name,
    String phone = '',
    String gender = '',
  }) async {
    final now = DateTime.now();
    final response = await _client
        .from('users')
        .insert({
          'clerk_id': clerkId,
          'email': email,
          'name': name,
          'phone': phone,
          'gender': gender,
          'check_interval_hours': 24,
          'grace_period_seconds': 15,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        })
        .select()
        .single();

    return UserProfile.fromJson(response);
  }

  /// Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    await _client.from('users').update({
      'name': profile.name,
      'phone': profile.phone,
      'gender': profile.gender,
      'date_of_birth': profile.dateOfBirth.toIso8601String(),
      'check_interval_hours': profile.checkIntervalHours,
      'grace_period_seconds': profile.gracePeriodSeconds,
      'power_button_sos_enabled': profile.powerButtonSosEnabled,
      'walk_with_me_enabled': profile.walkWithMeEnabled,
      'fake_call_enabled': profile.fakeCallEnabled,
      'discreet_mode_enabled': profile.discreetModeEnabled,
      'away_mode_enabled': profile.awayModeEnabled,
      'away_mode_until': profile.awayModeUntil?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', profile.id);
  }

  /// Update last check-in
  Future<void> updateLastCheckIn(String userId) async {
    await _client.from('users').update({
      'last_check_in': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  // ============ Medical Info ============

  /// Get medical info for user
  Future<MedicalInfo?> getMedicalInfo(String userId) async {
    try {
      final response = await _client
          .from('medical_info')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return MedicalInfo.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Save medical info
  Future<void> saveMedicalInfo(MedicalInfo medicalInfo) async {
    await _client.from('medical_info').upsert({
      'user_id': medicalInfo.userId,
      'blood_group': medicalInfo.bloodGroup,
      'allergies': medicalInfo.allergies,
      'medications': medicalInfo.medications,
      'conditions': medicalInfo.conditions,
      'emergency_notes': medicalInfo.emergencyNotes,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // ============ Emergency Contacts ============

  /// Get all emergency contacts for user
  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    try {
      final response = await _client
          .from('emergency_contacts')
          .select()
          .eq('user_id', userId)
          .order('priority', ascending: true);

      return response.map<EmergencyContact>(EmergencyContact.fromJson).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add emergency contact
  Future<EmergencyContact> addEmergencyContact({
    required String userId,
    required String name,
    required String phone,
    String? email,
    required String relationship,
    int priority = 1,
  }) async {
    final response = await _client
        .from('emergency_contacts')
        .insert({
          'user_id': userId,
          'name': name,
          'phone': phone,
          'email': email,
          'relationship': relationship,
          'priority': priority,
          'is_verified': false,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return EmergencyContact.fromJson(response);
  }

  /// Update emergency contact
  Future<void> updateEmergencyContact(EmergencyContact contact) async {
    await _client.from('emergency_contacts').update({
      'name': contact.name,
      'phone': contact.phone,
      'email': contact.email,
      'relationship': contact.relationship,
      'priority': contact.priority,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', contact.id);
  }

  /// Delete emergency contact
  Future<void> deleteEmergencyContact(String contactId) async {
    await _client.from('emergency_contacts').delete().eq('id', contactId);
  }

  /// Verify emergency contact
  Future<void> verifyEmergencyContact(String contactId) async {
    await _client.from('emergency_contacts').update({
      'is_verified': true,
      'verified_at': DateTime.now().toIso8601String(),
    }).eq('id', contactId);
  }

  // ============ Check-ins ============

  /// Record a check-in
  Future<CheckIn> recordCheckIn({
    required String userId,
    double? latitude,
    double? longitude,
    String? address,
    bool isManual = true,
  }) async {
    final now = DateTime.now();
    final response = await _client
        .from('check_ins')
        .insert({
          'user_id': userId,
          'timestamp': now.toIso8601String(),
          'location_lat': latitude,
          'location_long': longitude,
          'location_address': address,
          'is_manual': isManual,
          'created_at': now.toIso8601String(),
        })
        .select()
        .single();

    // Also update user's last_check_in
    await updateLastCheckIn(userId);

    return CheckIn.fromJson(response);
  }

  /// Get recent check-ins
  Future<List<CheckIn>> getRecentCheckIns(String userId,
      {int limit = 10}) async {
    try {
      final response = await _client
          .from('check_ins')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false)
          .limit(limit);

      return response.map<CheckIn>(CheckIn.fromJson).toList();
    } catch (e) {
      return [];
    }
  }

  // ============ Alerts ============

  /// Create alert
  Future<Alert> createAlert({
    required String userId,
    required AlertType type,
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    final now = DateTime.now();
    final response = await _client
        .from('alerts')
        .insert({
          'user_id': userId,
          'type': type.name,
          'status': AlertStatus.triggered.name,
          'triggered_at': now.toIso8601String(),
          'location_lat': latitude,
          'location_long': longitude,
          'location_address': address,
          'created_at': now.toIso8601String(),
        })
        .select()
        .single();

    return Alert.fromJson(response);
  }

  /// Update alert status
  Future<void> updateAlertStatus(String alertId, AlertStatus status) async {
    final updates = <String, dynamic>{
      'status': status.name,
    };

    if (status == AlertStatus.cancelled) {
      updates['cancelled_at'] = DateTime.now().toIso8601String();
    } else if (status == AlertStatus.sent) {
      updates['sent_at'] = DateTime.now().toIso8601String();
    }

    await _client.from('alerts').update(updates).eq('id', alertId);
  }

  /// Get active alerts for user
  Future<List<Alert>> getActiveAlerts(String userId) async {
    try {
      final response = await _client
          .from('alerts')
          .select()
          .eq('user_id', userId)
          .inFilter('status', ['pending', 'countdown', 'triggered']).order(
              'created_at',
              ascending: false);

      return response.map<Alert>(Alert.fromJson).toList();
    } catch (e) {
      return [];
    }
  }

  // ============ Safety Settings ============

  /// Get safety settings
  Future<SafetySettings?> getSafetySettings(String userId) async {
    try {
      final response = await _client
          .from('safety_settings')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return SafetySettings.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Save safety settings
  Future<void> saveSafetySettings(SafetySettings settings) async {
    await _client.from('safety_settings').upsert({
      'user_id': settings.userId,
      'check_interval_hours': settings.checkIntervalHours,
      'grace_period_seconds': settings.gracePeriodSeconds,
      'power_button_sos_enabled': settings.powerButtonSosEnabled,
      'walk_with_me_enabled': settings.walkWithMeEnabled,
      'fake_call_enabled': settings.fakeCallEnabled,
      'discreet_mode_enabled': settings.discreetModeEnabled,
      'away_mode_enabled': settings.awayModeEnabled,
      'away_mode_until': settings.awayModeUntil?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // ============ Real-time Subscriptions ============

  /// Subscribe to check-ins changes
  RealtimeChannel subscribeToCheckIns(String userId, Function(CheckIn) onNew) {
    return _client
        .channel('check_ins:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'check_ins',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onNew(CheckIn.fromJson(payload.newRecord));
          },
        )
        .subscribe();
  }

  /// Subscribe to alerts changes
  RealtimeChannel subscribeToAlerts(String userId, Function(Alert) onChange) {
    return _client
        .channel('alerts:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'alerts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onChange(Alert.fromJson(payload.newRecord));
          },
        )
        .subscribe();
  }
}

/// Provider for Supabase service
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Provider for current user profile stream
final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  // This would need to be connected to actual auth state
  return Stream.value(null);
});
