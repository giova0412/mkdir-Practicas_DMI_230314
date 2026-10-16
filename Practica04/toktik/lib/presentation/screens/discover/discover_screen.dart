import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/likes_coordinator.dart';
import 'package:toktik/presentation/widgets/shared/video_feed_body.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscoverProvider>();

    return VideoFeedBody(
      state: provider.state,
      videos: provider.videos,
      errorMessage: provider.errorMessage,
      sectionId: 'discover',
      onRetry: provider.retry,
      onToggleLike: (id) async {
        await context.read<DiscoverProvider>().toggleLike(id);
        if (context.mounted) await LikesCoordinator.sync(context);
      },
    );
  }
}
