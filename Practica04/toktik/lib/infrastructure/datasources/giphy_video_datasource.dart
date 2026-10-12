import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toktik/config/env/app_env.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/infrastructure/mappers/giphy_video_mapper.dart';

/// Datasource de clips cortos: Giphy responde rápido y da MP4 directos.
/// Key gratis en https://developers.giphy.com/dashboard/
/// Sin key usa fallback local (clips ligeros verificados) para no bloquear.
class GiphyVideoDatasource implements VideoPostDatasource {
  final http.Client _httpClient;
  final Duration timeout;

  GiphyVideoDatasource({
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
    return _trending(page: page, prefix: 'gf_d');
  }

  @override
  Future<List<VideoPostExtended>> getForYouVideos({int page = 1}) {
    return _search(page: page, prefix: 'gf_fy', query: 'funny');
  }

  @override
  Future<List<VideoPostExtended>> getVideosByIds(List<String> ids) async {
    final all = [...await getDiscoverVideos(), ...await getForYouVideos()];
    return all.where((v) => ids.contains(v.id)).toList();
  }

  Future<List<VideoPostExtended>> _trending({
    required int page,
    required String prefix,
  }) async {
    final key = AppEnv.giphyApiKey;
    if (key.isEmpty) return _fallback(page, prefix);
    try {
      final uri = Uri.https('api.giphy.com', '/v1/gifs/trending', {
        'api_key': key,
        'limit': '6',
        'offset': '${(page - 1) * 6}',
        'rating': 'g',
      });
      final response = await _httpClient.get(uri).timeout(timeout);
      if (response.statusCode != 200) return _fallback(page, prefix);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['data'] as List<dynamic>? ?? [];
      if (items.isEmpty) return _fallback(page, prefix);
      return items.asMap().entries.map((e) {
        return GiphyVideoMapper.fromApiItem(
          e.value as Map<String, dynamic>,
          e.key,
        );
      }).toList();
    } catch (_) {
      return _fallback(page, prefix);
    }
  }

  Future<List<VideoPostExtended>> _search({
    required int page,
    required String prefix,
    required String query,
  }) async {
    final key = AppEnv.giphyApiKey;
    if (key.isEmpty) return _fallback(page, prefix);
    try {
      final uri = Uri.https('api.giphy.com', '/v1/gifs/search', {
        'api_key': key,
        'q': query,
        'limit': '6',
        'offset': '${(page - 1) * 6}',
        'rating': 'g',
        'lang': 'es',
      });
      final response = await _httpClient.get(uri).timeout(timeout);
      if (response.statusCode != 200) return _fallback(page, prefix);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['data'] as List<dynamic>? ?? [];
      if (items.isEmpty) return _fallback(page, prefix);
      return items.asMap().entries.map((e) {
        return GiphyVideoMapper.fromApiItem(
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
      (index) => GiphyVideoMapper.fromLocalFallback(
        prefix: prefix,
        page: page,
        index: index,
      ),
    );
  }
}
