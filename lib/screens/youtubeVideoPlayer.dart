import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String videoId;

  YoutubeVideoPlayer({required this.videoId});

  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      // initialVideoId: widget.videoId,
      params: const YoutubePlayerParams(
        autoPlay: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

