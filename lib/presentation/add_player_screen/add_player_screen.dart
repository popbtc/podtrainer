import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/player_avatar_picker_widget.dart';
import './widgets/player_form_widget.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedSport = '';
  String? _selectedAvatarUrl;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  bool _isEditMode = false;
  Map<String, dynamic>? _existingPlayer;

  final List<String> _sportOptions = [
    'Soccer',
    'Basketball',
    'Tennis',
    'Running',
    'Swimming',
    'Baseball',
    'Football',
    'Other'
  ];

  final List<String> _defaultAvatars = [
    'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
    'https://images.pixabay.com/photo/2016/11/29/06/46/adult-1867380_1280.jpg',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
    'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
    'https://images.pexels.com/photos/1858175/pexels-photo-1858175.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _ageController.addListener(_onFormChanged);
    _notesController.addListener(_onFormChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingPlayerData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadExistingPlayerData() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        _isEditMode = true;
        _existingPlayer = args;
        _nameController.text = args['name'] ?? '';
        _ageController.text = args['age']?.toString() ?? '';
        _selectedSport = args['sport'] ?? '';
        _selectedAvatarUrl = args['avatar'];
        _notesController.text = args['notes'] ?? '';
      });
    }
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _onSportChanged(String sport) {
    setState(() {
      _selectedSport = sport;
    });
    _onFormChanged();
  }

  void _onAvatarSelected(String? avatarUrl) {
    setState(() {
      _selectedAvatarUrl = avatarUrl;
    });
    _onFormChanged();
  }

  void _handleAvatarPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        height: 60.h,
        child: Column(
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
              'Select Avatar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),

            // Camera and Gallery Options
            Row(
              children: [
                Expanded(
                  child: _buildAvatarOption(
                    icon: 'camera_alt',
                    title: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Camera feature will be available soon'),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildAvatarOption(
                    icon: 'photo_library',
                    title: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Gallery feature will be available soon'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Default Avatars
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Default Avatars',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(height: 2.h),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _defaultAvatars.length,
                itemBuilder: (context, index) {
                  final avatarUrl = _defaultAvatars[index];
                  final isSelected = _selectedAvatarUrl == avatarUrl;

                  return GestureDetector(
                    onTap: () {
                      _onAvatarSelected(avatarUrl);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: CustomIconWidget(
                              iconName: 'person',
                              size: 40,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCancel() {
    if (_hasUnsavedChanges) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text(
                'You have unsaved changes. Are you sure you want to leave?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Leave'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check for duplicate names (excluding current player in edit mode)
    if (_nameController.text.toLowerCase() == 'emma johnson' &&
        (!_isEditMode || _existingPlayer?['name'] != _nameController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A player with this name already exists'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate save operation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode
              ? 'Player updated successfully'
              : 'Player added successfully'),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.primary,
        title: _isEditMode ? 'Edit Player' : 'Add Player',
        showBackButton: false,
        actions: [
          TextButton(
            onPressed: _handleCancel,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                SizedBox(height: 2.h),

                // Avatar Picker
                PlayerAvatarPickerWidget(
                  avatarUrl: _selectedAvatarUrl,
                  onTap: _handleAvatarPicker,
                ),

                SizedBox(height: 4.h),

                // Form Fields
                PlayerFormWidget(
                  nameController: _nameController,
                  ageController: _ageController,
                  notesController: _notesController,
                  selectedSport: _selectedSport,
                  sportOptions: _sportOptions,
                  onSportChanged: _onSportChanged,
                ),

                SizedBox(height: 4.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 2.h,
                            width: 2.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            _isEditMode ? 'Update Player' : 'Add Player',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}