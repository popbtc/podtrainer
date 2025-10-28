import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _contentTypes = ['All', 'Videos', 'Articles'];
  final List<String> _difficulties = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];
  final List<String> _categories = [
    'All',
    'Technique',
    'Nutrition',
    'Recovery',
    'Equipment',
    'Mental Training'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Filter Content',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          // Filter options
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content Type
                  _buildFilterSection(
                    'Content Type',
                    _contentTypes,
                    _filters['contentType'] as String,
                    (value) => setState(() => _filters['contentType'] = value),
                  ),
                  SizedBox(height: 3.h),
                  // Difficulty Level
                  _buildFilterSection(
                    'Difficulty Level',
                    _difficulties,
                    _filters['difficulty'] as String,
                    (value) => setState(() => _filters['difficulty'] = value),
                  ),
                  SizedBox(height: 3.h),
                  // Category
                  _buildFilterSection(
                    'Category',
                    _categories,
                    _filters['category'] as String,
                    (value) => setState(() => _filters['category'] = value),
                  ),
                  SizedBox(height: 3.h),
                  // Sort By
                  _buildSortSection(),
                ],
              ),
            ),
          ),
          // Apply button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Apply Filters',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    ValueChanged<String> onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onChanged(option),
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primary,
              checkmarkColor: colorScheme.onPrimary,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sortOptions = [
      {'value': 'newest', 'label': 'Newest First'},
      {'value': 'oldest', 'label': 'Oldest First'},
      {'value': 'popular', 'label': 'Most Popular'},
      {'value': 'duration', 'label': 'Duration'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...sortOptions.map((option) {
          final isSelected = _filters['sortBy'] == option['value'];
          return RadioListTile<String>(
            title: Text(
              option['label'] as String,
              style: theme.textTheme.bodyMedium,
            ),
            value: option['value'] as String,
            groupValue: _filters['sortBy'] as String,
            onChanged: (value) => setState(() => _filters['sortBy'] = value),
            activeColor: colorScheme.primary,
            contentPadding: EdgeInsets.zero,
          );
        }),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'contentType': 'All',
        'difficulty': 'All',
        'category': 'All',
        'sortBy': 'newest',
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged?.call(_filters);
    Navigator.pop(context);
  }
}
