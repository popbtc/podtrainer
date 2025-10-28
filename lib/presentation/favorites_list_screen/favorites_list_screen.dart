import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/favorite_card_widget.dart';
import './widgets/favorites_empty_state_widget.dart';
import './widgets/favorites_group_header_widget.dart';
import './widgets/favorites_search_bar_widget.dart';

/// Favorites List Screen - Displays user-favorited training activities
class FavoritesListScreen extends StatefulWidget {
  const FavoritesListScreen({super.key});

  @override
  State<FavoritesListScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String _searchQuery = '';
  String? _selectedCategory;
  bool _isGrouped = false;
  bool _isLoading = false;

  // Mock favorites data - now specific to current user (Sarah Mitchell)
  // In real app, this would be fetched from database based on current user ID
  final List<Map<String, dynamic>> _allFavorites = [
    {
      "id": 1,
      "userId":
          1, // Sarah Mitchell's user ID "title": "High-Intensity Interval Training", "category": "Cardio", "difficulty": "Advanced", "duration": "30 min", "thumbnail": "https://images.unsplash.com/photo-1633354129320-163fb10dd288", "semanticLabel": "Athletic woman in black sports bra and leggings performing high-intensity workout in modern gym with equipment", "lastCompleted": "2 days ago", "description": "Burn calories fast with this intense cardio workout designed to boost your metabolism.", "addedBy": "Sarah Mitchell", // User who added to favorites "addedDate": "2024-10-20", }, { "id": 2, "userId": 1, // Sarah Mitchell's user ID "title": "Core Strength Builder",
      "category": "Body Parts",
      "difficulty": "Intermediate",
      "duration": "25 min",
      "thumbnail":
          "https://images.unsplash.com/photo-1518310952931-b1de897abd40",
      "semanticLabel":
          "Fit woman doing plank exercise on yoga mat in bright fitness studio with natural lighting",
      "lastCompleted": "1 week ago",
      "description":
          "Strengthen your core with targeted exercises for better stability and posture.",
      "addedBy": "Sarah Mitchell",
      "addedDate": "2024-10-18",
    },
    {
      "id": 3,
      "userId":
          1, // Sarah Mitchell's user ID "title": "Basketball Agility Drills", "category": "Sports", "difficulty": "Intermediate", "duration": "45 min", "thumbnail": "https://images.unsplash.com/photo-1706841533921-518301209b62", "semanticLabel": "Basketball player in orange jersey dribbling ball on outdoor court with urban background", "lastCompleted": "3 days ago", "description": "Improve your basketball skills with reaction-based agility training.", "addedBy": "Sarah Mitchell", "addedDate": "2024-10-15", }, { "id": 4, "userId": 1, // Sarah Mitchell's user ID "title": "Upper Body Power",
      "category": "Strength",
      "difficulty": "Advanced",
      "duration": "40 min",
      "thumbnail":
          "https://images.unsplash.com/photo-1704375058325-e51b6382a95d",
      "semanticLabel":
          "Muscular man performing pull-ups on outdoor fitness equipment in park setting",
      "lastCompleted": null,
      "description":
          "Build upper body strength with compound movements and resistance training.",
      "addedBy": "Sarah Mitchell",
      "addedDate": "2024-10-12",
    },
    {
      "id": 5,
      "userId":
          1, // Sarah Mitchell's user ID "title": "Soccer Reaction Training", "category": "Sports", "difficulty": "Beginner", "duration": "35 min", "thumbnail": "https://images.unsplash.com/photo-1569921052084-9e82f06682d8", "semanticLabel": "Soccer player in blue uniform kicking ball on green grass field during practice session", "lastCompleted": "5 days ago", "description": "Enhance your soccer skills with pod-based reaction and agility training.", "addedBy": "Sarah Mitchell", "addedDate": "2024-10-10", }, { "id": 6, "userId": 1, // Sarah Mitchell's user ID "title": "Leg Day Intensive",
      "category": "Body Parts",
      "difficulty": "Advanced",
      "duration": "50 min",
      "thumbnail":
          "https://images.unsplash.com/photo-1718633561231-864a4c466991",
      "semanticLabel":
          "Woman in athletic wear performing squats with barbell in modern gym with mirrors",
      "lastCompleted": "1 day ago",
      "description":
          "Comprehensive leg workout targeting all major muscle groups for strength and power.",
      "addedBy": "Sarah Mitchell",
      "addedDate": "2024-10-08",
    },
  ];

  List<Map<String, dynamic>> _filteredFavorites = [];

  @override
  void initState() {
    super.initState();
    _filteredFavorites = List.from(_allFavorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.standard,
        title: 'Favorites',
        actions: [
          IconButton(
            onPressed: _toggleGrouping,
            icon: CustomIconWidget(
              iconName: _isGrouped ? 'view_list' : 'view_module',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: _isGrouped ? 'List View' : 'Group View',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'select_all',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'select_all',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('Select All'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'clear_all',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('Clear All Favorites'),
                  ],
                ),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          FavoritesSearchBarWidget(
            onSearchChanged: _handleSearchChanged,
            onCategoryFilter: _handleCategoryFilter,
            selectedCategory: _selectedCategory,
          ),
          // Main content
          Expanded(
            child: _filteredFavorites.isEmpty
                ? FavoritesEmptyStateWidget(
                    onBrowseActivities: _handleBrowseActivities,
                    isSearching:
                        _searchQuery.isNotEmpty || _selectedCategory != null,
                    searchQuery: _searchQuery,
                  )
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _handleRefresh,
                    child:
                        _isGrouped ? _buildGroupedList() : _buildStandardList(),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.standard,
        currentIndex: 1, // Update to correct index for favorites functionality
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }

  Widget _buildStandardList() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _filteredFavorites.length,
      itemBuilder: (context, index) {
        final activity = _filteredFavorites[index];
        return Dismissible(
          key: Key('favorite_${activity["id"]}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 4.w),
            color: AppTheme.lightTheme.colorScheme.error,
            child: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 24,
            ),
          ),
          confirmDismiss: (direction) => _showRemoveConfirmation(activity),
          onDismissed: (direction) => _removeFavorite(activity),
          child: FavoriteCardWidget(
            activity: activity,
            onRemove: () => _removeFavorite(activity),
            onStart: () => _startTraining(activity),
            onTap: () => _viewActivityDetails(activity),
          ),
        );
      },
    );
  }

  Widget _buildGroupedList() {
    final groupedFavorites = _groupFavoritesByCategory();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: groupedFavorites.length,
      itemBuilder: (context, index) {
        final group = groupedFavorites[index];
        final categoryName = group['category'] as String;
        final activities = group['activities'] as List<Map<String, dynamic>>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FavoritesGroupHeaderWidget(
              title: categoryName,
              count: activities.length,
              icon: _getCategoryIcon(categoryName),
            ),
            ...activities
                .map(
                  (activity) => Dismissible(
                    key: Key('favorite_grouped_${activity["id"]}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 4.w),
                      color: AppTheme.lightTheme.colorScheme.error,
                      child: CustomIconWidget(
                        iconName: 'delete',
                        color: AppTheme.lightTheme.colorScheme.onError,
                        size: 24,
                      ),
                    ),
                    confirmDismiss: (direction) =>
                        _showRemoveConfirmation(activity),
                    onDismissed: (direction) => _removeFavorite(activity),
                    child: FavoriteCardWidget(
                      activity: activity,
                      onRemove: () => _removeFavorite(activity),
                      onStart: () => _startTraining(activity),
                      onTap: () => _viewActivityDetails(activity),
                    ),
                  ),
                )
                .toList(),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _groupFavoritesByCategory() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final activity in _filteredFavorites) {
      final category = activity['category'] as String;
      grouped[category] = grouped[category] ?? [];
      grouped[category]!.add(activity);
    }

    return grouped.entries
        .map((entry) => {'category': entry.key, 'activities': entry.value})
        .toList();
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return 'sports_soccer';
      case 'body parts':
        return 'accessibility_new';
      case 'cardio':
        return 'favorite';
      case 'strength':
        return 'fitness_center';
      default:
        return 'category';
    }
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterFavorites();
    });
  }

  void _handleCategoryFilter(String? category) {
    setState(() {
      _selectedCategory = category;
      _filterFavorites();
    });
  }

  void _filterFavorites() {
    setState(() {
      _filteredFavorites = _allFavorites.where((activity) {
        final matchesSearch = _searchQuery.isEmpty ||
            (activity['title'] as String).toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
            (activity['category'] as String).toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );

        final matchesCategory = _selectedCategory == null ||
            activity['category'] == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _toggleGrouping() {
    setState(() {
      _isGrouped = !_isGrouped;
    });
    HapticFeedback.lightImpact();
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'select_all':
        _selectAllFavorites();
        break;
      case 'clear_all':
        _showClearAllConfirmation();
        break;
    }
  }

  void _selectAllFavorites() {
    // Implementation for batch selection
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Batch selection mode activated'),
        action: SnackBarAction(label: 'Cancel', onPressed: () {}),
      ),
    );
  }

  void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Favorites'),
        content: Text(
          'Are you sure you want to remove all ${_allFavorites.length} favorites? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllFavorites();
            },
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _clearAllFavorites() {
    setState(() {
      _allFavorites.clear();
      _filteredFavorites.clear();
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All favorites cleared'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Restore favorites (in real app, this would restore from backup)
          },
        ),
      ),
    );
  }

  Future<bool> _showRemoveConfirmation(Map<String, dynamic> activity) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove from Favorites'),
        content: Text('Remove "${activity["title"]}" from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Remove'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _removeFavorite(Map<String, dynamic> activity) {
    final index = _allFavorites.indexWhere(
      (item) => item['id'] == activity['id'],
    );
    if (index != -1) {
      setState(() {
        _allFavorites.removeAt(index);
        _filterFavorites();
      });

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from favorites'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _allFavorites.insert(index, activity);
                _filterFavorites();
              });
            },
          ),
        ),
      );
    }
  }

  void _startTraining(Map<String, dynamic> activity) {
    HapticFeedback.lightImpact();

    // Check pod connectivity before starting training
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start Training'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'bluetooth_searching',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text('Checking pod connectivity...'),
          ],
        ),
      ),
    );

    // Simulate pod check
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        '/activity-details-screen',
        arguments: activity,
      );
    });
  }

  void _viewActivityDetails(Map<String, dynamic> activity) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      '/activity-details-screen',
      arguments: activity,
    );
  }

  void _handleBrowseActivities() {
    if (_searchQuery.isNotEmpty || _selectedCategory != null) {
      // Clear search/filter
      setState(() {
        _searchQuery = '';
        _selectedCategory = null;
        _filterFavorites();
      });
    } else {
      // Navigate to training hubs
      Navigator.pushNamed(context, '/training-hubs-main-screen');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      // In real app, this would sync favorites from server
    });

    HapticFeedback.lightImpact();
  }
}
