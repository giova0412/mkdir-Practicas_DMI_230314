import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/favorites_provider.dart';
import 'package:toktik/presentation/providers/likes_coordinator.dart';
import 'package:toktik/presentation/widgets/shared/video_feed_body.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();

    return VideoFeedBody(
      state: provider.state,
      videos: provider.videos,
      errorMessage: provider.errorMessage,
      emptyMessage: 'Aún no tienes favoritos.',
      sectionId: 'favorites',
      onRetry: provider.retry,
      onToggleLike: (id) async {
        await context.read<FavoritesProvider>().toggleLike(id);
        if (context.mounted) await LikesCoordinator.sync(context);
      },
    );
  }
}
