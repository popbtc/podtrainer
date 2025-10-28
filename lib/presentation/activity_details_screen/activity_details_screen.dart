import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/activity_hero_section.dart';
import './widgets/activity_info_card.dart';
import './widgets/instruction_card.dart';
import './widgets/prerequisites_section.dart';
import './widgets/related_activities_section.dart';
import './widgets/social_features_section.dart';
import './widgets/sticky_bottom_bar.dart';

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen({super.key});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollController;
  int _currentBottomIndex = 1;
  bool _isFavorite = false;

  // Mock activity data
  final Map<String, dynamic> _activityData = {
    'id': 1,
    'title': 'Advanced Reaction Training',
    'category': 'Reaction Speed',
    'description':
        '''This comprehensive reaction training session is designed to enhance your reflexes and response time through a series of progressive exercises. Perfect for athletes looking to improve their competitive edge and reaction speed in high-pressure situations.

The training combines visual and auditory stimuli to challenge different aspects of your reaction system, helping you develop faster decision-making skills and improved hand-eye coordination.''',
    'difficulty': 'Advanced',
    'duration': '45 minutes',
    'equipment': '4 Reaction Pods',
    'completions': 1247,
    'image':
        'https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'semanticLabel':
        'Athletic woman in black sports attire performing high-intensity training exercises in a modern gym with equipment',
    'rating': 4.8,
  };

  final List<Map<String, dynamic>> _instructions = [
    {
      'title': 'Warm-up Phase',
      'description':
          'Begin with light stretching and basic hand movements to prepare your muscles and joints for the reaction training session.',
      'timing': '5 minutes',
      'image': 'https://images.unsplash.com/photo-1717500250423-098ada6fb7c0',
      'semanticLabel':
          'Person doing stretching exercises on a yoga mat in a bright fitness studio with natural lighting',
    },
    {
      'title': 'Pod Positioning',
      'description':
          'Place the four reaction pods in a diamond formation around your training area. Ensure each pod is approximately 3 feet away from your center position.',
      'timing': '3 minutes',
      'image': 'https://images.unsplash.com/photo-1697490558727-a73fa21b06fb',
      'semanticLabel':
          'Modern fitness equipment setup with blue LED lights arranged in a training configuration on a gym floor',
    },
    {
      'title': 'Basic Reaction Drills',
      'description':
          'Start with single-pod activation. When a pod lights up, quickly touch it to deactivate. Focus on speed and accuracy.',
      'timing': '15 minutes',
      'image': 'https://images.unsplash.com/photo-1620858991871-22bfab2cf145',
      'semanticLabel':
          'Close-up of hands reaching toward illuminated training equipment during a reaction speed exercise',
    },
    {
      'title': 'Multi-Pod Sequences',
      'description':
          'Progress to sequences where multiple pods activate in patterns. Follow the sequence as quickly and accurately as possible.',
      'timing': '15 minutes',
      'image': 'https://images.unsplash.com/photo-1671396348716-cb049ef5e2f1',
      'semanticLabel':
          'Athlete performing complex movement patterns with multiple pieces of high-tech training equipment',
    },
    {
      'title': 'Cool Down',
      'description':
          'Finish with gentle stretching and breathing exercises to help your body recover from the intense reaction training.',
      'timing': '7 minutes',
      'image': 'https://images.unsplash.com/photo-1599447472329-89e27a211036',
      'semanticLabel':
          'Person in meditation pose on a yoga mat in a peaceful gym environment with soft lighting',
    },
  ];

  final List<Map<String, dynamic>> _requiredPods = [
    {'id': 1, 'name': 'Pod Alpha', 'isConnected': true, 'signalStrength': 95},
    {'id': 2, 'name': 'Pod Beta', 'isConnected': true, 'signalStrength': 87},
    {
      'id': 3,
      'name': 'Pod Gamma',
      'isConnected': false,
      'signalStrength': null,
    },
    {
      'id': 4,
      'name': 'Pod Delta',
      'isConnected': false,
      'signalStrength': null,
    },
  ];

  final List<Map<String, dynamic>> _relatedActivities = [
    {
      'id': 2,
      'title': 'Speed & Agility Training',
      'duration': '30 min',
      'difficulty': 'Intermediate',
      'image': 'https://images.unsplash.com/photo-1608138278545-366680accc66',
      'semanticLabel':
          'Athletic person performing agility ladder drills on an outdoor training field',
    },
    {
      'id': 3,
      'title': 'Hand-Eye Coordination',
      'duration': '25 min',
      'difficulty': 'Beginner',
      'image': 'https://images.unsplash.com/photo-1648467080227-977af5f1db9d',
      'semanticLabel':
          'Close-up of hands catching a ball during coordination training exercises',
    },
    {
      'id': 4,
      'title': 'Cognitive Response Training',
      'duration': '40 min',
      'difficulty': 'Advanced',
      'image': 'https://images.unsplash.com/photo-1547821956-60ba11c8fa76',
      'semanticLabel':
          'Person using advanced cognitive training equipment with digital displays and sensors',
    },
  ];

  final Map<String, dynamic> _socialData = {
    'completions': 1247,
    'rating': 4.8,
    'commentCount': 89,
    'comments': [
      {
        'userName': 'Sarah Mitchell',
        'avatar':
            'https://images.unsplash.com/photo-1700561791890-a15d45b9c79d',
        'semanticLabel':
            'Professional headshot of a woman with shoulder-length brown hair wearing a blue blazer',
        'rating': 5,
        'comment':
            'Amazing workout! Really improved my reaction time for tennis. The pod setup is genius.',
        'timeAgo': '2 days ago',
      },
      {
        'userName': 'Marcus Johnson',
        'avatar':
            'https://images.unsplash.com/photo-1625552832128-84bd15d046d1',
        'semanticLabel':
            'Professional headshot of a man with short black hair and a friendly smile wearing a gray shirt',
        'rating': 4,
        'comment':
            'Great training session. Could use more variety in the sequences but overall very effective.',
        'timeAgo': '1 week ago',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _canStartTraining {
    return _requiredPods.every((pod) => pod['isConnected'] as bool);
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareActivity() {
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing activity...'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startTraining() {
    if (!_canStartTraining) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please connect all required pods before starting'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Start Training'),
            content: const Text(
              'Ready to begin your Advanced Reaction Training session?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to training session screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Training session started!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ],
          ),
    );
  }

  void _connectPod() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/pods-management-screen');
  }

  void _onRelatedActivityTap(Map<String, dynamic> activity) {
    HapticFeedback.lightImpact();

    // Navigate to the selected activity details
    Navigator.pushReplacementNamed(
      context,
      '/activity-details-screen',
      arguments: activity,
    );
  }

  void _viewAllComments() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder:
                (context, scrollController) => Container(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'All Comments (${_socialData['commentCount']})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: (_socialData['comments'] as List).length,
                          itemBuilder: (context, index) {
                            final comment =
                                (_socialData['comments'] as List)[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 5.w,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    child: CustomImageWidget(
                                      imageUrl: comment['avatar'] as String,
                                      width: 10.w,
                                      height: 10.w,
                                      fit: BoxFit.cover,
                                      semanticLabel:
                                          comment['semanticLabel'] as String,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment['userName'] as String,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: List.generate(5, (
                                                starIndex,
                                              ) {
                                                return CustomIconWidget(
                                                  iconName:
                                                      starIndex <
                                                              (comment['rating']
                                                                  as int)
                                                          ? 'star'
                                                          : 'star_border',
                                                  color:
                                                      starIndex <
                                                              (comment['rating']
                                                                  as int)
                                                          ? Theme.of(
                                                            context,
                                                          ).colorScheme.tertiary
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onSurface
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                  size: 14,
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          comment['comment'] as String,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(height: 1.4),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          comment['timeAgo'] as String,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _handleScheduleTraining() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Training scheduled!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Activity Hero Section
          SliverToBoxAdapter(
            child: ActivityHeroSection(
              activity: _activityData,
              onShare: _shareActivity,
              isFavorite: _isFavorite,
              onFavoriteToggle: _toggleFavorite,
            ),
          ),

          // Activity Info Cards
          SliverToBoxAdapter(child: ActivityInfoCard(activity: _activityData)),

          SliverToBoxAdapter(child: SizedBox(height: 2.h)),

          // Prerequisites Section
          SliverToBoxAdapter(
            child: PrerequisitesSection(
              requiredPods: _requiredPods,
              onConnectPod: _connectPod,
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 2.h)),

          // Instructions
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return InstructionCard(
                  instruction: _instructions[index],
                  index: index,
                );
              },
              childCount: _instructions.length,
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 2.h)),

          // Social Features Section
          SliverToBoxAdapter(
            child: SocialFeaturesSection(
              socialData: _socialData,
              onViewAllComments: _viewAllComments,
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 2.h)),

          // Related Activities Section
          SliverToBoxAdapter(
            child: RelatedActivitiesSection(
              relatedActivities: _relatedActivities,
              onActivityTap: _onRelatedActivityTap,
            ),
          ),

          // Bottom padding for sticky bar
          SliverToBoxAdapter(child: SizedBox(height: 12.h)),
        ],
      ),
      bottomSheet: StickyBottomBar(
        isFavorite: _isFavorite,
        onStartTraining: _startTraining,
        canStartTraining: _canStartTraining,
        onToggleFavorite: _toggleFavorite,
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.training,
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }
}

extension SizedBoxExtension on SizedBox {
  Widget toSliver() {
    return SliverToBoxAdapter(child: this);
  }
}