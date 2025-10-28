import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String title;
  final VoidCallback? onClose;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.title,
    this.onClose,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isPlaying = false;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });

      _controller!.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller!.value.isPlaying;
          });
        }
      });
    } catch (e) {
      // Handle video initialization error
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: _isFullscreen ? 100.h : 30.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: _isFullscreen ? null : BorderRadius.circular(12),
      ),
      child: _isInitialized && _controller != null
          ? Stack(
              children: [
                // Video player
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _showControlsTemporarily,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                ),
                // Controls overlay
                if (_showControls)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Top controls
                          Padding(
                            padding: EdgeInsets.all(3.w),
                            child: Row(
                              children: [
                                if (!_isFullscreen)
                                  IconButton(
                                    onPressed: widget.onClose,
                                    icon: CustomIconWidget(
                                      iconName: 'close',
                                      color: Colors.white,
                                      size: 6.w,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _toggleFullscreen,
                                  icon: CustomIconWidget(
                                    iconName: _isFullscreen
                                        ? 'fullscreen_exit'
                                        : 'fullscreen',
                                    color: Colors.white,
                                    size: 6.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Center play button
                          Center(
                            child: IconButton(
                              onPressed: _togglePlayPause,
                              icon: Container(
                                width: 15.w,
                                height: 15.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: _isPlaying ? 'pause' : 'play_arrow',
                                  color: Colors.black,
                                  size: 8.w,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Bottom controls
                          Padding(
                            padding: EdgeInsets.all(3.w),
                            child: Column(
                              children: [
                                // Progress bar
                                VideoProgressIndicator(
                                  _controller!,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                    playedColor: colorScheme.primary,
                                    bufferedColor:
                                        Colors.white.withValues(alpha: 0.3),
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                // Time and controls
                                Row(
                                  children: [
                                    Text(
                                      _formatDuration(
                                          _controller!.value.position),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatDuration(
                                          _controller!.value.duration),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : Center(
              child: _isInitialized
                  ? CircularProgressIndicator(
                      color: colorScheme.primary,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'error_outline',
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 12.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Unable to load video',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
