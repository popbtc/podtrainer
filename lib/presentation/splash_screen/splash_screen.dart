import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';
  double _initializationProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Start progress animation
      _progressAnimationController.forward();

      // Step 1: Check BLE availability
      await _updateInitializationStatus('Checking Bluetooth...', 0.2);
      await Future.delayed(const Duration(milliseconds: 400));

      // Step 2: Load user preferences
      await _updateInitializationStatus('Loading preferences...', 0.4);
      await Future.delayed(const Duration(milliseconds: 400));

      // Step 3: Prepare pod connection services
      await _updateInitializationStatus('Preparing pod services...', 0.6);
      await Future.delayed(const Duration(milliseconds: 400));

      // Step 4: Fetch training content cache
      await _updateInitializationStatus('Loading training content...', 0.8);
      await Future.delayed(const Duration(milliseconds: 400));

      // Step 5: Complete initialization
      await _updateInitializationStatus('Ready!', 1.0);
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to home dashboard
      if (mounted) {
        HapticFeedback.lightImpact();
        Navigator.pushReplacementNamed(context, '/home-dashboard-screen');
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        _showErrorDialog();
      }
    }
  }

  Future<void> _updateInitializationStatus(
      String status, double progress) async {
    if (mounted) {
      setState(() {
        _initializationStatus = status;
        _initializationProgress = progress;
      });
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Initialization Error',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Unable to initialize the app. Please check your connection and try again.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _retryInitialization();
            },
            child: Text(
              'Retry',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _initializationStatus = 'Initializing...';
      _initializationProgress = 0.0;
    });

    // Reset animations
    _logoAnimationController.reset();
    _progressAnimationController.reset();

    // Restart initialization
    _logoAnimationController.forward();
    _startInitialization();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.colorScheme.primary,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer to push content to center
                const Spacer(flex: 2),

                // App Logo Section
                AnimatedBuilder(
                  animation: _logoAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(24.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'fitness_center',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 48.w,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'PodTrainer',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 8.h),

                // App Title
                AnimatedBuilder(
                  animation: _logoAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Text(
                        'Sports Training & Pod Management',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.9),
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),

                const Spacer(flex: 1),

                // Loading Section
                if (_isInitializing) ...[
                  // Initialization Status
                  Text(
                    _initializationStatus,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.9),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Progress Indicator
                  Container(
                    width: 60.w,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _initializationProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Loading Dots Animation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _progressAnimationController,
                        builder: (context, child) {
                          final delay = index * 0.2;
                          final progress = (_progressAnimation.value - delay)
                              .clamp(0.0, 1.0);
                          final opacity = (progress * 2).clamp(0.0, 1.0);

                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Opacity(
                              opacity: opacity,
                              child: Container(
                                width: 2.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],

                const Spacer(flex: 1),

                // Version Info
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    'Version 1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
