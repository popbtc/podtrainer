import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual favorite activity card widget
class FavoriteCardWidget extends StatelessWidget {
  const FavoriteCardWidget({
    super.key,
    required this.activity,
    required this.onRemove,
    required this.onStart,
    required this.onTap,
  });

  final Map<String, dynamic> activity;
  final VoidCallback onRemove;
  final VoidCallback onStart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activity thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: activity["thumbnail"] as String,
                        width: 20.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                        semanticLabel: activity["semanticLabel"] as String,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    // Activity details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  activity["title"] as String,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  _showRemoveConfirmation(context);
                                },
                                icon: CustomIconWidget(
                                  iconName: 'favorite',
                                  color: colorScheme.error,
                                  size: 20,
                                ),
                                tooltip: 'Remove from favorites',
                                constraints: BoxConstraints(
                                  minWidth: 8.w,
                                  minHeight: 8.w,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          // Category badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              activity["category"] as String,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Difficulty indicator
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'fitness_center',
                                color: _getDifficultyColor(
                                  activity["difficulty"] as String,
                                  colorScheme,
                                ),
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                activity["difficulty"] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _getDifficultyColor(
                                    activity["difficulty"] as String,
                                    colorScheme,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          if (activity["lastCompleted"] != null) ...[
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'schedule',
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  size: 14,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Last: ${activity["lastCompleted"]}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onTap();
                        },
                        icon: CustomIconWidget(
                          iconName: 'visibility',
                          color: colorScheme.primary,
                          size: 16,
                        ),
                        label: Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onStart();
                        },
                        icon: CustomIconWidget(
                          iconName: 'play_arrow',
                          color: colorScheme.onPrimary,
                          size: 16,
                        ),
                        label: Text('Start Training'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
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

  Color _getDifficultyColor(String difficulty, ColorScheme colorScheme) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return colorScheme.secondary;
      case 'intermediate':
        return colorScheme.tertiary;
      case 'advanced':
        return colorScheme.error;
      default:
        return colorScheme.onSurface;
    }
  }

  void _showRemoveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove from Favorites'),
        content: Text(
            'Are you sure you want to remove this activity from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRemove();
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }
}
