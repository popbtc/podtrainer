import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Navigation cards grid providing quick access to main sections
class NavigationCardsWidget extends StatelessWidget {
  const NavigationCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> navigationItems = [
      {
        'title': 'Training Hubs',
        'subtitle': 'Sessions & Sports',
        'icon': 'fitness_center',
        'route': '/training-hubs-main-screen',
        'color': theme.colorScheme.primary,
      },
      {
        'title': 'Pods',
        'subtitle': 'Manage Devices',
        'icon': 'bluetooth',
        'route': '/pods-management-screen',
        'color': theme.colorScheme.secondary,
      },
      {
        'title': 'Favorites',
        'subtitle': 'Saved Activities',
        'icon': 'favorite',
        'route': '/favorites-list-screen',
        'color': theme.colorScheme.tertiary,
      },
      {
        'title': 'Academy',
        'subtitle': 'Learn & Improve',
        'icon': 'school',
        'route': '/academy-content-screen',
        'color': theme.colorScheme.primary.withValues(alpha: 0.8),
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 1.2,
        ),
        itemCount: navigationItems.length,
        itemBuilder: (context, index) {
          final item = navigationItems[index];
          return _buildNavigationCard(context, item);
        },
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, item['route']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: item['icon'],
                    color: item['color'],
                    size: 6.w,
                  ),
                ),
              ),

              SizedBox(height: 1.5.h),

              // Title
              Text(
                item['title'],
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 0.5.h),

              // Subtitle
              Text(
                item['subtitle'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
