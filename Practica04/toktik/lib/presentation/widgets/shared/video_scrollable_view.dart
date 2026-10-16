import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/presentation/providers/playback_controller.dart';
import 'package:toktik/presentation/widgets/shared/video_buttons.dart';
import 'package:toktik/presentation/widgets/video/fullscreen_player.dart';

class VideoScrollableView extends StatefulWidget {
  final List<VideoPostExtended> videos;
  final String sectionId;
  final Future<void> Function(String videoId)? onToggleLike;

  const VideoScrollableView({
    super.key,
    required this.videos,
    required this.sectionId,
    this.onToggleLike,
  });

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _activateFirstIfNeeded();
    });
  }

  void _activateFirstIfNeeded() {
    if (!mounted || widget.videos.isEmpty) return;
    final playback = context.read<PlaybackController>();
    // Si no hay activo o el activo es de otra sección, activa el primero.
    if (playback.activeKey == null ||
        !playback.activeKey!.startsWith('${widget.sectionId}-')) {
      playback.setActive(widget.sectionId, 0);
    }
  }

  @override
  void didUpdateWidget(covariant VideoScrollableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cuando llegan los videos (de loading -> success) activa el primero.
    if (oldWidget.videos.isEmpty && widget.videos.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _activateFirstIfNeeded();
      });
      if (_controller.hasClients) {
        _controller.jumpToPage(0);
      }
    }
    // Si cambió la sección visible, resetea al inicio.
    if (oldWidget.sectionId != widget.sectionId && widget.videos.isNotEmpty) {
      if (_controller.hasClients) {
        _controller.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playback = context.watch<PlaybackController>();

    return PageView.builder(
      controller: _controller,
      // TikTok: desplazamiento VERTICAL.
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      itemCount: widget.videos.length,
      onPageChanged: (index) {
        context.read<PlaybackController>().setActive(widget.sectionId, index);
      },
      itemBuilder: (context, index) {
        final video = widget.videos[index];
        final isActive = playback.isActive(widget.sectionId, index);
        final unmuted = playback.isUnmuted(widget.sectionId, index);

        return Stack(
          children: [
            SizedBox.expand(
              child: FullScreenPlayer(
                key: ValueKey('${widget.sectionId}-${video.id}'),
                videoUrl: video.videoUrl,
                thumbnailUrl: video.thumbnailUrl,
                title: video.title,
                description: video.description,
                play: isActive,
                unmuted: unmuted,
              ),
            ),
            Positioned(
              bottom: 110,
              right: 16,
              child: VideoButtons(
                video: video,
                isMuted: !unmuted,
                onToggleMute: playback.toggleMute,
                onToggleLike: widget.onToggleLike,
              ),
            ),
          ],
        );
      },
    );
  }
}
