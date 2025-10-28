import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Empty state widget when no favorites are found
class FavoritesEmptyStateWidget extends StatefulWidget {
  const FavoritesEmptyStateWidget({
    super.key,
    required this.onBrowseActivities,
    this.isSearching = false,
    this.searchQuery = '',
  });

  final VoidCallback onBrowseActivities;
  final bool isSearching;
  final String searchQuery;

  @override
  State<FavoritesEmptyStateWidget> createState() =>
      _FavoritesEmptyStateWidgetState();
}

class _FavoritesEmptyStateWidgetState extends State<FavoritesEmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _heartAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
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

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated heart icon
            AnimatedBuilder(
              animation: _heartAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _heartAnimation.value,
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: widget.isSearching
                            ? 'search_off'
                            : 'favorite_border',
                        color: colorScheme.primary,
                        size: 12.w,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 4.h),
            // Title
            Text(
              widget.isSearching ? 'No Results Found' : 'No Favorites Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Description
            Text(
              widget.isSearching
                  ? 'No favorites match "${widget.searchQuery}". Try adjusting your search or browse more activities.'
                  : 'Start building your collection of favorite training activities. Tap the heart icon on any activity to add it here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Action button
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.onBrowseActivities();
              },
              icon: CustomIconWidget(
                iconName: widget.isSearching ? 'refresh' : 'explore',
                color: colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                widget.isSearching ? 'Clear Search' : 'Browse Training Hubs',
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (!widget.isSearching) ...[
              SizedBox(height: 2.h),
              // Secondary action
              TextButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/training-hubs-main-screen');
                },
                icon: CustomIconWidget(
                  iconName: 'fitness_center',
                  color: colorScheme.primary,
                  size: 18,
                ),
                label: Text('View All Activities'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
