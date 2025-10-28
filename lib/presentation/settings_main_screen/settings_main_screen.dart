import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/coming_soon_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({super.key});

  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  int _currentBottomIndex = 4;

  // Mock trainer data (Alex Rodriguez is now a trainer)
  final Map<String, dynamic> _trainerData = {
    "name": "Alex Rodriguez",
    "email": "alex.rodriguez@podtrainer.com",
    "avatar": "https://images.unsplash.com/photo-1616064987986-e339fa40da32",
    "role": "Trainer",
    "semanticLabel":
        "Professional headshot of a young Hispanic man with short dark hair wearing a navy blue athletic shirt, smiling at camera against white background"
  };

  // Mock settings data
  final List<Map<String, dynamic>> _podSettings = [
    {
      "title": "Brightness Control",
      "subtitle": "Adjust pod LED brightness",
      "icon": "brightness_6",
      "value": "75%",
      "route": "/pod-settings-screen"
    },
    {
      "title": "Color Customization",
      "subtitle": "Change pod colors and themes",
      "icon": "palette",
      "value": "Blue Theme",
      "route": "/pod-settings-screen"
    },
    {
      "title": "Timing Adjustments",
      "subtitle": "Configure reaction timing",
      "icon": "timer",
      "value": "Standard",
      "route": "/pod-settings-screen"
    },
  ];

  final List<Map<String, dynamic>> _academyContent = [
    {
      "title": "Training Videos",
      "subtitle": "Watch expert training sessions",
      "icon": "play_circle",
      "badge": "3 New",
      "route": "/academy-content-screen"
    },
    {
      "title": "Training Articles",
      "subtitle": "Read latest training tips",
      "icon": "article",
      "badge": "5 New",
      "route": "/academy-content-screen"
    },
  ];

  // Player Management Section
  final List<Map<String, dynamic>> _playerManagement = [
    {
      "title": "Manage Players",
      "subtitle": "Add and manage training players",
      "icon": "groups",
      "route": "/player-management-screen"
    },
  ];

  final List<Map<String, dynamic>> _supportItems = [
    {
      "title": "FAQ",
      "subtitle": "Frequently asked questions",
      "icon": "help",
      "route": "/academy-content-screen"
    },
    {
      "title": "Contact Support",
      "subtitle": "Get help from our team",
      "icon": "support_agent",
      "badge": "2",
      "route": "/academy-content-screen"
    },
  ];

  void _handleThemeToggle(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme changed to ${value ? 'Dark' : 'Light'} mode'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleNotificationToggle(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifications ${value ? 'enabled' : 'disabled'}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLanguageSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ...['English', 'Spanish', 'French', 'German'].map(
              (language) => ListTile(
                title: Text(language),
                trailing: _selectedLanguage == language
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleAvatarTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Change Profile Photo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Camera feature will be available soon'),
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gallery feature will be available soon'),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        variant: CustomAppBarVariant.settings,
        title: 'Settings',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 1.h),

            // Profile Header (keeping at top)
            ProfileHeaderWidget(
              name: _trainerData["name"] as String,
              email: _trainerData["email"] as String,
              avatarUrl: _trainerData["avatar"] as String,
              onAvatarTap: _handleAvatarTap,
              onEditTap: () {
                Navigator.pushNamed(context, '/profile-management-screen');
              },
            ),

            SizedBox(height: 2.h),

            // Player Management Section (moved to first position)
            SettingsSectionWidget(
              title: 'PLAYER MANAGEMENT',
              children: _playerManagement.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return SettingsItemWidget(
                  title: item["title"] as String,
                  subtitle: item["subtitle"] as String,
                  iconName: item["icon"] as String,
                  type: SettingsItemType.navigation,
                  isFirst: index == 0,
                  isLast: index == _playerManagement.length - 1,
                  onTap: () {
                    Navigator.pushNamed(context, item["route"] as String);
                  },
                );
              }).toList(),
            ),

            // Pod Settings Section (moved to second position)
            SettingsSectionWidget(
              title: 'POD SETTINGS',
              children: _podSettings.asMap().entries.map((entry) {
                final index = entry.key;
                final setting = entry.value;
                return SettingsItemWidget(
                  title: setting["title"] as String,
                  subtitle: setting["subtitle"] as String,
                  iconName: setting["icon"] as String,
                  type: SettingsItemType.value,
                  value: setting["value"] as String,
                  isFirst: index == 0,
                  isLast: index == _podSettings.length - 1,
                  onTap: () {
                    Navigator.pushNamed(context, setting["route"] as String);
                  },
                );
              }).toList(),
            ),

            // Academy Section (moved to third position)
            SettingsSectionWidget(
              title: 'ACADEMY',
              children: _academyContent.asMap().entries.map((entry) {
                final index = entry.key;
                final content = entry.value;
                return SettingsItemWidget(
                  title: content["title"] as String,
                  subtitle: content["subtitle"] as String,
                  iconName: content["icon"] as String,
                  type: SettingsItemType.navigation,
                  isFirst: index == 0,
                  isLast: index == _academyContent.length - 1,
                  showBadge: content["badge"] != null,
                  badgeText: content["badge"] as String?,
                  onTap: () {
                    Navigator.pushNamed(context, content["route"] as String);
                  },
                );
              }).toList(),
            ),

            // Preferences Section (moved to fourth position)
            SettingsSectionWidget(
              title: 'PREFERENCES',
              children: [
                SettingsItemWidget(
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark themes',
                  iconName: 'dark_mode',
                  type: SettingsItemType.toggle,
                  value: _isDarkMode.toString(),
                  isFirst: true,
                  isLast: false,
                  onToggle: _handleThemeToggle,
                ),
                SettingsItemWidget(
                  title: 'Notifications',
                  subtitle: 'Receive training reminders and updates',
                  iconName: 'notifications',
                  type: SettingsItemType.toggle,
                  value: _notificationsEnabled.toString(),
                  isFirst: false,
                  isLast: false,
                  onToggle: _handleNotificationToggle,
                ),
                SettingsItemWidget(
                  title: 'Language',
                  subtitle: 'Choose your preferred language',
                  iconName: 'language',
                  type: SettingsItemType.value,
                  value: _selectedLanguage,
                  isFirst: false,
                  isLast: true,
                  onTap: _handleLanguageSelection,
                ),
              ],
            ),

            // Support Center Section (moved to fifth position)
            SettingsSectionWidget(
              title: 'SUPPORT CENTER',
              children: _supportItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return SettingsItemWidget(
                  title: item["title"] as String,
                  subtitle: item["subtitle"] as String,
                  iconName: item["icon"] as String,
                  type: SettingsItemType.navigation,
                  isFirst: index == 0,
                  isLast: index == _supportItems.length - 1,
                  showBadge: item["badge"] != null,
                  badgeText: item["badge"] as String?,
                  onTap: () {
                    Navigator.pushNamed(context, item["route"] as String);
                  },
                );
              }).toList(),
            ),

            // Store Section (moved to last position)
            SettingsSectionWidget(
              title: 'STORE',
              showDivider: false,
              children: [
                const ComingSoonWidget(
                  title: 'PodTrainer Store',
                  description:
                      'Shop for premium training equipment, exclusive gear, and advanced pod accessories.',
                  showNewsletterSignup: true,
                ),
              ],
            ),

            SizedBox(height: 10.h), // Bottom padding for navigation
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.extended,
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }
}
