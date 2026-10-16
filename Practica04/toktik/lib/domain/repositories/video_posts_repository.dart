import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';

abstract class VideoPostRepository {
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID);

  Future<List<VideoPost>> getTrendingVideosByPage(int page);

  Future<List<VideoPostExtended>> getDiscoverVideos({int page = 1});

  Future<List<VideoPostExtended>> getForYouVideos({int page = 1});

  Future<List<VideoPostExtended>> getFavoriteVideosByIds(List<String> ids);
}
