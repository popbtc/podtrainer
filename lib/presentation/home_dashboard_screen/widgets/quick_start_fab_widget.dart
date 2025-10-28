import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Floating Action Button for quick training start
class QuickStartFabWidget extends StatelessWidget {
  const QuickStartFabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      onPressed: () => _showQuickStartMenu(context),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4.0,
      icon: CustomIconWidget(
        iconName: 'play_arrow',
        color: theme.colorScheme.onPrimary,
        size: 6.w,
      ),
      label: Text(
        'Quick Start',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showQuickStartMenu(BuildContext context) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _QuickStartMenu(),
    );
  }
}

class _QuickStartMenu extends StatelessWidget {
  final List<Map<String, dynamic>> quickStartOptions = [
    {
      'title': 'Speed Training',
      'subtitle': 'Quick reaction drills',
      'icon': 'speed',
      'color': Colors.orange,
      'route': '/training-hubs-main-screen',
    },
    {
      'title': 'Agility Course',
      'subtitle': 'Multi-directional movement',
      'icon': 'directions_run',
      'color': Colors.green,
      'route': '/training-hubs-main-screen',
    },
    {
      'title': 'Reaction Time',
      'subtitle': 'Hand-eye coordination',
      'icon': 'touch_app',
      'color': Colors.blue,
      'route': '/training-hubs-main-screen',
    },
    {
      'title': 'Custom Session',
      'subtitle': 'Create your own workout',
      'icon': 'tune',
      'color': Colors.purple,
      'route': '/training-hubs-main-screen',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 10.w,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 2.h),

          // Title
          Text(
            'Quick Start Training',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Options
          ...quickStartOptions
              .map((option) => _buildQuickStartOption(context, option)),

          SizedBox(height: 2.h),

          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartOption(
      BuildContext context, Map<String, dynamic> option) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, option['route']);
        },
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: (option['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: option['icon'],
              color: option['color'],
              size: 6.w,
            ),
          ),
        ),
        title: Text(
          option['title'],
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          option['subtitle'],
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          size: 4.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: theme.colorScheme.surface,
      ),
    );
  }
}
