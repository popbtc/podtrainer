import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SettingsItemType {
  navigation,
  toggle,
  value,
  action,
}

class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({
    super.key,
    required this.title,
    required this.type,
    this.subtitle,
    this.iconName,
    this.trailing,
    this.value,
    this.onTap,
    this.onToggle,
    this.isFirst = false,
    this.isLast = false,
    this.showBadge = false,
    this.badgeText,
  });

  final String title;
  final String? subtitle;
  final String? iconName;
  final SettingsItemType type;
  final Widget? trailing;
  final String? value;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggle;
  final bool isFirst;
  final bool isLast;
  final bool showBadge;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: type == SettingsItemType.toggle
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap?.call();
              },
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(12) : Radius.zero,
          bottom: isLast ? const Radius.circular(12) : Radius.zero,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            border: !isLast
                ? Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              if (iconName != null) ...[
                CustomIconWidget(
                  iconName: iconName!,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (showBadge && badgeText != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              badgeText!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onError,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              _buildTrailing(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case SettingsItemType.navigation:
        return CustomIconWidget(
          iconName: 'chevron_right',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          size: 20,
        );

      case SettingsItemType.toggle:
        return Switch(
          value: value == 'true',
          onChanged: (bool newValue) {
            HapticFeedback.lightImpact();
            onToggle?.call(newValue);
          },
        );

      case SettingsItemType.value:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null)
              Text(
                value!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        );

      case SettingsItemType.action:
        return trailing ?? const SizedBox.shrink();
    }
  }
}
