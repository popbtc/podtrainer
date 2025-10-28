import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Purposeful Athletic Minimalism design
/// Provides clean, function-first navigation with contextual actions
enum CustomAppBarVariant {
  /// Standard app bar with title and back button
  standard,

  /// Primary app bar variant for main screens
  primary,

  /// App bar with back button navigation
  withBackButton,

  /// Home app bar with profile and notifications
  home,

  /// Training app bar with connection status
  training,

  /// Settings app bar with save action
  settings,

  /// Search app bar with search functionality
  search,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a custom app bar with athletic minimalism design
  const CustomAppBar({
    super.key,
    required this.variant,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.connectionStatus,
    this.onSearchChanged,
    this.searchController,
    this.isSearchActive = false,
  });

  /// The variant of the app bar to display
  final CustomAppBarVariant variant;

  /// The title to display in the app bar
  final String? title;

  /// Whether to show the back button
  final bool showBackButton;

  /// Custom actions to display
  final List<Widget>? actions;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  /// Background color override
  final Color? backgroundColor;

  /// Foreground color override
  final Color? foregroundColor;

  /// Elevation override
  final double? elevation;

  /// Whether to center the title
  final bool centerTitle;

  /// Connection status for training variant
  final String? connectionStatus;

  /// Search callback for search variant
  final ValueChanged<String>? onSearchChanged;

  /// Search controller for search variant
  final TextEditingController? searchController;

  /// Whether search is currently active
  final bool isSearchActive;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? 2.0,
      centerTitle: centerTitle,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      leading: _buildLeading(context),
      title: _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!showBackButton) return null;

    switch (variant) {
      case CustomAppBarVariant.home:
        return IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () =>
              Navigator.pushNamed(context, '/profile-management-screen'),
          tooltip: 'Profile',
        );
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.withBackButton:
      case CustomAppBarVariant.standard:
      default:
        return IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: onBackPressed ?? () => Navigator.pop(context),
          tooltip: 'Back',
        );
    }
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.search:
        if (isSearchActive) {
          return TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
          );
        }
        return Text(
          title ?? 'Search',
          style: theme.appBarTheme.titleTextStyle,
        );

      case CustomAppBarVariant.training:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? 'Training',
              style: theme.appBarTheme.titleTextStyle,
            ),
            if (connectionStatus != null) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: connectionStatus == 'Connected'
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    connectionStatus!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );

      default:
        return title != null
            ? Text(
                title!,
                style: theme.appBarTheme.titleTextStyle,
              )
            : null;
    }
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final defaultActions = <Widget>[];

    switch (variant) {
      case CustomAppBarVariant.home:
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () =>
                Navigator.pushNamed(context, '/favorites-list-screen'),
            tooltip: 'Favorites',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
              HapticFeedback.lightImpact();
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-main-screen'),
            tooltip: 'Settings',
          ),
        ]);
        break;

      case CustomAppBarVariant.training:
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () =>
                Navigator.pushNamed(context, '/pods-management-screen'),
            tooltip: 'Pod Management',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showTrainingMenu(context);
            },
            tooltip: 'More options',
          ),
        ]);
        break;

      case CustomAppBarVariant.settings:
        defaultActions.add(
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        );
        break;

      case CustomAppBarVariant.search:
        if (isSearchActive) {
          defaultActions.add(
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController?.clear();
                onSearchChanged?.call('');
              },
              tooltip: 'Clear search',
            ),
          );
        } else {
          defaultActions.add(
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Activate search
                HapticFeedback.lightImpact();
              },
              tooltip: 'Search',
            ),
          );
        }
        break;

      default:
        break;
    }

    // Add custom actions if provided
    if (actions != null) {
      defaultActions.addAll(actions!);
    }

    return defaultActions.isNotEmpty ? defaultActions : null;
  }

  void _showTrainingMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pod Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pod-settings-screen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Academy Content'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/academy-content-screen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Activity Details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/activity-details-screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
