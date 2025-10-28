import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';
import './user_switching_widget.dart';

/// Welcome header widget displaying user greeting and avatar
class WelcomeHeaderWidget extends StatefulWidget {
  const WelcomeHeaderWidget({super.key});

  @override
  State<WelcomeHeaderWidget> createState() => _WelcomeHeaderWidgetState();
}

class _WelcomeHeaderWidgetState extends State<WelcomeHeaderWidget> {
  // Current user data (can be changed via user switching)
  Map<String, dynamic> _currentUser = {
    "id": 1,
    "name": "Sarah Mitchell",
    "email": "sarah.mitchell@podtrainer.com",
    "avatar": "https://images.unsplash.com/photo-1707109533624-0faecae2c3ba",
    "role": "Player",
    "semanticLabel":
        "Professional portrait of a young woman with shoulder-length brown hair wearing a white athletic shirt, smiling confidently at the camera"
  };

  void _handleUserChanged(Map<String, dynamic> newUser) {
    setState(() {
      _currentUser = newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // User Avatar
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, '/profile-management-screen'),
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: _currentUser["avatar"] as String,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                  semanticLabel: _currentUser["semanticLabel"] as String,
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _currentUser["name"] as String,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // User Switching Icon (replaced notification icon)
          UserSwitchingWidget(
            currentUser: _currentUser,
            onUserChanged: _handleUserChanged,
          ),
        ],
      ),
    );
  }
}
