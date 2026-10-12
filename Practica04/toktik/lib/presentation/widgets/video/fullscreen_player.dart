import 'package:flutter/material.dart';
import 'package:toktik/presentation/widgets/shared/expandable_description.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final String title;
  final String description;
  final bool play;
  final bool unmuted;

  const FullScreenPlayer({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl = '',
    required this.title,
    required this.description,
    this.play = true,
    this.unmuted = false,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  VideoPlayerController? _controller;
  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    } else {
      _isLoading = true;
      _hasError = false;
    }
    try {
      final url = widget.videoUrl.trim();
      if (url.isEmpty) throw Exception('URL vacía');
      final VideoPlayerController controller;
      if (url.startsWith('http')) {
        // Sin VideoPlayerOptions para máxima compatibilidad en emulador.
        controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        controller = VideoPlayerController.asset(url);
      }
      // Libera el anterior antes de asignar el nuevo.
      try {
        await _controller?.dispose();
      } catch (_) {}
      if (!mounted) {
        try {
          await controller.dispose();
        } catch (_) {}
        return;
      }
      _controller = controller;
      // Timeout amplio: el emulador es lento, pero no eterno.
      // Si tarda >20s, se muestra Reintentar en vez de spinner infinito.
      await controller.initialize().timeout(const Duration(seconds: 20));
      await controller.setLooping(true);
      try {
        await controller.setVolume(widget.unmuted ? 1 : 0);
      } catch (_) {}
      if (widget.play) {
        try {
          await controller.play();
        } catch (_) {}
      } else {
        try {
          await controller.pause();
        } catch (_) {}
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initController();
      return;
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    controller.setVolume(widget.unmuted ? 1 : 0);
    if (widget.play && !controller.value.isPlaying && !_hasError) {
      controller.play();
    } else if (!widget.play && controller.value.isPlaying) {
      controller.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildThumbnailPlaceholder() {
    final thumb = widget.thumbnailUrl;
    if (thumb.startsWith('http')) {
      return Image.network(
        thumb,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(color: Colors.black87),
      );
    }
    return Container(color: Colors.black87);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildThumbnailPlaceholder(),
          Container(color: Colors.black54),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white70, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'No fue posible reproducir este video.\nRevisa tu conexión.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _initController,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final controller = _controller;
    if (_isLoading || controller == null || !controller.value.isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildThumbnailPlaceholder(),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Cargando video...',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
        setState(() {});
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
          VideoBackground(stops: const [0.75, 1.0]),
          Positioned(
            bottom: 28,
            left: 16,
            child: ExpandableDescription(
              title: widget.title,
              description: widget.description,
            ),
          ),
        ],
      ),
    );
  }
}
