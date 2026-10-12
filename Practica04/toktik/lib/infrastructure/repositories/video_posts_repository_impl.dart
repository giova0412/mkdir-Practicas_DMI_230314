import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';

class VideoPostsRepositoryImpl implements VideoPostRepository {
  final VideoPostDatasource localDatasource;
  final VideoPostDatasource giphyDatasource;
  final VideoPostDatasource vimeoDatasource;
  final VideoPostDatasource pixabayDatasource;
  final LocalStorageService storage;

  VideoPostsRepositoryImpl({
    required this.localDatasource,
    required this.giphyDatasource,
    required this.vimeoDatasource,
    required this.pixabayDatasource,
    required this.storage,
  });

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async {
    return getFavoriteVideosByIds(storage.getFavoriteVideoIds().toList());
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return getDiscoverVideos(page: page);
  }

  @override
  Future<List<VideoPostExtended>> getDiscoverVideos({int page = 1}) async {
    // Pixabay primero (MP4 directos, el más rápido); locales al final
    // (assets pesados, prueba de manejo de assets).
    final results = await Future.wait([
      _safe(() => pixabayDatasource.getDiscoverVideos(page: page)),
      _safe(() => giphyDatasource.getDiscoverVideos(page: page)),
      _safe(() => vimeoDatasource.getDiscoverVideos(page: page)),
      _safe(() => localDatasource.getDiscoverVideos(page: page)),
    ]);
    return _hydrate(_merge(results));
  }

  @override
  Future<List<VideoPostExtended>> getForYouVideos({int page = 1}) async {
    final results = await Future.wait([
      _safe(() => pixabayDatasource.getForYouVideos(page: page)),
      _safe(() => giphyDatasource.getForYouVideos(page: page)),
      _safe(() => vimeoDatasource.getForYouVideos(page: page)),
      _safe(() => localDatasource.getForYouVideos(page: page)),
    ]);
    final merged = _merge(results);
    merged.shuffle();
    return _hydrate(merged);
  }

  @override
  Future<List<VideoPostExtended>> getFavoriteVideosByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];
    final snapshots = storage.getFavoriteSnapshots();
    final found = <String, VideoPostExtended>{
      for (final video in snapshots) video.id: video,
    };

    final missing = ids.where((id) => !found.containsKey(id)).toList();
    if (missing.isNotEmpty) {
      final remote = await Future.wait([
        _safe(() => localDatasource.getVideosByIds(missing)),
        _safe(() => pixabayDatasource.getVideosByIds(missing)),
        _safe(() => giphyDatasource.getVideosByIds(missing)),
        _safe(() => vimeoDatasource.getVideosByIds(missing)),
      ]);
      for (final video in _merge(remote)) {
        found[video.id] = video;
      }
    }

    return _hydrate(
      ids.map((id) => found[id]).whereType<VideoPostExtended>().toList(),
    );
  }

  List<VideoPostExtended> _merge(List<List<VideoPostExtended>> groups) {
    final seen = <String>{};
    final combined = <VideoPostExtended>[];
    for (final group in groups) {
      for (final video in group) {
        if (seen.add(video.id)) combined.add(video);
      }
    }
    return combined;
  }

  List<VideoPostExtended> _hydrate(List<VideoPostExtended> videos) {
    return videos.map(storage.applyStoredLike).toList();
  }

  Future<List<VideoPostExtended>> _safe(
    Future<List<VideoPostExtended>> Function() fn,
  ) async {
    try {
      return await fn();
    } catch (_) {
      return [];
    }
  }
}
