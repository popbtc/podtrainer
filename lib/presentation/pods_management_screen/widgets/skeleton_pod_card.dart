import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SkeletonPodCard extends StatefulWidget {
  const SkeletonPodCard({super.key});

  @override
  State<SkeletonPodCard> createState() => _SkeletonPodCardState();
}

class _SkeletonPodCardState extends State<SkeletonPodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Status indicator skeleton
                      _buildShimmerContainer(12, 12, isCircle: true),
                      SizedBox(width: 3.w),
                      // Pod name skeleton
                      Expanded(
                        child: _buildShimmerContainer(20, 40.w),
                      ),
                      // Settings button skeleton
                      _buildShimmerContainer(24, 24, isCircle: true),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      // Signal section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShimmerContainer(12, 15.w),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                // Signal bars
                                ...List.generate(
                                    4,
                                    (index) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 2),
                                          child: _buildShimmerContainer(
                                            8 + (index * 2.0),
                                            3,
                                          ),
                                        )),
                                SizedBox(width: 2.w),
                                _buildShimmerContainer(12, 8.w),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Battery section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShimmerContainer(12, 15.w),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                _buildShimmerContainer(16, 16),
                                SizedBox(width: 1.w),
                                _buildShimmerContainer(12, 10.w),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Button skeleton
                      _buildShimmerContainer(32, 20.w, borderRadius: 8),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(
    double height,
    double width, {
    bool isCircle = false,
    double borderRadius = 4,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: height,
      width: width is double ? width : null,
      decoration: BoxDecoration(
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        gradient: LinearGradient(
          colors: [
            colorScheme.outline.withValues(alpha: 0.1),
            colorScheme.outline.withValues(alpha: 0.3),
            colorScheme.outline.withValues(alpha: 0.1),
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
          end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
        ),
      ),
    );
  }
}
