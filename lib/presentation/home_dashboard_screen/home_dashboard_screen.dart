import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_bottom_bar.dart';
import './widgets/navigation_cards_widget.dart';
import './widgets/quick_start_fab_widget.dart';
import './widgets/recent_activities_widget.dart';
import './widgets/welcome_header_widget.dart';

/// Home Dashboard Screen - Primary landing screen with navigation and activity overview
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentBottomIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // Welcome Header
            SliverToBoxAdapter(child: WelcomeHeaderWidget()),

            // Navigation Cards
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    child: Text(
                      'Quick Access',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  NavigationCardsWidget(),
                ],
              ),
            ),

            SizedBox(height: 2.h).toSliver(),

            // Recent Activities
            SliverToBoxAdapter(child: RecentActivitiesWidget()),

            // Bottom padding for FAB
            SizedBox(height: 10.h).toSliver(),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: QuickStartFabWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom Navigation Bar
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
}

/// Extension to convert SizedBox to Sliver
extension SizedBoxSliver on SizedBox {
  Widget toSliver() => SliverToBoxAdapter(child: this);
}
