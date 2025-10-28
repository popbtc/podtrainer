import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/profile_avatar_widget.dart';
import './widgets/profile_form_widget.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  int _currentBottomIndex = 3;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  String? _selectedImagePath;

  // Mock user data
  final Map<String, dynamic> _originalUserData = {
    "id": 1,
    "name": "Alex Johnson",
    "email": "alex.johnson@email.com",
    "phone": "+1 (555) 123-4567",
    "bio":
        "Passionate athlete focused on improving reaction time and agility. Training with PodTrainer for 2 years.",
    "avatar": "https://images.unsplash.com/photo-1726195221775-e1d394a19f02",
    "joinDate": "2022-03-15",
    "trainingLevel": "Advanced",
    "preferredSports": ["Soccer", "Basketball", "Tennis"],
  };

  late Map<String, dynamic> _currentUserData;

  @override
  void initState() {
    super.initState();
    _currentUserData = Map<String, dynamic>.from(_originalUserData);
  }

  void _onImageChanged(String? imagePath) {
    setState(() {
      _selectedImagePath = imagePath;
      _hasUnsavedChanges = true;
    });
  }

  void _onDataChanged(Map<String, dynamic> newData) {
    setState(() {
      _currentUserData.addAll(newData);
      _hasUnsavedChanges = _hasDataChanged();
    });
  }

  bool _hasDataChanged() {
    return _currentUserData['name'] != _originalUserData['name'] ||
        _currentUserData['email'] != _originalUserData['email'] ||
        _currentUserData['phone'] != _originalUserData['phone'] ||
        _currentUserData['bio'] != _originalUserData['bio'] ||
        _selectedImagePath != null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check for duplicate email (mock validation)
    if (_currentUserData['email'] != _originalUserData['email'] &&
        _currentUserData['email'] == 'existing@email.com') {
      _showErrorDialog(
        'This email address is already in use. Please choose a different email.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate random network failure (20% chance)
      if (DateTime.now().millisecond % 5 == 0) {
        throw Exception('Network timeout');
      }

      // Success - update original data
      _originalUserData.addAll(_currentUserData);
      if (_selectedImagePath != null) {
        _originalUserData['avatar'] = _selectedImagePath;
      }

      setState(() {
        _hasUnsavedChanges = false;
        _selectedImagePath = null;
      });

      // Success feedback
      HapticFeedback.lightImpact();
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog(
        'Failed to save profile. Please check your connection and try again.',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary.withValues(
                      alpha: 0.1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Profile Updated'),
              ],
            ),
            content: const Text('Your profile has been successfully updated.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error.withValues(
                      alpha: 0.1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'error',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Error'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              if (message.contains('connection'))
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _saveProfile();
                  },
                  child: const Text('Retry'),
                ),
            ],
          ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Unsaved Changes'),
            content: const Text(
              'You have unsaved changes. Are you sure you want to leave without saving?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: const Text('Leave'),
              ),
            ],
          ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        variant: CustomAppBarVariant.settings,
        title: 'Profile Management',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Profile Avatar Section
            ProfileAvatarWidget(
              currentImageUrl: _currentUserData["avatar"] as String?,
              onImageChanged: _onImageChanged,
            ),

            SizedBox(height: 4.h),

            // Profile Form Section
            ProfileFormWidget(
              userData: _currentUserData,
              formKey: _formKey,
              onDataChanged: _onDataChanged,
            ),

            SizedBox(height: 4.h),

            // Additional Actions
            SizedBox(height: 2.h),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.standard,
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}