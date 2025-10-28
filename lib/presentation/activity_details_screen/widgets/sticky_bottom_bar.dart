import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class StickyBottomBar extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onStartTraining;
  final VoidCallback onToggleFavorite;
  final bool canStartTraining;

  const StickyBottomBar({
    super.key,
    required this.isFavorite,
    required this.onStartTraining,
    required this.onToggleFavorite,
    required this.canStartTraining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isFavorite
                      ? theme.colorScheme.error.withValues(alpha: 0.1)
                      : theme.colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFavorite
                        ? theme.colorScheme.error.withValues(alpha: 0.3)
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onToggleFavorite();
                  },
                  icon: CustomIconWidget(
                    iconName: isFavorite ? 'favorite' : 'favorite_border',
                    color: isFavorite
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 24,
                  ),
                  tooltip:
                      isFavorite ? 'Remove from favorites' : 'Add to favorites',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: canStartTraining
                      ? () {
                          HapticFeedback.mediumImpact();
                          onStartTraining();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canStartTraining
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    foregroundColor: canStartTraining
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    padding: EdgeInsets.symmetric(vertical: 4.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: canStartTraining ? 2 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: canStartTraining
                            ? 'play_arrow'
                            : 'bluetooth_disabled',
                        color: canStartTraining
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        canStartTraining
                            ? 'Start Training'
                            : 'Connect Pods First',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: canStartTraining
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
