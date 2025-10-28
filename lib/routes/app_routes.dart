import 'package:flutter/material.dart';
import '../presentation/pod_settings_screen/pod_settings_screen.dart';
import '../presentation/favorites_list_screen/favorites_list_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/profile_management_screen/profile_management_screen.dart';
import '../presentation/activity_details_screen/activity_details_screen.dart';
import '../presentation/pods_management_screen/pods_management_screen.dart';
import '../presentation/academy_content_screen/academy_content_screen.dart';
import '../presentation/training_hubs_main_screen/training_hubs_main_screen.dart';
import '../presentation/settings_main_screen/settings_main_screen.dart';
import '../presentation/home_dashboard_screen/home_dashboard_screen.dart';
import '../presentation/player_management_screen/player_management_screen.dart';
import '../presentation/add_player_screen/add_player_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String podSettings = '/pod-settings-screen';
  static const String favoritesList = '/favorites-list-screen';
  static const String splash = '/splash-screen';
  static const String profileManagement = '/profile-management-screen';
  static const String activityDetails = '/activity-details-screen';
  static const String podsManagement = '/pods-management-screen';
  static const String academyContent = '/academy-content-screen';
  static const String trainingHubsMain = '/training-hubs-main-screen';
  static const String settingsMain = '/settings-main-screen';
  static const String homeDashboard = '/home-dashboard-screen';
  static const String playerManagement = '/player-management-screen';
  static const String addPlayer = '/add-player-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeDashboardScreen(),
    podSettings: (context) => const PodSettingsScreen(),
    favoritesList: (context) => const FavoritesListScreen(),
    splash: (context) => const SplashScreen(),
    profileManagement: (context) => const ProfileManagementScreen(),
    activityDetails: (context) => const ActivityDetailsScreen(),
    podsManagement: (context) => const PodsManagementScreen(),
    academyContent: (context) => const AcademyContentScreen(),
    trainingHubsMain: (context) => const TrainingHubsMainScreen(),
    settingsMain: (context) => const SettingsMainScreen(),
    homeDashboard: (context) => const HomeDashboardScreen(),
    playerManagement: (context) => const PlayerManagementScreen(),
    addPlayer: (context) => const AddPlayerScreen(),
    // TODO: Add your other routes here
  };
}
