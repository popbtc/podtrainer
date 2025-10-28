import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../training_hubs_main_screen/widgets/category_tab_bar_widget.dart';
import './widgets/article_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/video_card_widget.dart';

class AcademyContentScreen extends StatefulWidget {
  const AcademyContentScreen({super.key});

  @override
  State<AcademyContentScreen> createState() => _AcademyContentScreenState();
}

class _AcademyContentScreenState extends State<AcademyContentScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  int _currentBottomIndex = 2;

  @override
  bool get wantKeepAlive => true;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isVideoPlayerVisible = false;
  Map<String, dynamic>? _currentVideo;

  Map<String, dynamic> _currentFilters = {
    'contentType': 'All',
    'difficulty': 'All',
    'category': 'All',
    'sortBy': 'newest',
  };

  final List<String> _categories = [
    'All',
    'Technique',
    'Nutrition',
    'Recovery',
    'Equipment',
    'Mental Training',
  ];

  // Mock data for videos
  final List<Map<String, dynamic>> _videos = [
    {
      'id': 1,
      'title': 'Advanced Footwork Techniques for Soccer',
      'thumbnail': 'https://images.unsplash.com/photo-1554029845-7b5fe0f90004',
      'semanticLabel':
          'Soccer player performing footwork drills on green grass field with orange cones',
      'duration': '12:45',
      'category': 'Technique',
      'difficulty': 'Advanced',
      'viewCount': '15.2K',
      'likeCount': '1.2K',
      'isBookmarked': false,
      'videoUrl':
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    },
    {
      'id': 2,
      'title': 'Nutrition for Peak Athletic Performance',
      'thumbnail':
          'https://images.unsplash.com/photo-1573246123716-6b1782bfc499',
      'semanticLabel':
          'Colorful array of fresh fruits and vegetables arranged on white wooden table',
      'duration': '8:30',
      'category': 'Nutrition',
      'difficulty': 'Beginner',
      'viewCount': '23.8K',
      'likeCount': '2.1K',
      'isBookmarked': true,
      'videoUrl':
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
    },
    {
      'id': 3,
      'title': 'Recovery Techniques After Intense Training',
      'thumbnail':
          'https://images.unsplash.com/photo-1672866979693-c3f0e5189994',
      'semanticLabel':
          'Athlete stretching on yoga mat in modern gym with natural lighting',
      'duration': '15:20',
      'category': 'Recovery',
      'difficulty': 'Intermediate',
      'viewCount': '9.7K',
      'likeCount': '856',
      'isBookmarked': false,
      'videoUrl':
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    },
    {
      'id': 4,
      'title': 'Mental Training for Competition Readiness',
      'thumbnail':
          'https://images.unsplash.com/photo-1604431031231-6a75b8f7ab91',
      'semanticLabel':
          'Focused athlete in meditation pose sitting cross-legged in peaceful outdoor setting',
      'duration': '10:15',
      'category': 'Mental Training',
      'difficulty': 'Intermediate',
      'viewCount': '18.4K',
      'likeCount': '1.5K',
      'isBookmarked': true,
      'videoUrl':
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
    },
    {
      'id': 5,
      'title': 'Essential Equipment for Home Training',
      'thumbnail':
          'https://images.unsplash.com/photo-1627461545338-668014e06d66',
      'semanticLabel':
          'Home gym setup with dumbbells, resistance bands, and exercise mat on wooden floor',
      'duration': '6:45',
      'category': 'Equipment',
      'difficulty': 'Beginner',
      'viewCount': '12.3K',
      'likeCount': '987',
      'isBookmarked': false,
      'videoUrl':
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    },
  ];

  // Mock data for articles
  final List<Map<String, dynamic>> _articles = [
    {
      'id': 1,
      'title': 'The Science Behind Muscle Recovery',
      'featuredImage':
          'https://images.unsplash.com/photo-1716996236747-e942646f4ed8',
      'semanticLabel':
          'Scientific diagram showing muscle fiber recovery process with anatomical illustrations',
      'excerpt':
          'Understanding the physiological processes that occur during muscle recovery can help athletes optimize their training schedules and improve performance.',
      'category': 'Recovery',
      'readTime': 8,
      'author': 'Dr. Sarah Mitchell',
      'publishDate': 'Oct 20, 2024',
      'isBookmarked': false,
    },
    {
      'id': 2,
      'title': 'Hydration Strategies for Endurance Athletes',
      'featuredImage':
          'https://images.unsplash.com/photo-1672430719654-e99c73fbcdf9',
      'semanticLabel':
          'Clear water bottle with measurement marks being filled from natural spring source',
      'excerpt':
          'Proper hydration is crucial for maintaining peak performance during long training sessions and competitions. Learn the optimal strategies.',
      'category': 'Nutrition',
      'readTime': 6,
      'author': 'Coach Mike Johnson',
      'publishDate': 'Oct 18, 2024',
      'isBookmarked': true,
    },
    {
      'id': 3,
      'title': 'Building Mental Resilience in Sports',
      'featuredImage':
          'https://images.unsplash.com/photo-1682531024643-dea8aa6b43c8',
      'semanticLabel':
          'Determined athlete with focused expression during intense training session',
      'excerpt':
          'Mental toughness is often what separates good athletes from great ones. Discover techniques to build psychological resilience.',
      'category': 'Mental Training',
      'readTime': 12,
      'author': 'Dr. Lisa Chen',
      'publishDate': 'Oct 15, 2024',
      'isBookmarked': false,
    },
    {
      'id': 4,
      'title': 'Injury Prevention Through Proper Technique',
      'featuredImage':
          'https://images.unsplash.com/photo-1709880754472-be89c13abc52',
      'semanticLabel':
          'Physical therapist demonstrating proper movement technique to prevent sports injuries',
      'excerpt':
          'Most sports injuries are preventable with proper technique and preparation. Learn the key principles of injury prevention.',
      'category': 'Technique',
      'readTime': 10,
      'author': 'PT Amanda Rodriguez',
      'publishDate': 'Oct 12, 2024',
      'isBookmarked': true,
    },
    {
      'id': 5,
      'title': 'Choosing the Right Training Equipment',
      'featuredImage':
          'https://images.unsplash.com/photo-1685633224537-4bea3ec460f0',
      'semanticLabel':
          'Various training equipment including kettlebells, resistance bands, and medicine balls arranged on gym floor',
      'excerpt':
          'With so many training tools available, it can be overwhelming to choose the right equipment for your specific goals and budget.',
      'category': 'Equipment',
      'readTime': 7,
      'author': 'Trainer Alex Thompson',
      'publishDate': 'Oct 10, 2024',
      'isBookmarked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredVideos {
    List<Map<String, dynamic>> filtered = List.from(_videos);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (video) =>
                (video['title'] as String).toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                (video['category'] as String).toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
          )
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((video) => video['category'] == _selectedCategory)
          .toList();
    }

    // Apply additional filters
    if (_currentFilters['difficulty'] != 'All') {
      filtered = filtered
          .where(
            (video) => video['difficulty'] == _currentFilters['difficulty'],
          )
          .toList();
    }

    // Apply sorting
    switch (_currentFilters['sortBy']) {
      case 'popular':
        filtered.sort(
          (a, b) => _parseViewCount(
            b['viewCount'] as String,
          ).compareTo(_parseViewCount(a['viewCount'] as String)),
        );
        break;
      case 'duration':
        filtered.sort(
          (a, b) => _parseDuration(
            a['duration'] as String,
          ).compareTo(_parseDuration(b['duration'] as String)),
        );
        break;
      case 'oldest':
        filtered = filtered.reversed.toList();
        break;
      default: // newest
        break;
    }

    return filtered;
  }

  List<Map<String, dynamic>> get _filteredArticles {
    List<Map<String, dynamic>> filtered = List.from(_articles);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (article) =>
                (article['title'] as String).toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                (article['category'] as String).toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                (article['excerpt'] as String).toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
          )
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((article) => article['category'] == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  int _parseViewCount(String viewCount) {
    final cleanCount = viewCount.replaceAll(RegExp(r'[^\d.]'), '');
    final number = double.tryParse(cleanCount) ?? 0;
    if (viewCount.contains('K')) {
      return (number * 1000).toInt();
    } else if (viewCount.contains('M')) {
      return (number * 1000000).toInt();
    }
    return number.toInt();
  }

  int _parseDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return minutes * 60 + seconds;
    }
    return 0;
  }

  void _toggleVideoBookmark(int videoId) {
    setState(() {
      final videoIndex = _videos.indexWhere((video) => video['id'] == videoId);
      if (videoIndex != -1) {
        _videos[videoIndex]['isBookmarked'] =
            !(_videos[videoIndex]['isBookmarked'] as bool);
      }
    });
  }

  void _toggleArticleBookmark(int articleId) {
    setState(() {
      final articleIndex = _articles.indexWhere(
        (article) => article['id'] == articleId,
      );
      if (articleIndex != -1) {
        _articles[articleIndex]['isBookmarked'] =
            !(_articles[articleIndex]['isBookmarked'] as bool);
      }
    });
  }

  void _playVideo(Map<String, dynamic> video) {
    setState(() {
      _currentVideo = video;
      _isVideoPlayerVisible = true;
    });
  }

  void _closeVideoPlayer() {
    setState(() {
      _isVideoPlayerVisible = false;
      _currentVideo = null;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
            if (filters['category'] != 'All') {
              _selectedCategory = filters['category'] as String;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.standard,
        title: 'Academy',
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'bookmark_border',
              color: colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/favorites-list-screen');
            },
            tooltip: 'Saved Content',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'download',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download feature coming soon')),
              );
            },
            tooltip: 'Download for Offline',
          ),
        ],
      ),
      body: Column(
        children: [
          CategoryTabBarWidget(
            controller: _tabController,
            onTap: (index) => _tabController.animateTo(index),
          ),
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [_buildVideoList(), _buildArticleList()],
            ),
          ),
        ],
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

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: _filteredVideos.isEmpty
          ? _buildEmptyState(
              'No videos found',
              'Try adjusting your search or filters',
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _filteredVideos.length,
              itemBuilder: (context, index) {
                final video = _filteredVideos[index];
                return VideoCardWidget(
                  videoData: video,
                  onTap: () => _playVideo(video),
                  onBookmark: () => _toggleVideoBookmark(video['id'] as int),
                );
              },
            ),
    );
  }

  Widget _buildArticleList() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: _filteredArticles.isEmpty
          ? _buildEmptyState(
              'No articles found',
              'Try adjusting your search or filters',
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];
                return ArticleCardWidget(
                  articleData: article,
                  onTap: () {
                    // Navigate to article detail
                  },
                  onBookmark: () =>
                      _toggleArticleBookmark(article['id'] as int),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            size: 20.w,
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
