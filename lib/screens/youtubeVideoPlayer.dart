import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const YoutubeVideoPlayer({super.key, required this.videoUrl});

  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      // Extract video ID from URL using YoutubePlayerController's built-in method
      _videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);

      if (_videoId == null || _videoId!.isEmpty) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
        return;
      }

      _controller = YoutubePlayerController.fromVideoId(
        videoId: _videoId!,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          strictRelatedVideos: true,
        ),
      );

      _controller.setFullScreenListener(
        (isFullScreen) {
          // Handle fullscreen changes if needed
        },
      );

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 200.h,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError || _videoId == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              SizedBox(height: 8),
              Text(
                'Invalid YouTube URL',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      child: YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9,
      ),
    );
  }

  @override
  void dispose() {
    if (!_hasError && _videoId != null) {
      _controller.close();
    }
    super.dispose();
  }
}
