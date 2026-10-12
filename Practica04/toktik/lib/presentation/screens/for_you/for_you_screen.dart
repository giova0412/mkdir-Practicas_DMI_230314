import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/for_you_provider.dart';
import 'package:toktik/presentation/providers/likes_coordinator.dart';
import 'package:toktik/presentation/widgets/shared/video_feed_body.dart';

class ForYouScreen extends StatelessWidget {
  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForYouProvider>();

    return VideoFeedBody(
      state: provider.state,
      videos: provider.videos,
      errorMessage: provider.errorMessage,
      sectionId: 'for_you',
      onRetry: provider.retry,
      onToggleLike: (id) async {
        await context.read<ForYouProvider>().toggleLike(id);
        if (context.mounted) await LikesCoordinator.sync(context);
      },
    );
  }
}
