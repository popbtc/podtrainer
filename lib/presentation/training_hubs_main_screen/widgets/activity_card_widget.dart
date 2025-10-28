import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Activity card widget for displaying training activities
class ActivityCardWidget extends StatefulWidget {
  const ActivityCardWidget({
    super.key,
    required this.activity,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final Map<String, dynamic> activity;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  State<ActivityCardWidget> createState() => _ActivityCardWidgetState();
}

class _ActivityCardWidgetState extends State<ActivityCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(colorScheme),
                  _buildContentSection(theme, colorScheme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: CustomImageWidget(
            imageUrl: widget.activity['image'] as String,
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
            semanticLabel: widget.activity['semanticLabel'] as String,
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onFavoriteToggle();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: (widget.activity['isFavorite'] as bool)
                    ? 'favorite'
                    : 'favorite_border',
                color: (widget.activity['isFavorite'] as bool)
                    ? colorScheme.error
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
            ),
          ),
        ),
        if (widget.activity['isCompleted'] as bool)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: colorScheme.onSecondary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Completed',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.activity['title'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildDifficultyBadge(colorScheme),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            widget.activity['description'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                widget.activity['duration'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 16),
              CustomIconWidget(
                iconName: 'fitness_center',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.activity['equipment'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge(ColorScheme colorScheme) {
    final difficulty = widget.activity['difficulty'] as String;
    Color badgeColor;
    Color textColor;

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        badgeColor = colorScheme.secondary.withValues(alpha: 0.1);
        textColor = colorScheme.secondary;
        break;
      case 'intermediate':
        badgeColor = colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = colorScheme.tertiary;
        break;
      case 'advanced':
        badgeColor = colorScheme.error.withValues(alpha: 0.1);
        textColor = colorScheme.error;
        break;
      default:
        badgeColor = colorScheme.outline.withValues(alpha: 0.1);
        textColor = colorScheme.onSurface.withValues(alpha: 0.7);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
