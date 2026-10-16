import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';

class ToggleVideoLike {
  final LocalStorageService _storage;

  ToggleVideoLike(this._storage);

  Future<VideoPostExtended> call(VideoPostExtended video) {
    return _storage.toggleLike(video);
  }
}
