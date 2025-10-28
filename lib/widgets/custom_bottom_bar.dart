import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar implementing athletic minimalism design
/// Provides primary navigation with haptic feedback and clear visual hierarchy
enum CustomBottomBarVariant {
  /// Standard bottom navigation with 5 main tabs including favorites
  standard,

  /// Training-focused navigation with quick access to pods and favorites
  training,

  /// Extended navigation with 6 tabs including academy and favorites
  extended,
}

class CustomBottomBar extends StatelessWidget {
  /// Creates a custom bottom navigation bar with athletic design
  const CustomBottomBar({
    super.key,
    required this.variant,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showLabels = true,
  });

  /// The variant of the bottom bar to display
  final CustomBottomBarVariant variant;

  /// Currently selected tab index
  final int currentIndex;

  /// Callback when tab is tapped
  final ValueChanged<int> onTap;

  /// Background color override
  final Color? backgroundColor;

  /// Selected item color override
  final Color? selectedItemColor;

  /// Unselected item color override
  final Color? unselectedItemColor;

  /// Elevation override
  final double? elevation;

  /// Whether to show labels
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            HapticFeedback.lightImpact();
            _handleNavigation(context, index);
            onTap(index);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: selectedItemColor ?? colorScheme.primary,
          unselectedItemColor: unselectedItemColor ??
              colorScheme.onSurface.withValues(alpha: 0.6),
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          items: _buildNavigationItems(context),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems(BuildContext context) {
    switch (variant) {
      case CustomBottomBarVariant.standard:
        return [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home_outlined, Icons.home, 0),
            label: 'Home',
            tooltip: 'Home Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.favorite_outline, Icons.favorite, 1),
            label: 'Favorites',
            tooltip: 'Favorites List',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              Icons.fitness_center_outlined,
              Icons.fitness_center,
              2,
            ),
            label: 'Training',
            tooltip: 'Training Hubs',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.bluetooth_outlined, Icons.bluetooth, 3),
            label: 'Pods',
            tooltip: 'Pod Management',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.settings_outlined, Icons.settings, 4),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ];

      case CustomBottomBarVariant.training:
        return [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home_outlined, Icons.home, 0),
            label: 'Home',
            tooltip: 'Home Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.favorite_outline, Icons.favorite, 1),
            label: 'Favorites',
            tooltip: 'Favorites List',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              Icons.fitness_center_outlined,
              Icons.fitness_center,
              2,
            ),
            label: 'Training',
            tooltip: 'Training Hubs',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.analytics_outlined, Icons.analytics, 3),
            label: 'Activity',
            tooltip: 'Activity Details',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.bluetooth_outlined, Icons.bluetooth, 4),
            label: 'Pods',
            tooltip: 'Pod Management',
          ),
        ];

      case CustomBottomBarVariant.extended:
        return [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home_outlined, Icons.home, 0),
            label: 'Home',
            tooltip: 'Home Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.favorite_outline, Icons.favorite, 1),
            label: 'Favorites',
            tooltip: 'Favorites List',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              Icons.fitness_center_outlined,
              Icons.fitness_center,
              2,
            ),
            label: 'Training',
            tooltip: 'Training Hubs',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.bluetooth_outlined, Icons.bluetooth, 3),
            label: 'Pods',
            tooltip: 'Pod Management',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.settings_outlined, Icons.settings, 4),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ];
    }
  }

  Widget _buildIcon(IconData outlinedIcon, IconData filledIcon, int index) {
    final isSelected = currentIndex == index;

    return AnimatedScale(
      scale: isSelected ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(isSelected ? filledIcon : outlinedIcon, size: 24),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    String route;

    switch (variant) {
      case CustomBottomBarVariant.standard:
        switch (index) {
          case 0:
            route = '/home-dashboard-screen';
            break;
          case 1:
            route = '/favorites-list-screen';
            break;
          case 2:
            route = '/training-hubs-main-screen';
            break;
          case 3:
            route = '/pods-management-screen';
            break;
          case 4:
            route = '/settings-main-screen';
            break;
          default:
            return;
        }
        break;

      case CustomBottomBarVariant.training:
        switch (index) {
          case 0:
            route = '/home-dashboard-screen';
            break;
          case 1:
            route = '/favorites-list-screen';
            break;
          case 2:
            route = '/training-hubs-main-screen';
            break;
          case 3:
            route = '/activity-details-screen';
            break;
          case 4:
            route = '/pods-management-screen';
            break;
          default:
            return;
        }
        break;

      case CustomBottomBarVariant.extended:
        switch (index) {
          case 0:
            route = '/home-dashboard-screen';
            break;
          case 1:
            route = '/favorites-list-screen';
            break;
          case 2:
            route = '/training-hubs-main-screen';
            break;
          case 3:
            route = '/pods-management-screen';
            break;
          case 4:
            route = '/settings-main-screen';
            break;
          default:
            return;
        }
        break;
    }

    // Only navigate if not already on the target route
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }
}

/// Custom Bottom Bar Controller for managing state across the app
class CustomBottomBarController extends ChangeNotifier {
  int _currentIndex = 0;
  CustomBottomBarVariant _variant = CustomBottomBarVariant.standard;

  int get currentIndex => _currentIndex;
  CustomBottomBarVariant get variant => _variant;

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void setVariant(CustomBottomBarVariant variant) {
    if (_variant != variant) {
      _variant = variant;
      _currentIndex = 0; // Reset to first tab when variant changes
      notifyListeners();
    }
  }

  void reset() {
    _currentIndex = 0;
    _variant = CustomBottomBarVariant.standard;
    notifyListeners();
  }
}
