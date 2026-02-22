import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import 'local_storage_service.dart';
import 'supabase_service.dart';

/// Background timer state
class TimerState {
  final DateTime? lastCheckIn;
  final int checkIntervalHours;
  final int gracePeriodSeconds;
  final bool awayModeEnabled;
  final DateTime? awayModeUntil;
  final bool isTimerExpired;

  const TimerState({
    this.lastCheckIn,
    this.checkIntervalHours = AppConstants.defaultCheckIntervalHours,
    this.gracePeriodSeconds = AppConstants.defaultGracePeriodSeconds,
    this.awayModeEnabled = false,
    this.awayModeUntil,
    this.isTimerExpired = false,
  });

  /// Get next check-in time
  DateTime get nextCheckIn {
    if (lastCheckIn == null) {
      return DateTime.now().add(Duration(hours: checkIntervalHours));
    }
    return lastCheckIn!.add(Duration(hours: checkIntervalHours));
  }

  /// Get time remaining
  Duration get timeRemaining {
    if (awayModeEnabled && awayModeUntil != null) {
      if (DateTime.now().isBefore(awayModeUntil!)) {
        return const Duration(days: 365); // Effectively infinite during away mode
      }
    }

    final remaining = nextCheckIn.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Check if check-in is overdue
  bool get isOverdue {
    if (awayModeEnabled && awayModeUntil != null) {
      if (DateTime.now().isBefore(awayModeUntil!)) {
        return false;
      }
    }
    return DateTime.now().isAfter(nextCheckIn);
  }

  /// Check if warning should be shown
  bool get shouldShowWarning {
    if (isOverdue) return false;
    final warningTime = nextCheckIn.subtract(
      const Duration(hours: AppConstants.defaultWarningHoursBefore),
    );
    return DateTime.now().isAfter(warningTime);
  }

  /// Copy with new values
  TimerState copyWith({
    DateTime? lastCheckIn,
    int? checkIntervalHours,
    int? gracePeriodSeconds,
    bool? awayModeEnabled,
    DateTime? awayModeUntil,
    bool? isTimerExpired,
  }) {
    return TimerState(
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      checkIntervalHours: checkIntervalHours ?? this.checkIntervalHours,
      gracePeriodSeconds: gracePeriodSeconds ?? this.gracePeriodSeconds,
      awayModeEnabled: awayModeEnabled ?? this.awayModeEnabled,
      awayModeUntil: awayModeUntil ?? this.awayModeUntil,
      isTimerExpired: isTimerExpired ?? this.isTimerExpired,
    );
  }
}

/// Background timer service
class BackgroundTimerService extends StateNotifier<TimerState> {
  final Ref _ref;
  Timer? _checkTimer;

  BackgroundTimerService(this._ref) : super(const TimerState()) {
    _loadState();
    _startPeriodicCheck();
  }

  Future<void> _loadState() async {
    final localStorage = _ref.read(localStorageServiceProvider);

    final lastCheckIn = localStorage.getLastCheckIn();
    final settings = localStorage.getSafetySettings();

    state = TimerState(
      lastCheckIn: lastCheckIn,
      checkIntervalHours: settings?.checkIntervalHours ?? AppConstants.defaultCheckIntervalHours,
      gracePeriodSeconds: settings?.gracePeriodSeconds ?? AppConstants.defaultGracePeriodSeconds,
      awayModeEnabled: localStorage.getAwayModeEnabled(),
      awayModeUntil: localStorage.getAwayModeUntil(),
    );
  }

  void _startPeriodicCheck() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkTimerExpired();
    });
  }

  void _checkTimerExpired() {
    if (state.isOverdue && !state.isTimerExpired) {
      state = state.copyWith(isTimerExpired: true);
      _onTimerExpired();
    }
  }

  void _onTimerExpired() {
    // This would trigger the alert screen via navigation
    // For now, we just update the state
    // The UI layer would listen to this and navigate
  }

  /// Record a check-in
  Future<void> recordCheckIn({
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    final now = DateTime.now();

    // Update local state
    state = state.copyWith(
      lastCheckIn: now,
      isTimerExpired: false,
    );

    // Save to local storage
    final localStorage = _ref.read(localStorageServiceProvider);
    await localStorage.setLastCheckIn(now);

    // Sync with Supabase
    try {
      final supabaseService = _ref.read(supabaseServiceProvider);
      await supabaseService.recordCheckIn(
        userId: '', // Would get from auth
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
    } catch (e) {
      // Handle error silently, local state is already updated
    }
  }

  /// Enable away mode
  Future<void> enableAwayMode(DateTime until) async {
    state = state.copyWith(
      awayModeEnabled: true,
      awayModeUntil: until,
    );

    final localStorage = _ref.read(localStorageServiceProvider);
    await localStorage.setAwayModeEnabled(true);
    await localStorage.setAwayModeUntil(until);
  }

  /// Disable away mode
  Future<void> disableAwayMode() async {
    state = state.copyWith(
      awayModeEnabled: false,
      awayModeUntil: null,
    );

    final localStorage = _ref.read(localStorageServiceProvider);
    await localStorage.setAwayModeEnabled(false);
    await localStorage.setAwayModeUntil(null);
  }

  /// Update timer settings
  Future<void> updateSettings({
    int? checkIntervalHours,
    int? gracePeriodSeconds,
  }) async {
    state = state.copyWith(
      checkIntervalHours: checkIntervalHours,
      gracePeriodSeconds: gracePeriodSeconds,
    );
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }
}

/// Provider for background timer service
final backgroundTimerProvider =
    StateNotifierProvider<BackgroundTimerService, TimerState>((ref) {
  return BackgroundTimerService(ref);
});

/// Background task callback for WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // This runs in background
    // Check if timer has expired and send notification if needed

    final prefs = await SharedPreferences.getInstance();
    final lastCheckInStr = prefs.getString(AppConstants.keyLastCheckIn);

    if (lastCheckInStr != null) {
      final lastCheckIn = DateTime.parse(lastCheckInStr);
      final checkInterval = prefs.getInt('check_interval_hours') ??
          AppConstants.defaultCheckIntervalHours;

      final nextCheckIn = lastCheckIn.add(Duration(hours: checkInterval));

      if (DateTime.now().isAfter(nextCheckIn)) {
        // Timer expired - would trigger local notification
        // This is handled by flutter_local_notifications
      }
    }

    return Future.value(true);
  });
}

/// Initialize background tasks
Future<void> initializeBackgroundTasks() async {
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // Register periodic task
  await Workmanager().registerPeriodicTask(
    AppConstants.workManagerTaskName,
    AppConstants.workManagerTaskName,
    frequency: AppConstants.backgroundCheckInterval,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}
