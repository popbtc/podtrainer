import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PlayerFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController notesController;
  final String selectedSport;
  final List<String> sportOptions;
  final Function(String) onSportChanged;

  const PlayerFormWidget({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.notesController,
    required this.selectedSport,
    required this.sportOptions,
    required this.onSportChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Player Name Field
        _buildFormField(
          context: context,
          label: 'Player Name',
          controller: nameController,
          hint: 'Enter player\'s full name',
          icon: 'person',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Player name is required';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),

        SizedBox(height: 3.h),

        // Age Field
        _buildFormField(
          context: context,
          label: 'Age',
          controller: ageController,
          hint: 'Enter age (8-25)',
          icon: 'cake',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Age is required';
            }
            final age = int.tryParse(value);
            if (age == null) {
              return 'Please enter a valid age';
            }
            if (age < 8 || age > 25) {
              return 'Age must be between 8 and 25';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),

        SizedBox(height: 3.h),

        // Sport Selection Field
        _buildSportSelector(context),

        SizedBox(height: 3.h),

        // Notes Field
        _buildFormField(
          context: context,
          label: 'Notes (Optional)',
          controller: notesController,
          hint: 'Additional notes about the player...',
          icon: 'notes',
          maxLines: 3,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String hint,
    required String icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    TextInputAction? textInputAction,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(left: 1.w, bottom: 1.h),
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),

        // Text Field
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines ?? 1,
          textInputAction: textInputAction,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(179),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: icon,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withAlpha(51),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withAlpha(51),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: maxLines != null && maxLines > 1 ? 2.h : 2.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSportSelector(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(left: 1.w, bottom: 1.h),
          child: Text(
            'Sport Preference',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),

        // Dropdown Field
        DropdownButtonFormField<String>(
          value: selectedSport.isNotEmpty ? selectedSport : null,
          decoration: InputDecoration(
            hintText: 'Select preferred sport',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(179),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'sports',
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withAlpha(51),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withAlpha(51),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a sport';
            }
            return null;
          },
          items: sportOptions.map((String sport) {
            return DropdownMenuItem<String>(
              value: sport,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: _getSportIcon(sport),
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  Text(sport),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onSportChanged(newValue);
            }
          },
          style: theme.textTheme.bodyMedium,
          icon: CustomIconWidget(
            iconName: 'arrow_drop_down',
            size: 24,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'soccer':
        return 'sports_soccer';
      case 'basketball':
        return 'sports_basketball';
      case 'tennis':
        return 'sports_tennis';
      case 'running':
        return 'directions_run';
      case 'swimming':
        return 'pool';
      case 'baseball':
        return 'sports_baseball';
      case 'football':
        return 'sports_football';
      default:
        return 'sports';
    }
  }
}
