import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/domain/usecases/get_discover_videos.dart';
import 'package:toktik/domain/usecases/toggle_video_like.dart';

enum VideoFeedState { loading, success, empty, error }

class DiscoverProvider extends ChangeNotifier {
  final GetDiscoverVideos _getDiscoverVideos;
  final ToggleVideoLike _toggleVideoLike;

  DiscoverProvider({
    required GetDiscoverVideos getDiscoverVideosUseCase,
    required ToggleVideoLike toggleVideoLikeUseCase,
  })  : _getDiscoverVideos = getDiscoverVideosUseCase,
        _toggleVideoLike = toggleVideoLikeUseCase;

  VideoFeedState state = VideoFeedState.loading;
  List<VideoPostExtended> videos = [];
  String? errorMessage;

  Future<void> load() async {
    state = VideoFeedState.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _getDiscoverVideos();
      videos = result;
      state = result.isEmpty ? VideoFeedState.empty : VideoFeedState.success;
    } catch (e) {
      state = VideoFeedState.error;
      errorMessage = 'No fue posible cargar los videos.';
    }
    notifyListeners();
  }

  Future<void> retry() => load();

  Future<void> toggleLike(String videoId) async {
    final index = videos.indexWhere((v) => v.id == videoId);
    if (index == -1) return;
    videos[index] = await _toggleVideoLike(videos[index]);
    notifyListeners();
  }

  void syncFromStorage(VideoPostExtended Function(VideoPostExtended) apply) {
    videos = videos.map(apply).toList();
    notifyListeners();
  }
}
