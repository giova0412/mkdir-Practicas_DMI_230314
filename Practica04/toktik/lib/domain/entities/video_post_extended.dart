import 'package:toktik/domain/entities/video_post.dart';

enum VideoProvider {
  local,
  giphy,
  vimeo,
  pixabay,
}

class VideoPostExtended extends VideoPost {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final VideoProvider provider;
  final bool liked;
  final String source;

  VideoPostExtended({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required super.videoUrl,
    required this.provider,
    this.liked = false,
    super.likes,
    super.views,
    this.source = '',
  }) : super(caption: title);

  bool get isFavorite => liked;

  VideoPostExtended copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? videoUrl,
    VideoProvider? provider,
    bool? liked,
    int? likes,
    int? views,
    String? source,
  }) {
    return VideoPostExtended(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      provider: provider ?? this.provider,
      liked: liked ?? this.liked,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'thumbnailUrl': thumbnailUrl,
        'videoUrl': videoUrl,
        'provider': provider.name,
        'liked': liked,
        'likes': likes,
        'views': views,
        'source': source,
      };

  factory VideoPostExtended.fromJson(Map<String, dynamic> json) {
    return VideoPostExtended(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      provider: VideoProvider.values.firstWhere(
        (p) => p.name == json['provider'],
        orElse: () => VideoProvider.local,
      ),
      liked: json['liked'] as bool? ?? false,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      source: json['source'] as String? ?? '',
    );
  }
}
