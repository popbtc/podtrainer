import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlayerCardWidget extends StatelessWidget {
  final Map<String, dynamic> player;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlayerCardWidget({
    super.key,
    required this.player,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = player['isActive'] as bool? ?? false;
    final podAssigned = player['podAssigned'] as String?;
    final trainingCount = player['trainingCount'] as int? ?? 0;

    return Dismissible(
      key: Key(player['id'].toString()),
      background: _buildSwipeBackground(context, false),
      secondaryBackground: _buildSwipeBackground(context, true),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onEdit();
        }
        return false; // Prevent auto dismiss
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withAlpha(51),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Main Content Row
            Row(
              children: [
                // Avatar with Status Indicator
                Stack(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? theme.colorScheme.primary.withAlpha(77)
                              : theme.colorScheme.outline.withAlpha(77),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomImageWidget(
                          imageUrl: player['avatar'] ?? '',
                          fit: BoxFit.cover,
                          semanticLabel:
                              player['semanticLabel'] ?? 'Player avatar',
                        ),
                      ),
                    ),
                    // Status Indicator
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.green
                              : theme.colorScheme.outline,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 3.w),

                // Player Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Age
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              player['name'] ?? '',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${player['age'] ?? 0} yrs',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 0.5.h),

                      // Sport and Pod Status
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: _getSportIcon(player['sport'] ?? ''),
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            player['sport'] ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (podAssigned != null) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.3.h,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'radio_button_checked',
                                    size: 12,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    podAssigned,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 0.5.h),

                      // Last Training and Stats
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatLastTraining(player['lastTraining'] ?? ''),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$trainingCount sessions',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                // Action Buttons
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onEdit();
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'edit',
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onDelete();
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer.withAlpha(77),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'delete',
                          size: 18,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, bool isDelete) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: isDelete
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: isDelete ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isDelete ? 'delete' : 'edit',
            size: 32,
            color: isDelete
                ? theme.colorScheme.onErrorContainer
                : theme.colorScheme.onPrimaryContainer,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isDelete ? 'Delete' : 'Edit',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDelete
                  ? theme.colorScheme.onErrorContainer
                  : theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'soccer':
        return 'sports_soccer';
      case 'basketball':
        return 'sports_basketball';
      case 'tennis':
        return 'sports_tennis';
      case 'running':
        return 'directions_run';
      case 'swimming':
        return 'pool';
      case 'baseball':
        return 'sports_baseball';
      case 'football':
        return 'sports_football';
      default:
        return 'sports';
    }
  }

  String _formatLastTraining(String lastTraining) {
    if (lastTraining.isEmpty) return 'Never';

    try {
      final date = DateTime.parse(lastTraining);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '$difference days ago';
      } else {
        return '${difference ~/ 7} weeks ago';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }
}