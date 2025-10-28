import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PodHeaderWidget extends StatelessWidget {
  final String podName;
  final String connectionStatus;
  final int batteryLevel;
  final String signalStrength;

  const PodHeaderWidget({
    super.key,
    required this.podName,
    required this.connectionStatus,
    required this.batteryLevel,
    required this.signalStrength,
  });

  Color _getConnectionColor(BuildContext context) {
    switch (connectionStatus.toLowerCase()) {
      case 'connected':
        return Theme.of(context).colorScheme.secondary;
      case 'connecting':
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Theme.of(context).colorScheme.error;
    }
  }

  String _getConnectionIcon() {
    switch (connectionStatus.toLowerCase()) {
      case 'connected':
        return 'check_circle';
      case 'connecting':
        return 'sync';
      default:
        return 'error';
    }
  }

  Color _getBatteryColor(BuildContext context) {
    if (batteryLevel > 50) {
      return Theme.of(context).colorScheme.secondary;
    } else if (batteryLevel > 20) {
      return Theme.of(context).colorScheme.tertiary;
    } else {
      return Theme.of(context).colorScheme.error;
    }
  }

  String _getBatteryIcon() {
    if (batteryLevel > 75) {
      return 'battery_full';
    } else if (batteryLevel > 50) {
      return 'battery_3_bar';
    } else if (batteryLevel > 25) {
      return 'battery_2_bar';
    } else if (batteryLevel > 10) {
      return 'battery_1_bar';
    } else {
      return 'battery_0_bar';
    }
  }

  int _getSignalBars() {
    switch (signalStrength.toLowerCase()) {
      case 'excellent':
        return 4;
      case 'good':
        return 3;
      case 'fair':
        return 2;
      case 'poor':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectionColor = _getConnectionColor(context);
    final batteryColor = _getBatteryColor(context);
    final signalBars = _getSignalBars();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Pod Name and Icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'bluetooth',
                  color: theme.colorScheme.onPrimary,
                  size: 28,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      podName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Training Pod',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Status Indicators
          Row(
            children: [
              // Connection Status
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: _getConnectionIcon(),
                            color: connectionColor,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            connectionStatus,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: connectionColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Status',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Battery Level
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: _getBatteryIcon(),
                            color: batteryColor,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '$batteryLevel%',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: batteryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Battery',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Signal Strength
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: List.generate(4, (index) {
                              return Container(
                                width: 1.w,
                                height: (index + 1) * 0.8.h,
                                margin: EdgeInsets.only(right: 0.5.w),
                                decoration: BoxDecoration(
                                  color: index < signalBars
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            signalStrength,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Signal',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
