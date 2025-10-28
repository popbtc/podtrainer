import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ConnectedPodCard extends StatelessWidget {
  final Map<String, dynamic> podData;
  final VoidCallback? onDisconnect;
  final VoidCallback? onSettings;
  final VoidCallback? onRename;
  final VoidCallback? onForget;

  const ConnectedPodCard({
    super.key,
    required this.podData,
    this.onDisconnect,
    this.onSettings,
    this.onRename,
    this.onForget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String name = podData['name'] as String? ?? 'Unknown Pod';
    final int signalStrength = podData['signalStrength'] as int? ?? 0;
    final int batteryLevel = podData['batteryLevel'] as int? ?? 0;
    final String status = podData['status'] as String? ?? 'disconnected';
    final String podId = podData['id'] as String? ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onLongPress: () => _showContextMenu(context),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Status LED Indicator
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                _getStatusColor(status).withValues(alpha: 0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    // Pod Name
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Settings Button
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onSettings?.call();
                      },
                      icon: CustomIconWidget(
                        iconName: 'settings',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      tooltip: 'Pod Settings',
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Pod Details Row
                Row(
                  children: [
                    // Signal Strength
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Signal',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              _buildSignalBars(signalStrength, colorScheme),
                              SizedBox(width: 2.w),
                              Text(
                                '${signalStrength}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Battery Level
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Battery',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: _getBatteryIcon(batteryLevel),
                                color:
                                    _getBatteryColor(batteryLevel, colorScheme),
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${batteryLevel}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: _getBatteryColor(
                                      batteryLevel, colorScheme),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Disconnect Button
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showDisconnectDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Disconnect',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onError,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return Colors.green;
      case 'connecting':
        return Colors.orange;
      case 'disconnected':
      default:
        return Colors.red;
    }
  }

  Widget _buildSignalBars(int strength, ColorScheme colorScheme) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = strength > (index * 25);
        return Container(
          width: 3,
          height: 8 + (index * 2.0),
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: isActive
                ? (strength > 75
                    ? Colors.green
                    : strength > 50
                        ? Colors.orange
                        : Colors.red)
                : colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  String _getBatteryIcon(int level) {
    if (level > 75) return 'battery_full';
    if (level > 50) return 'battery_6_bar';
    if (level > 25) return 'battery_3_bar';
    if (level > 10) return 'battery_1_bar';
    return 'battery_alert';
  }

  Color _getBatteryColor(int level, ColorScheme colorScheme) {
    if (level > 25) return colorScheme.secondary;
    if (level > 10) return Colors.orange;
    return colorScheme.error;
  }

  void _showDisconnectDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Disconnect Pod',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to disconnect from ${podData['name']}?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              onDisconnect?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: Text(
              'Disconnect',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              podData['name'] as String? ?? 'Pod Options',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Rename Pod'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                onRename?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Pod Settings'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                onSettings?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bluetooth_disabled',
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: const Text('Disconnect'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                _showDisconnectDialog(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete_forever',
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: const Text('Forget Device'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.mediumImpact();
                onForget?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
