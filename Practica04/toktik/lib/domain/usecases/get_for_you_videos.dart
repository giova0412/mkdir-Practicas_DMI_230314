import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

class GetForYouVideos {
  final VideoPostRepository _repository;

  GetForYouVideos(this._repository);

  Future<List<VideoPostExtended>> call({int page = 1}) {
    return _repository.getForYouVideos(page: page);
  }
}
