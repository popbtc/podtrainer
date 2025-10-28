import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AvailablePodCard extends StatefulWidget {
  final Map<String, dynamic> podData;
  final VoidCallback? onConnect;
  final bool isConnecting;

  const AvailablePodCard({
    super.key,
    required this.podData,
    this.onConnect,
    this.isConnecting = false,
  });

  @override
  State<AvailablePodCard> createState() => _AvailablePodCardState();
}

class _AvailablePodCardState extends State<AvailablePodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isConnecting) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AvailablePodCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnecting && !oldWidget.isConnecting) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isConnecting && oldWidget.isConnecting) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String name = widget.podData['name'] as String? ?? 'Unknown Pod';
    final int signalStrength = widget.podData['signalStrength'] as int? ?? 0;
    final String deviceId = widget.podData['deviceId'] as String? ?? '';
    final bool isKnownDevice =
        widget.podData['isKnownDevice'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.isConnecting
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  widget.onConnect?.call();
                },
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Pod Icon with Animation
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: widget.isConnecting ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.isConnecting
                                ? colorScheme.primary
                                : colorScheme.outline.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: widget.isConnecting
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.primary,
                                    ),
                                  ),
                                )
                              : CustomIconWidget(
                                  iconName: 'bluetooth',
                                  color: colorScheme.primary,
                                  size: 24,
                                ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(width: 4.w),

                // Pod Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isKnownDevice)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Known',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 0.5.h),

                      Text(
                        deviceId.isNotEmpty
                            ? 'ID: $deviceId'
                            : 'Unknown Device ID',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      // Signal Strength
                      Row(
                        children: [
                          Text(
                            'Signal: ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
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

                SizedBox(width: 3.w),

                // Connect Button
                ElevatedButton(
                  onPressed: widget.isConnecting
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          widget.onConnect?.call();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isConnecting
                        ? colorScheme.outline.withValues(alpha: 0.3)
                        : colorScheme.primary,
                    foregroundColor: widget.isConnecting
                        ? colorScheme.onSurface.withValues(alpha: 0.6)
                        : colorScheme.onPrimary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.isConnecting ? 'Connecting...' : 'Connect',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignalBars(int strength, ColorScheme colorScheme) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = strength > (index * 25);
        return Container(
          width: 3,
          height: 6 + (index * 1.5),
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
}
