import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toktik/config/env/app_env.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/infrastructure/mappers/pixabay_video_mapper.dart';

/// Datasource rápido: Pixabay responde en ~300-600ms y da MP4 directos.
/// Keys gratis e inmediatas en https://pixabay.com/api/docs/
/// Sin key usa fallback local (clips ligeros) para no bloquear el feed.
class PixabayVideoDatasource implements VideoPostDatasource {
  final http.Client _httpClient;
  final Duration timeout;

  PixabayVideoDatasource({
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 8),
  }) : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return getDiscoverVideos(page: page);
  }

  @override
  Future<List<VideoPostExtended>> getDiscoverVideos({int page = 1}) {
    return _load(page: page, prefix: 'pb_d', query: 'nature vertical');
  }

  @override
  Future<List<VideoPostExtended>> getForYouVideos({int page = 1}) {
    return _load(page: page, prefix: 'pb_fy', query: 'city people');
  }

  @override
  Future<List<VideoPostExtended>> getVideosByIds(List<String> ids) async {
    final all = [...await getDiscoverVideos(), ...await getForYouVideos()];
    return all.where((v) => ids.contains(v.id)).toList();
  }

  Future<List<VideoPostExtended>> _load({
    required int page,
    required String prefix,
    required String query,
  }) async {
    final key = AppEnv.pixabayApiKey;
    if (key.isEmpty) {
      return _fallback(page, prefix);
    }
    try {
      final uri = Uri.https('pixabay.com', '/api/videos/', {
        'key': key,
        'q': query,
        'per_page': '6',
        'page': '$page',
        'safesearch': 'true',
      });
      final response =
          await _httpClient.get(uri).timeout(timeout);
      if (response.statusCode != 200) return _fallback(page, prefix);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['hits'] as List<dynamic>? ?? [];
      if (items.isEmpty) return _fallback(page, prefix);
      return items.asMap().entries.map((e) {
        return PixabayVideoMapper.fromApiItem(
          e.value as Map<String, dynamic>,
          e.key,
        );
      }).toList();
    } catch (_) {
      return _fallback(page, prefix);
    }
  }

  List<VideoPostExtended> _fallback(int page, String prefix) {
    return List.generate(
      4,
      (index) => PixabayVideoMapper.fromLocalFallback(
        prefix: prefix,
        page: page,
        index: index,
      ),
    );
  }
}
