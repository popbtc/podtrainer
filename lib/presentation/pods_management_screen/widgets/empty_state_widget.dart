import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum EmptyStateType {
  noPodsFound,
  bluetoothDisabled,
  permissionDenied,
  scanningTimeout,
}

class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;

  const EmptyStateWidget({
    super.key,
    required this.type,
    this.onRetry,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getIcon(),
                color: colorScheme.primary.withValues(alpha: 0.6),
                size: 60,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            _getTitle(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            _getDescription(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Action Buttons
          ..._buildActionButtons(context),
        ],
      ),
    );
  }

  String _getIcon() {
    switch (type) {
      case EmptyStateType.noPodsFound:
        return 'bluetooth_searching';
      case EmptyStateType.bluetoothDisabled:
        return 'bluetooth_disabled';
      case EmptyStateType.permissionDenied:
        return 'block';
      case EmptyStateType.scanningTimeout:
        return 'timer_off';
    }
  }

  String _getTitle() {
    switch (type) {
      case EmptyStateType.noPodsFound:
        return 'No Pods Found';
      case EmptyStateType.bluetoothDisabled:
        return 'Bluetooth Disabled';
      case EmptyStateType.permissionDenied:
        return 'Permission Required';
      case EmptyStateType.scanningTimeout:
        return 'Scan Timeout';
    }
  }

  String _getDescription() {
    switch (type) {
      case EmptyStateType.noPodsFound:
        return 'No training pods were found nearby. Make sure your pods are powered on and in pairing mode, then try scanning again.';
      case EmptyStateType.bluetoothDisabled:
        return 'Bluetooth is currently disabled on your device. Please enable Bluetooth to connect to training pods.';
      case EmptyStateType.permissionDenied:
        return 'PodTrainer needs Bluetooth permission to discover and connect to training pods. Please grant permission in settings.';
      case EmptyStateType.scanningTimeout:
        return 'Scanning timed out after 30 seconds. Make sure your pods are nearby and powered on, then try again.';
    }
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (type) {
      case EmptyStateType.noPodsFound:
        return [
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: colorScheme.onPrimary,
              size: 20,
            ),
            label: const Text('Scan Again'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            ),
          ),
          SizedBox(height: 2.h),
          OutlinedButton.icon(
            onPressed: () => _showTroubleshootingTips(context),
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: colorScheme.primary,
              size: 20,
            ),
            label: const Text('Troubleshooting Tips'),
          ),
        ];

      case EmptyStateType.bluetoothDisabled:
        return [
          ElevatedButton.icon(
            onPressed: onOpenSettings,
            icon: CustomIconWidget(
              iconName: 'bluetooth',
              color: colorScheme.onPrimary,
              size: 20,
            ),
            label: const Text('Enable Bluetooth'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            ),
          ),
        ];

      case EmptyStateType.permissionDenied:
        return [
          ElevatedButton.icon(
            onPressed: onOpenSettings,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: colorScheme.onPrimary,
              size: 20,
            ),
            label: const Text('Open Settings'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            ),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: onRetry,
            child: const Text('Try Again'),
          ),
        ];

      case EmptyStateType.scanningTimeout:
        return [
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: colorScheme.onPrimary,
              size: 20,
            ),
            label: const Text('Retry Scan'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            ),
          ),
          SizedBox(height: 2.h),
          OutlinedButton.icon(
            onPressed: () => _showTroubleshootingTips(context),
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: colorScheme.primary,
              size: 20,
            ),
            label: const Text('Need Help?'),
          ),
        ];
    }
  }

  void _showTroubleshootingTips(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: EdgeInsets.only(bottom: 3.h),
              alignment: Alignment.center,
            ),
            Text(
              'Troubleshooting Tips',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildTipItem(
              context,
              icon: 'power_settings_new',
              title: 'Check Pod Power',
              description:
                  'Ensure your training pods are powered on and have sufficient battery.',
            ),
            _buildTipItem(
              context,
              icon: 'bluetooth',
              title: 'Pairing Mode',
              description:
                  'Put your pods in pairing mode by holding the power button for 3 seconds.',
            ),
            _buildTipItem(
              context,
              icon: 'location_on',
              title: 'Distance',
              description:
                  'Move closer to your pods. Bluetooth range is typically 10-30 feet.',
            ),
            _buildTipItem(
              context,
              icon: 'refresh',
              title: 'Restart Bluetooth',
              description:
                  'Turn Bluetooth off and on again in your device settings.',
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got It'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
