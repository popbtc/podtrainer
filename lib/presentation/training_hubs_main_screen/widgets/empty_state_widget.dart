import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Empty state widget for when no activities are found
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.category,
    required this.onBrowseOtherCategories,
  });

  final String category;
  final VoidCallback onBrowseOtherCategories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: _getIconForCategory(category),
                color: colorScheme.primary,
                size: 15.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'No ${category.toLowerCase()} found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              _getDescriptionForCategory(category),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: onBrowseOtherCategories,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
              ),
              child: Text(
                'Browse Other Categories',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'sessions':
        return 'fitness_center';
      case 'sports':
        return 'sports_soccer';
      case 'body parts':
        return 'accessibility_new';
      default:
        return 'search_off';
    }
  }

  String _getDescriptionForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'sessions':
        return 'No training sessions match your current filters. Try adjusting your search criteria or explore other categories.';
      case 'sports':
        return 'No sports activities available right now. Check back later or browse sessions and body parts for more options.';
      case 'body parts':
        return 'No body part specific workouts found. Try different filters or explore our sessions and sports categories.';
      default:
        return 'No activities match your search. Try different keywords or browse other categories.';
    }
  }
}
