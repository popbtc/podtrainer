import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// User switching widget for changing between different users
class UserSwitchingWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onUserChanged;
  final Map<String, dynamic> currentUser;

  const UserSwitchingWidget({
    super.key,
    required this.onUserChanged,
    required this.currentUser,
  });

  @override
  State<UserSwitchingWidget> createState() => _UserSwitchingWidgetState();
}

class _UserSwitchingWidgetState extends State<UserSwitchingWidget> {
  // Mock users data from user management
  final List<Map<String, dynamic>> _availableUsers = [
    {
      "id": 1,
      "name": "Sarah Mitchell",
      "email": "sarah.mitchell@podtrainer.com",
      "avatar": "https://images.unsplash.com/photo-1707109533624-0faecae2c3ba",
      "role": "Player",
      "semanticLabel":
          "Professional portrait of a young woman with shoulder-length brown hair wearing a white athletic shirt, smiling confidently at the camera",
      "status": "Active",
    },
    {
      "id": 2,
      "name": "David Chen",
      "email": "david.chen@podtrainer.com",
      "avatar": "https://images.unsplash.com/photo-1669074792490-9447500a2bd1",
      "role": "Player",
      "semanticLabel":
          "Young Asian man with black hair wearing dark blue polo shirt, professional headshot with confident smile",
      "status": "Active",
    },
    {
      "id": 3,
      "name": "Emma Rodriguez",
      "email": "emma.rodriguez@podtrainer.com",
      "avatar": "https://images.unsplash.com/photo-1665454043378-97c3964ff230",
      "role": "Player",
      "semanticLabel":
          "Professional woman with curly brown hair wearing white blazer, bright smile and confident expression",
      "status": "Active",
    },
    {
      "id": 4,
      "name": "Michael Johnson",
      "email": "michael.johnson@podtrainer.com",
      "avatar": "https://images.unsplash.com/photo-1710180841818-c9352da07d79",
      "role": "Player",
      "semanticLabel":
          "Athletic young man with brown hair wearing gray athletic shirt, friendly smile in outdoor setting",
      "status": "Inactive",
    },
  ];

  void _showUserSwitchingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUserSwitchingModal(),
    );
  }

  Widget _buildUserSwitchingModal() {
    final theme = Theme.of(context);

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'people',
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Switch User',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 0.1.h),

          // Users list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _availableUsers.length,
              itemBuilder: (context, index) {
                final user = _availableUsers[index];
                final isCurrentUser = user['id'] == widget.currentUser['id'];
                final isActive = user['status'] == 'Active';

                return InkWell(
                  onTap: isCurrentUser ? null : () => _switchUser(user),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: isCurrentUser
                          ? Border.all(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        // User Avatar
                        Stack(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isCurrentUser
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: CustomImageWidget(
                                  imageUrl: user["avatar"] as String,
                                  width: 12.w,
                                  height: 12.w,
                                  fit: BoxFit.cover,
                                  semanticLabel:
                                      user["semanticLabel"] as String,
                                ),
                              ),
                            ),
                            if (isCurrentUser)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 4.w,
                                  height: 4.w,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.scaffoldBackgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'check',
                                    color: Colors.white,
                                    size: 2.w,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        SizedBox(width: 3.w),

                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      user["name"] as String,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isActive
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme.onSurface
                                                .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                  if (isCurrentUser)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Current',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  Text(
                                    user["role"] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    width: 1.w,
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.4),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    decoration: BoxDecoration(
                                      color:
                                          isActive ? Colors.green : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    user["status"] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color:
                                          isActive ? Colors.green : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Arrow icon
                        if (!isCurrentUser && isActive)
                          CustomIconWidget(
                            iconName: 'arrow_forward_ios',
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                            size: 4.w,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Add User Button
          Padding(
            padding: EdgeInsets.all(4.w),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/player-management-screen');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'add',
                      color: theme.colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Manage Users',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _switchUser(Map<String, dynamic> user) {
    if (user['status'] != 'Active') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot switch to inactive user'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    Navigator.pop(context);

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 2.h),
              Text(
                'Switching to ${user["name"]}...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate user switching delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
      widget.onUserChanged(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${user["name"]}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showUserSwitchingModal(context),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CustomIconWidget(
          iconName: 'people_outlined',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          size: 6.w,
        ),
      ),
    );
  }
}
