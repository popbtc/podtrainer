import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileFormWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onDataChanged;
  final GlobalKey<FormState> formKey;

  const ProfileFormWidget({
    super.key,
    required this.userData,
    required this.onDataChanged,
    required this.formKey,
  });

  @override
  State<ProfileFormWidget> createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  late FocusNode _nameFocus;
  late FocusNode _emailFocus;
  late FocusNode _phoneFocus;
  late FocusNode _bioFocus;

  Map<String, String?> _errors = {};
  Map<String, bool> _isValid = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeFocusNodes();
    _setupListeners();
  }

  void _initializeControllers() {
    _nameController =
        TextEditingController(text: widget.userData['name'] ?? '');
    _emailController =
        TextEditingController(text: widget.userData['email'] ?? '');
    _phoneController =
        TextEditingController(text: widget.userData['phone'] ?? '');
    _bioController = TextEditingController(text: widget.userData['bio'] ?? '');
  }

  void _initializeFocusNodes() {
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneFocus = FocusNode();
    _bioFocus = FocusNode();
  }

  void _setupListeners() {
    _nameController
        .addListener(() => _validateField('name', _nameController.text));
    _emailController
        .addListener(() => _validateField('email', _emailController.text));
    _phoneController
        .addListener(() => _validateField('phone', _phoneController.text));
    _bioController
        .addListener(() => _validateField('bio', _bioController.text));
  }

  void _validateField(String field, String value) {
    setState(() {
      switch (field) {
        case 'name':
          if (value.isEmpty) {
            _errors[field] = 'Name is required';
            _isValid[field] = false;
          } else if (value.length < 2) {
            _errors[field] = 'Name must be at least 2 characters';
            _isValid[field] = false;
          } else {
            _errors[field] = null;
            _isValid[field] = true;
          }
          break;
        case 'email':
          if (value.isEmpty) {
            _errors[field] = 'Email is required';
            _isValid[field] = false;
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(value)) {
            _errors[field] = 'Please enter a valid email address';
            _isValid[field] = false;
          } else {
            _errors[field] = null;
            _isValid[field] = true;
          }
          break;
        case 'phone':
          if (value.isNotEmpty &&
              !RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value)) {
            _errors[field] = 'Please enter a valid phone number';
            _isValid[field] = false;
          } else {
            _errors[field] = null;
            _isValid[field] = true;
          }
          break;
        case 'bio':
          if (value.length > 500) {
            _errors[field] = 'Bio must be less than 500 characters';
            _isValid[field] = false;
          } else {
            _errors[field] = null;
            _isValid[field] = true;
          }
          break;
      }
    });

    // Update parent with current data
    widget.onDataChanged({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'bio': _bioController.text,
    });
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String fieldKey,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    int maxLines = 1,
    int? maxLength,
    String? hintText,
    Widget? suffixIcon,
  }) {
    final hasError = _errors[fieldKey] != null;
    final isFieldValid = _isValid[fieldKey] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: isFieldValid && !hasError
                ? Container(
                    margin: const EdgeInsets.all(12),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.colorScheme.onSecondary,
                      size: 12,
                    ),
                  )
                : suffixIcon,
            errorText: _errors[fieldKey],
            errorMaxLines: 2,
            counterText: maxLength != null
                ? '${controller.text.length}/$maxLength'
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? AppTheme.lightTheme.colorScheme.error
                    : isFieldValid
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.error,
                width: 2,
              ),
            ),
          ),
          onFieldSubmitted: (value) {
            if (textInputAction == TextInputAction.next) {
              _focusNextField();
            } else {
              focusNode.unfocus();
            }
          },
          validator: (value) => _errors[fieldKey],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _focusNextField() {
    if (_nameFocus.hasFocus) {
      _emailFocus.requestFocus();
    } else if (_emailFocus.hasFocus) {
      _phoneFocus.requestFocus();
    } else if (_phoneFocus.hasFocus) {
      _bioFocus.requestFocus();
    }
  }

  bool get isFormValid {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _errors.values.every((error) => error == null) &&
        (_isValid['name'] == true && _isValid['email'] == true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: 'Full Name *',
            controller: _nameController,
            focusNode: _nameFocus,
            fieldKey: 'name',
            hintText: 'Enter your full name',
            textInputAction: TextInputAction.next,
          ),
          _buildFormField(
            label: 'Email Address *',
            controller: _emailController,
            focusNode: _emailFocus,
            fieldKey: 'email',
            keyboardType: TextInputType.emailAddress,
            hintText: 'Enter your email address',
            textInputAction: TextInputAction.next,
          ),
          _buildFormField(
            label: 'Phone Number',
            controller: _phoneController,
            focusNode: _phoneFocus,
            fieldKey: 'phone',
            keyboardType: TextInputType.phone,
            hintText: 'Enter your phone number',
            textInputAction: TextInputAction.next,
          ),
          _buildFormField(
            label: 'Bio',
            controller: _bioController,
            focusNode: _bioFocus,
            fieldKey: 'bio',
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            maxLines: 4,
            maxLength: 500,
            hintText: 'Tell us about yourself...',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Fields marked with * are required',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
