import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/utils/date_formatters.dart';
import '../../services/location_service.dart';

/// Walk With Me Screen - Live location sharing during walks
class WalkWithMeScreen extends ConsumerStatefulWidget {
  const WalkWithMeScreen({super.key});

  @override
  ConsumerState<WalkWithMeScreen> createState() => _WalkWithMeScreenState();
}

class _WalkWithMeScreenState extends ConsumerState<WalkWithMeScreen> {
  final _destinationController = TextEditingController();
  final _minutesController = TextEditingController(text: '15');

  bool _isJourneyActive = false;
  LatLng? _currentLocation;

  DateTime? _estimatedArrival;
  Timer? _journeyTimer;
  int _elapsedSeconds = 0;

  final MapController _mapController = MapController();

  @override
  void dispose() {
    _destinationController.dispose();
    _minutesController.dispose();
    _journeyTimer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    final locationService = ref.read(locationServiceProvider);
    final location = await locationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        _currentLocation = LatLng(location.latitude, location.longitude);
      });
    }
  }

  void _startJourney() {
    if (_currentLocation == null) {
      _getCurrentLocation().then((_) {
        if (_currentLocation != null) {
          _beginJourney();
        }
      });
    } else {
      _beginJourney();
    }
  }

  void _beginJourney() {
    final minutes = int.tryParse(_minutesController.text) ?? 15;

    setState(() {
      _isJourneyActive = true;
      _estimatedArrival = DateTime.now().add(Duration(minutes: minutes));
      _elapsedSeconds = 0;
    });

    // Start timer
    _journeyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _elapsedSeconds++;
      });

      // Check if overdue
      if (_estimatedArrival != null &&
          DateTime.now().isAfter(_estimatedArrival!)) {
        _showOverdueWarning();
      }
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.directions_walk, color: AppColors.white),
            const SizedBox(width: 12),
            Text('Journey started! ETA: $minutes minutes'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showOverdueWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.white),
            SizedBox(width: 12),
            Text('You are past your estimated arrival time!'),
          ],
        ),
        backgroundColor: AppColors.warningColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'I\'m Safe',
          textColor: AppColors.black,
          onPressed: _endJourney,
        ),
      ),
    );
  }

  void _endJourney() {
    _journeyTimer?.cancel();

    setState(() {
      _isJourneyActive = false;
      _elapsedSeconds = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white),
            SizedBox(width: 12),
            Text('Journey completed safely!'),
          ],
        ),
        backgroundColor: AppColors.calmColor,
        behavior: SnackBarBehavior.floating,
      ),
    );

    context.pop();
  }

  void _triggerSos() {
    // Would trigger emergency alert
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Emergency SOS'),
        content: const Text(
          'This will immediately alert your emergency contacts with your current location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.criticalColor,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _endJourney();
              // Would trigger actual SOS
            },
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );
  }

  String _formatElapsedTime() {
    final mins = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk With Me'),
        actions: [
          if (_isJourneyActive)
            IconButton(
              icon: const Icon(Icons.sos, color: AppColors.criticalColor),
              onPressed: _triggerSos,
              tooltip: 'Emergency SOS',
            ),
        ],
      ),
      body: _isJourneyActive ? _buildActiveJourney() : _buildSetupForm(),
    );
  }

  Widget _buildSetupForm() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info card
          AppCard(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Your trusted contacts will be notified if you don\'t arrive on time.',
                    style: AppTextStyles.bodyMedium(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDesignTokens.spacing32),

          // Destination input
          Text(
            'Where are you going?',
            style: AppTextStyles.titleSmall(),
          ),
          const SizedBox(height: AppDesignTokens.spacing12),
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(
              labelText: 'Destination',
              hintText: 'Enter address or place name',
              prefixIcon: const Icon(Icons.place_outlined),
              suffixIcon: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _getCurrentLocation,
              ),
            ),
          ),

          const SizedBox(height: AppDesignTokens.spacing24),

          // Estimated time
          Text(
            'How long will it take?',
            style: AppTextStyles.titleSmall(),
          ),
          const SizedBox(height: AppDesignTokens.spacing12),
          TextField(
            controller: _minutesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Estimated Time (minutes)',
              prefixIcon: Icon(Icons.timer_outlined),
              suffix: Text('min'),
            ),
          ),

          const Spacer(),

          // Start button
          PrimaryButton(
            text: 'Start Journey',
            icon: Icons.directions_walk,
            onPressed: _startJourney,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveJourney() {
    final remainingTime = _estimatedArrival?.difference(DateTime.now());
    final isOverdue = remainingTime != null && remainingTime.isNegative;

    return Stack(
      children: [
        // Map view
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation ?? const LatLng(40.7128, -74.0060),
            initialZoom: 14,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.areyoualive.app',
            ),
            if (_currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation!,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),

        // Status overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(AppDesignTokens.spacing16),
            decoration: BoxDecoration(
              color: isOverdue ? AppColors.warningColor : AppColors.calmColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppDesignTokens.radius20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isOverdue ? 'OVERDUE' : 'On Time',
                            style: AppTextStyles.titleMedium(
                              color:
                                  isOverdue ? AppColors.black : AppColors.white,
                              weight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Elapsed: ${_formatElapsedTime()}',
                            style: AppTextStyles.bodySmall(
                              color: isOverdue
                                  ? AppColors.black.withValues(alpha: 0.7)
                                  : AppColors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            remainingTime != null && !remainingTime.isNegative
                                ? DateFormatters.formatDurationReadable(
                                    remainingTime,
                                  )
                                : 'Overdue',
                            style: AppTextStyles.headlineSmall(
                              color:
                                  isOverdue ? AppColors.black : AppColors.white,
                              weight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'remaining',
                            style: AppTextStyles.bodySmall(
                              color: isOverdue
                                  ? AppColors.black.withValues(alpha: 0.7)
                                  : AppColors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn().slideY(begin: -0.5),

        // Bottom action buttons
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(AppDesignTokens.spacing24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDesignTokens.radius24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'I\'m Safe',
                          onPressed: _endJourney,
                          icon: Icons.check_circle,
                        ),
                      ),
                      const SizedBox(width: AppDesignTokens.spacing16),
                      Expanded(
                        child: PrimaryButton(
                          text: 'SOS',
                          onPressed: _triggerSos,
                          backgroundColor: AppColors.criticalColor,
                          icon: Icons.warning,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn().slideY(begin: 0.5),
      ],
    );
  }
}
