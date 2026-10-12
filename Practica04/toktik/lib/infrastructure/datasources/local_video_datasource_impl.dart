import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';
import 'package:toktik/shared/data/local_video_posts.dart';

class LocalVideoDatasource implements VideoPostDatasource {
  List<VideoPostExtended> _all() {
    return videoPosts.asMap().entries.map((entry) {
      final idx = entry.key;
      final model = LocalVideoModel.fromJson(entry.value);
      return model.toExtended(
        id: 'local_$idx',
        description: _description(model.name, idx),
      );
    }).toList();
  }

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _all();
  }

  @override
  Future<List<VideoPostExtended>> getDiscoverVideos({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _all();
  }

  @override
  Future<List<VideoPostExtended>> getForYouVideos({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final reversed = videoPosts.reversed.toList();
    return reversed.asMap().entries.map((entry) {
      final idx = entry.key;
      final model = LocalVideoModel.fromJson(entry.value);
      return model.toExtended(
        id: 'local_fy_$idx',
        title: '[For You] ${model.name}',
        description: _description('${model.name} — recomendado para ti', idx),
        source: 'Local ForYou',
      );
    }).toList();
  }

  @override
  Future<List<VideoPostExtended>> getVideosByIds(List<String> ids) async {
    final discover = await getDiscoverVideos();
    final forYou = await getForYouVideos();
    return [...discover, ...forYou].where((v) => ids.contains(v.id)).toList();
  }

  String _description(String title, int index) {
    return '$title\n\n'
        'Bienvenido al video ${index + 1} de VidFlow. '
        'Esta es una descripción extensa del video para comprobar el recorte, '
        'el enlace "... más" y el desplazamiento vertical cuando se expande. '
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
        'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
        'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.';
  }
}
