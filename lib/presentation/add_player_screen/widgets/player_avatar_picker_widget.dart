import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlayerAvatarPickerWidget extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback onTap;

  const PlayerAvatarPickerWidget({
    super.key,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withAlpha(77),
              width: 2,
            ),
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
          ),
          child: Stack(
            children: [
              // Avatar or Placeholder
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: avatarUrl != null
                      ? CustomImageWidget(
                          imageUrl: avatarUrl!,
                          fit: BoxFit.cover,
                          semanticLabel: 'Selected player avatar',
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'person',
                              size: 60,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withAlpha(128),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Add Photo',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withAlpha(179),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // Camera Icon Overlay
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'camera_alt',
                    size: 18,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}