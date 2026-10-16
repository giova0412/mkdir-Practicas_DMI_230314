import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

class VideoFeedBody extends StatelessWidget {
  final VideoFeedState state;
  final List<VideoPostExtended> videos;
  final String? errorMessage;
  final String sectionId;
  final String emptyMessage;
  final VoidCallback onRetry;
  final Future<void> Function(String videoId)? onToggleLike;

  const VideoFeedBody({
    super.key,
    required this.state,
    required this.videos,
    required this.sectionId,
    required this.onRetry,
    this.errorMessage,
    this.emptyMessage = 'No hay videos disponibles.',
    this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case VideoFeedState.loading:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(strokeWidth: 2),
              SizedBox(height: 12),
              Text('Cargando videos...'),
            ],
          ),
        );
      case VideoFeedState.empty:
        return Center(child: Text(emptyMessage));
      case VideoFeedState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(errorMessage ?? 'No fue posible cargar los videos.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      case VideoFeedState.success:
        return VideoScrollableView(
          videos: videos,
          sectionId: sectionId,
          onToggleLike: onToggleLike,
        );
    }
  }
}
