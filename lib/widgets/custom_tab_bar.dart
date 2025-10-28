import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Tab Bar implementing athletic minimalism design
/// Provides secondary navigation with gesture-aware scrolling
enum CustomTabBarVariant {
  /// Standard tab bar with fixed tabs
  standard,

  /// Scrollable tab bar for many tabs
  scrollable,

  /// Segmented control style for binary choices
  segmented,

  /// Pills style with rounded backgrounds
  pills,
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a custom tab bar with athletic design
  const CustomTabBar({
    super.key,
    required this.variant,
    required this.tabs,
    this.controller,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable,
    this.padding,
    this.labelPadding,
  });

  /// The variant of the tab bar to display
  final CustomTabBarVariant variant;

  /// List of tab labels or widgets
  final List<String> tabs;

  /// Tab controller for managing state
  final TabController? controller;

  /// Callback when tab is tapped
  final ValueChanged<int>? onTap;

  /// Background color override
  final Color? backgroundColor;

  /// Selected tab color override
  final Color? selectedColor;

  /// Unselected tab color override
  final Color? unselectedColor;

  /// Indicator color override
  final Color? indicatorColor;

  /// Whether tabs should be scrollable
  final bool? isScrollable;

  /// Padding around the tab bar
  final EdgeInsetsGeometry? padding;

  /// Padding around each tab label
  final EdgeInsetsGeometry? labelPadding;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomTabBarVariant.segmented:
        return _buildSegmentedControl(context);
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context);
      default:
        return _buildStandardTabBar(context);
    }
  }

  Widget _buildStandardTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor ??
          theme.tabBarTheme.labelColor?.withValues(alpha: 0.05),
      padding: padding ?? EdgeInsets.zero,
      child: TabBar(
        controller: controller,
        onTap: (index) {
          HapticFeedback.lightImpact();
          onTap?.call(index);
        },
        isScrollable:
            isScrollable ?? (variant == CustomTabBarVariant.scrollable),
        labelColor: selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            unselectedColor ?? colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicatorWeight: 2.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelPadding:
            labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        tabs: tabs
            .map((tab) => Tab(
                  text: tab,
                  height: 48,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSegmentedControl(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: TabBar(
          controller: controller,
          onTap: (index) {
            HapticFeedback.lightImpact();
            onTap?.call(index);
          },
          indicator: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(2),
          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.7),
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          dividerColor: Colors.transparent,
          tabs: tabs
              .map((tab) => Tab(
                    text: tab,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPillsTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = controller?.index == index;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller?.animateTo(index);
                  onTap?.call(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tab,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Custom Tab Bar View for content display
class CustomTabBarView extends StatelessWidget {
  /// Creates a custom tab bar view with gesture-aware navigation
  const CustomTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
  });

  /// List of widgets to display in each tab
  final List<Widget> children;

  /// Tab controller for managing state
  final TabController? controller;

  /// Physics for page scrolling
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics ?? const BouncingScrollPhysics(),
      children: children,
    );
  }
}

/// Training-specific tab bar for workout sessions
class TrainingTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a training-focused tab bar
  const TrainingTabBar({
    super.key,
    required this.controller,
    this.onTap,
    this.connectionStatus,
  });

  /// Tab controller for managing training tabs
  final TabController controller;

  /// Callback when tab is tapped
  final ValueChanged<int>? onTap;

  /// Current connection status
  final String? connectionStatus;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (connectionStatus != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: connectionStatus == 'Connected'
                  ? colorScheme.secondary.withValues(alpha: 0.1)
                  : colorScheme.error.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: connectionStatus == 'Connected'
                          ? colorScheme.secondary
                          : colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    connectionStatus!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: connectionStatus == 'Connected'
                          ? colorScheme.secondary
                          : colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          TabBar(
            controller: controller,
            onTap: (index) {
              HapticFeedback.lightImpact();
              onTap?.call(index);
            },
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
            indicatorColor: colorScheme.primary,
            indicatorWeight: 3.0,
            labelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(text: 'Workout'),
              Tab(text: 'Progress'),
              Tab(text: 'History'),
            ],
          ),
        ],
      ),
    );
  }
}
