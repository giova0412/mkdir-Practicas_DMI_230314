import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

class GetDiscoverVideos {
  final VideoPostRepository _repository;

  GetDiscoverVideos(this._repository);

  Future<List<VideoPostExtended>> call({int page = 1}) {
    return _repository.getDiscoverVideos(page: page);
  }
}
