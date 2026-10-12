import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';

class LocalVideoModel {
  final String name;
  final String videoUrl;
  final int likes;
  final int views;

  LocalVideoModel({
    required this.name,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
  });

  factory LocalVideoModel.fromJson(Map<String, dynamic> json) =>
      LocalVideoModel(
        name: json['name'] ?? 'No name',
        videoUrl: json['videoUrl'],
        likes: json['likes'] ?? 0,
        views: json['views'] ?? 0,
      );

  VideoPost toVideoPostEntity() => VideoPost(
        caption: name,
        videoUrl: videoUrl,
        likes: likes,
        views: views,
      );

  VideoPostExtended toExtended({
    required String id,
    required String description,
    VideoProvider provider = VideoProvider.local,
    String source = 'Local Assets',
    String? title,
  }) {
    return VideoPostExtended(
      id: id,
      title: title ?? name,
      description: description,
      thumbnailUrl: videoUrl,
      videoUrl: videoUrl,
      provider: provider,
      likes: likes,
      views: views,
      source: source,
    );
  }
}
