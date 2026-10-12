import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/domain/usecases/get_favorite_videos.dart';
import 'package:toktik/domain/usecases/toggle_video_like.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';

class FavoritesProvider extends ChangeNotifier {
  final GetFavoriteVideos _getFavoriteVideos;
  final ToggleVideoLike _toggleVideoLike;

  FavoritesProvider({
    required GetFavoriteVideos getFavoriteVideosUseCase,
    required ToggleVideoLike toggleVideoLikeUseCase,
  })  : _getFavoriteVideos = getFavoriteVideosUseCase,
        _toggleVideoLike = toggleVideoLikeUseCase;

  VideoFeedState state = VideoFeedState.loading;
  List<VideoPostExtended> videos = [];
  String? errorMessage;

  Future<void> load() async {
    state = VideoFeedState.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _getFavoriteVideos();
      videos = result.where((v) => v.liked).toList();
      state = videos.isEmpty ? VideoFeedState.empty : VideoFeedState.success;
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
    final updated = await _toggleVideoLike(videos[index]);
    if (updated.liked) {
      videos[index] = updated;
    } else {
      videos.removeAt(index);
    }
    state = videos.isEmpty ? VideoFeedState.empty : VideoFeedState.success;
    notifyListeners();
  }
}
