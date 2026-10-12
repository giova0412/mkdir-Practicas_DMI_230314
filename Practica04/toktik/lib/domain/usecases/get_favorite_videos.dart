import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';

class GetFavoriteVideos {
  final VideoPostRepository _repository;
  final LocalStorageService _storage;

  GetFavoriteVideos(this._repository, this._storage);

  Future<List<VideoPostExtended>> call() async {
    final snapshots = _storage.getFavoriteSnapshots();
    if (snapshots.isNotEmpty) {
      return snapshots;
    }

    final ids = _storage.getFavoriteVideoIds().toList();
    if (ids.isEmpty) return [];
    return _repository.getFavoriteVideosByIds(ids);
  }
}
