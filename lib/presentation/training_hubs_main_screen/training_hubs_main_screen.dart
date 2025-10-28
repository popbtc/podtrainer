import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/activity_card_widget.dart';
import './widgets/category_tab_bar_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_bar_widget.dart';

/// Training Hubs Main Screen for browsing training activities
class TrainingHubsMainScreen extends StatefulWidget {
  const TrainingHubsMainScreen({super.key});

  @override
  State<TrainingHubsMainScreen> createState() => _TrainingHubsMainScreenState();
}

class _TrainingHubsMainScreenState extends State<TrainingHubsMainScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  int _currentBottomIndex = 2; // Changed from 1 to 2 (Training tab)

  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {
    'difficulty': <String>[],
    'duration': <String>[],
    'equipment': <String>[],
    'completionStatus': null,
  };

  List<Map<String, dynamic>> _allActivities = [];
  List<Map<String, dynamic>> _filteredActivities = [];
  bool _isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _initializeData();
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _allActivities = [
      // Sessions
      {
        "id": 1,
        "title": "HIIT Cardio Blast",
        "description":
            "High-intensity interval training session designed to boost cardiovascular fitness and burn calories efficiently.",
        "category": "Sessions",
        "difficulty": "Intermediate",
        "duration": "30 min",
        "equipment": "Pods",
        "image": "https://images.unsplash.com/photo-1675610070090-271e493c3d59",
        "semanticLabel":
            "Athletic woman in black workout clothes performing high-intensity exercises in a modern gym with equipment",
        "isFavorite": false,
        "isCompleted": true,
      },
      {
        "id": 2,
        "title": "Strength Foundation",
        "description":
            "Build core strength and muscle endurance with this comprehensive full-body workout routine.",
        "category": "Sessions",
        "difficulty": "Beginner",
        "duration": "45 min",
        "equipment": "Weights",
        "image": "https://images.unsplash.com/photo-1639496908153-e89e77ea95f2",
        "semanticLabel":
            "Muscular man lifting dumbbells in a well-lit gym with mirrors and exercise equipment in background",
        "isFavorite": true,
        "isCompleted": false,
      },
      {
        "id": 3,
        "title": "Flexibility Flow",
        "description":
            "Improve mobility and flexibility with guided stretching and yoga-inspired movements.",
        "category": "Sessions",
        "difficulty": "Beginner",
        "duration": "20 min",
        "equipment": "None",
        "image": "https://images.unsplash.com/photo-1518310952931-b1de897abd40",
        "semanticLabel":
            "Woman in white athletic wear performing yoga stretches on a purple mat in a bright studio",
        "isFavorite": false,
        "isCompleted": false,
      },
      // Sports
      {
        "id": 4,
        "title": "Soccer Agility Training",
        "description":
            "Enhance your soccer skills with reaction-based drills and agility exercises using smart pods.",
        "category": "Sports",
        "difficulty": "Intermediate",
        "duration": "35 min",
        "equipment": "Pods",
        "image": "https://images.unsplash.com/photo-1657957746082-b03d182960d6",
        "semanticLabel":
            "Soccer player in blue jersey dribbling a white and black soccer ball on green grass field",
        "isFavorite": true,
        "isCompleted": false,
      },
      {
        "id": 5,
        "title": "Basketball Reaction Drills",
        "description":
            "Improve court awareness and reaction time with basketball-specific training exercises.",
        "category": "Sports",
        "difficulty": "Advanced",
        "duration": "40 min",
        "equipment": "Pods",
        "image": "https://images.unsplash.com/photo-1721750474656-e124aeccde8d",
        "semanticLabel":
            "Basketball player in red jersey dribbling orange basketball on indoor court with wooden floor",
        "isFavorite": false,
        "isCompleted": true,
      },
      {
        "id": 6,
        "title": "Tennis Footwork",
        "description":
            "Master tennis footwork patterns and improve court movement with precision training.",
        "category": "Sports",
        "difficulty": "Intermediate",
        "duration": "25 min",
        "equipment": "Pods",
        "image": "https://images.unsplash.com/photo-1714741980975-b295a2349104",
        "semanticLabel":
            "Tennis player in white outfit holding racket on blue tennis court with net visible",
        "isFavorite": false,
        "isCompleted": false,
      },
      // Body Parts
      {
        "id": 7,
        "title": "Core Power Workout",
        "description":
            "Strengthen your core muscles with targeted exercises for better stability and power.",
        "category": "Body Parts",
        "difficulty": "Intermediate",
        "duration": "25 min",
        "equipment": "None",
        "image": "https://images.unsplash.com/photo-1518310952931-b1de897abd40",
        "semanticLabel":
            "Fit woman in gray sports bra performing plank exercise on yoga mat in bright fitness studio",
        "isFavorite": true,
        "isCompleted": false,
      },
      {
        "id": 8,
        "title": "Leg Day Challenge",
        "description":
            "Build lower body strength and endurance with this comprehensive leg workout routine.",
        "category": "Body Parts",
        "difficulty": "Advanced",
        "duration": "50 min",
        "equipment": "Weights",
        "image": "https://images.unsplash.com/photo-1646072508462-a802209a16f3",
        "semanticLabel":
            "Athletic person performing squats with barbell in modern gym with weight plates and equipment",
        "isFavorite": false,
        "isCompleted": false,
      },
      {
        "id": 9,
        "title": "Upper Body Blast",
        "description":
            "Target chest, shoulders, and arms with this intensive upper body strength training session.",
        "category": "Body Parts",
        "difficulty": "Advanced",
        "duration": "40 min",
        "equipment": "Weights",
        "image": "https://images.unsplash.com/photo-1652363722822-9570109ea3d4",
        "semanticLabel":
            "Muscular man performing bench press with barbell in gym with spotting equipment visible",
        "isFavorite": false,
        "isCompleted": true,
      },
    ];
    _applyFilters();
  }

  void _onTabChanged() {
    if (mounted) {
      HapticFeedback.lightImpact();
      _applyFilters();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    _applyFilters();
  }

  void _applyFilters() {
    final currentCategory = _getCurrentCategory();

    setState(() {
      _filteredActivities = _allActivities.where((activity) {
        // Category filter
        if (activity['category'] != currentCategory) return false;

        // Search filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          if (!activity['title'].toString().toLowerCase().contains(
                    searchLower,
                  ) &&
              !activity['description'].toString().toLowerCase().contains(
                    searchLower,
                  )) {
            return false;
          }
        }

        // Difficulty filter
        final difficulties = _activeFilters['difficulty'] as List<String>;
        if (difficulties.isNotEmpty &&
            !difficulties.contains(activity['difficulty'])) {
          return false;
        }

        // Duration filter
        final durations = _activeFilters['duration'] as List<String>;
        if (durations.isNotEmpty) {
          final activityDuration = activity['duration'] as String;
          bool matchesDuration = false;
          for (String duration in durations) {
            if (_matchesDurationFilter(activityDuration, duration)) {
              matchesDuration = true;
              break;
            }
          }
          if (!matchesDuration) return false;
        }

        // Equipment filter
        final equipments = _activeFilters['equipment'] as List<String>;
        if (equipments.isNotEmpty &&
            !equipments.contains(activity['equipment'])) {
          return false;
        }

        // Completion status filter
        final completionStatus = _activeFilters['completionStatus'];
        if (completionStatus != null) {
          if (completionStatus == 'completed' &&
              !(activity['isCompleted'] as bool)) {
            return false;
          }
          if (completionStatus == 'not_completed' &&
              (activity['isCompleted'] as bool)) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  bool _matchesDurationFilter(String activityDuration, String filter) {
    final minutes =
        int.tryParse(activityDuration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    switch (filter) {
      case '< 15 min':
        return minutes < 15;
      case '15-30 min':
        return minutes >= 15 && minutes <= 30;
      case '30-60 min':
        return minutes > 30 && minutes <= 60;
      case '> 60 min':
        return minutes > 60;
      default:
        return false;
    }
  }

  String _getCurrentCategory() {
    switch (_tabController.index) {
      case 0:
        return 'Sessions';
      case 1:
        return 'Sports';
      case 2:
        return 'Body Parts';
      default:
        return 'Sessions';
    }
  }

  void _onActivityTap(Map<String, dynamic> activity) {
    Navigator.pushNamed(
      context,
      '/activity-details-screen',
      arguments: activity,
    );
  }

  void _onFavoriteToggle(int activityId) {
    setState(() {
      final activityIndex = _allActivities.indexWhere(
        (activity) => activity['id'] == activityId,
      );
      if (activityIndex != -1) {
        _allActivities[activityIndex]['isFavorite'] =
            !(_allActivities[activityIndex]['isFavorite'] as bool);
      }
    });
    _applyFilters();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => FilterBottomSheetWidget(
          onFiltersApplied: _onFiltersApplied,
          initialFilters: _activeFilters,
        ),
      ),
    );
  }

  void _onBrowseOtherCategories() {
    final nextIndex = (_tabController.index + 1) % 3;
    _tabController.animateTo(nextIndex);
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Training Hubs',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'add',
              color: colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              // Create custom training functionality
            },
            tooltip: 'Create Custom Training',
          ),
        ],
        bottom: CategoryTabBarWidget(
          controller: _tabController,
          onTap: (index) => _tabController.animateTo(index),
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onSearchChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildActivityList(),
                _buildActivityList(),
                _buildActivityList(),
              ],
            ),
          ),
        ],
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

  Widget _buildActivityList() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredActivities.isEmpty) {
      return EmptyStateWidget(
        category: _getCurrentCategory(),
        onBrowseOtherCategories: _onBrowseOtherCategories,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 2.h),
        itemCount: _filteredActivities.length,
        itemBuilder: (context, index) {
          final activity = _filteredActivities[index];
          return ActivityCardWidget(
            activity: activity,
            onTap: () => _onActivityTap(activity),
            onFavoriteToggle: () => _onFavoriteToggle(activity['id'] as int),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60.w,
                      height: 20,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      width: 80.w,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
