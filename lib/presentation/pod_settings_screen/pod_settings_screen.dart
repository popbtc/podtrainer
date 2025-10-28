import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/advanced_settings_widget.dart';
import './widgets/display_settings_widget.dart';
import './widgets/pod_header_widget.dart';
import './widgets/timing_settings_widget.dart';

class PodSettingsScreen extends StatefulWidget {
  const PodSettingsScreen({super.key});

  @override
  State<PodSettingsScreen> createState() => _PodSettingsScreenState();
}

class _PodSettingsScreenState extends State<PodSettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 3;

  // Pod Information
  final String _podName = "ProTrainer Pod #1";
  final String _connectionStatus = "Connected";
  final int _batteryLevel = 78;
  final String _signalStrength = "Good";
  final String _firmwareVersion = "v2.1.4";

  // Display Settings
  double _brightness = 0.7;
  Color _selectedColor = const Color(0xFF2196F3);
  double _intensity = 0.8;

  // Timing Settings
  double _reactionDelay = 1.2;
  int _sessionDuration = 15;
  int _autoShutoff = 10;

  // Advanced Settings
  bool _isCalibrating = false;
  bool _connectionLost = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _simulateConnectionCheck();
  }

  void _simulateConnectionCheck() {
    // Simulate periodic connection checks
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _connectionLost = DateTime.now().millisecondsSinceEpoch % 10 == 0;
        });
        _simulateConnectionCheck();
      }
    });
  }

  void _handleBrightnessChanged(double value) {
    setState(() {
      _brightness = value;
    });
    _applySettingToPod('brightness', value);
  }

  void _handleColorChanged(Color color) {
    setState(() {
      _selectedColor = color;
    });
    _applySettingToPod('color', color);
  }

  void _handleIntensityChanged(double value) {
    setState(() {
      _intensity = value;
    });
    _applySettingToPod('intensity', value);
  }

  void _handleReactionDelayChanged(double value) {
    setState(() {
      _reactionDelay = value;
    });
    _applySettingToPod('reactionDelay', value);
  }

  void _handleSessionDurationChanged(int value) {
    setState(() {
      _sessionDuration = value;
    });
    _applySettingToPod('sessionDuration', value);
  }

  void _handleAutoShutoffChanged(int value) {
    setState(() {
      _autoShutoff = value;
    });
    _applySettingToPod('autoShutoff', value);
  }

  void _applySettingToPod(String setting, dynamic value) {
    // Simulate applying setting to pod with haptic feedback
    HapticFeedback.lightImpact();

    // Show brief confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting updated successfully'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleStartCalibration() {
    setState(() {
      _isCalibrating = true;
    });

    // Simulate calibration process
    Future.delayed(const Duration(seconds: 45), () {
      if (mounted) {
        setState(() {
          _isCalibrating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pod calibration completed successfully'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    });
  }

  void _handleCheckFirmwareUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your pod is running the latest firmware'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleFactoryReset() {
    // Reset all settings to defaults
    setState(() {
      _brightness = 0.5;
      _selectedColor = const Color(0xFF2196F3);
      _intensity = 0.6;
      _reactionDelay = 1.0;
      _sessionDuration = 10;
      _autoShutoff = 5;
    });

    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pod has been reset to factory defaults'),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showReconnectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'bluetooth_disabled',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Connection Lost',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lost connection to $_podName. Settings will be cached and applied when reconnected.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Attempting to reconnect...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Go Back'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _connectionLost = false;
                });
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.settings,
        title: 'Pod Settings',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Pod Header
          PodHeaderWidget(
            podName: _podName,
            connectionStatus:
                _connectionLost ? "Disconnected" : _connectionStatus,
            batteryLevel: _batteryLevel,
            signalStrength: _signalStrength,
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Display'),
              Tab(text: 'Timing'),
              Tab(text: 'Advanced'),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Display Settings Tab
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: DisplaySettingsWidget(
                    podName: _podName,
                    brightness: _brightness,
                    selectedColor: _selectedColor,
                    intensity: _intensity,
                    onBrightnessChanged: _handleBrightnessChanged,
                    onColorChanged: _handleColorChanged,
                    onIntensityChanged: _handleIntensityChanged,
                  ),
                ),

                // Timing Settings Tab
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: TimingSettingsWidget(
                    reactionDelay: _reactionDelay,
                    sessionDuration: _sessionDuration,
                    autoShutoff: _autoShutoff,
                    onReactionDelayChanged: _handleReactionDelayChanged,
                    onSessionDurationChanged: _handleSessionDurationChanged,
                    onAutoShutoffChanged: _handleAutoShutoffChanged,
                  ),
                ),

                // Advanced Settings Tab
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: AdvancedSettingsWidget(
                    firmwareVersion: _firmwareVersion,
                    isCalibrating: _isCalibrating,
                    onStartCalibration: _handleStartCalibration,
                    onCheckFirmwareUpdate: _handleCheckFirmwareUpdate,
                    onFactoryReset: _handleFactoryReset,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.standard,
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }
}