import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Recent activities section displaying training session history
class RecentActivitiesWidget extends StatefulWidget {
  const RecentActivitiesWidget({super.key});

  @override
  State<RecentActivitiesWidget> createState() => _RecentActivitiesWidgetState();
}

class _RecentActivitiesWidgetState extends State<RecentActivitiesWidget> {
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> recentActivities = [
    {
      'id': 1,
      'title': 'Speed & Agility Training',
      'sport': 'Soccer',
      'duration': '45 min',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
      'podStatus': 'Connected',
      'thumbnail':
          'https://images.unsplash.com/photo-1695203061972-34b470222a88',
      'semanticLabel':
          'Soccer player in white jersey dribbling orange ball on green grass field during daytime training session',
      'isFavorite': true,
    },
    {
      'id': 2,
      'title': 'Reaction Time Drills',
      'sport': 'Basketball',
      'duration': '30 min',
      'timestamp': DateTime.now().subtract(Duration(days: 1)),
      'podStatus': 'Disconnected',
      'thumbnail':
          'https://images.unsplash.com/photo-1638569796289-248e6b1051b2',
      'semanticLabel':
          'Basketball player in red jersey jumping to shoot orange ball into hoop on indoor court with wooden floor',
      'isFavorite': false,
    },
    {
      'id': 3,
      'title': 'Core Stability Workout',
      'sport': 'Fitness',
      'duration': '25 min',
      'timestamp': DateTime.now().subtract(Duration(days: 2)),
      'podStatus': 'Connected',
      'thumbnail':
          'https://images.unsplash.com/photo-1727712763476-f4e4e183ca4e',
      'semanticLabel':
          'Athletic woman in black workout clothes doing plank exercise on yoga mat in bright modern gym',
      'isFavorite': true,
    },
    {
      'id': 4,
      'title': 'Hand-Eye Coordination',
      'sport': 'Tennis',
      'duration': '40 min',
      'timestamp': DateTime.now().subtract(Duration(days: 3)),
      'podStatus': 'Connected',
      'thumbnail':
          'https://images.unsplash.com/photo-1697365995755-f9c2be53e009',
      'semanticLabel':
          'Tennis player in white outfit hitting yellow tennis ball with racket on blue hard court surface',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activities',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/activity-details-screen'),
                child: Text(
                  'View All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Activities List
        recentActivities.isEmpty
            ? _buildEmptyState(context)
            : _buildActivitiesList(context),
      ],
    );
  }

  Widget _buildActivitiesList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: recentActivities.length,
        itemBuilder: (context, index) {
          final activity = recentActivities[index];
          return _buildActivityCard(context, activity, index);
        },
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context, Map<String, dynamic> activity, int index) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/activity-details-screen');
        },
        onLongPress: () => _showActivityMenu(context, activity),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: activity['thumbnail'],
                  width: 16.w,
                  height: 16.w,
                  fit: BoxFit.cover,
                  semanticLabel: activity['semanticLabel'],
                ),
              ),

              SizedBox(width: 3.w),

              // Activity Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Favorite
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity['title'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleFavorite(index),
                          child: CustomIconWidget(
                            iconName: activity['isFavorite']
                                ? 'favorite'
                                : 'favorite_border',
                            color: activity['isFavorite']
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                            size: 5.w,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 0.5.h),

                    // Sport and Duration
                    Row(
                      children: [
                        Text(
                          activity['sport'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' • ${activity['duration']}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 0.5.h),

                    // Timestamp and Pod Status
                    Row(
                      children: [
                        Text(
                          _formatTimestamp(activity['timestamp']),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: activity['podStatus'] == 'Connected'
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          activity['podStatus'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: activity['podStatus'] == 'Connected'
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _repeatActivity(activity),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'replay',
                        color: theme.colorScheme.primary,
                        size: 4.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () => _showActivityMenu(context, activity),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'more_vert',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 4.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'fitness_center',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            size: 20.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Start Your First Training',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Connect your pods and begin your athletic journey',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/training-hubs-main-screen'),
            child: Text('Start Training'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();

    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 1));

    setState(() => _isRefreshing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Activities refreshed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      recentActivities[index]['isFavorite'] =
          !recentActivities[index]['isFavorite'];
    });
    HapticFeedback.lightImpact();
  }

  void _repeatActivity(Map<String, dynamic> activity) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${activity['title']}...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showActivityMenu(BuildContext context, Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.onSurface,
                size: 6.w,
              ),
              title: Text('Share Activity'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: Theme.of(context).colorScheme.error,
                size: 6.w,
              ),
              title: Text('Delete Activity'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
