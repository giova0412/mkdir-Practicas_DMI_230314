import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toktik/config/env/app_env.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/infrastructure/mappers/vimeo_video_mapper.dart';

class VimeoVideoDatasource implements VideoPostDatasource {
  final http.Client _httpClient;
  final Duration timeout;

  VimeoVideoDatasource({
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 10),
  }) : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return getDiscoverVideos(page: page);
  }

  @override
  Future<List<VideoPostExtended>> getDiscoverVideos({int page = 1}) {
    return _load(page: page, prefix: 'vm_d', query: 'staffpick');
  }

  @override
  Future<List<VideoPostExtended>> getForYouVideos({int page = 1}) {
    return _load(page: page, prefix: 'vm_fy', query: 'creative');
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
    final token = AppEnv.vimeoAccessToken;
    if (token.isEmpty) {
      return _fallback(page, prefix);
    }

    try {
      final uri = Uri.https('api.vimeo.com', '/videos', {
        'query': query,
        'per_page': '6',
        'page': '$page',
        'sort': 'plays',
      });
      final response = await _httpClient.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/vnd.vimeo.*+json;version=3.4',
        },
      ).timeout(timeout);
      if (response.statusCode != 200) return _fallback(page, prefix);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['data'] as List<dynamic>? ?? [];
      if (items.isEmpty) return _fallback(page, prefix);
      return items.asMap().entries.map((e) {
        return VimeoVideoMapper.fromApiItem(
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
      (index) => VimeoVideoMapper.fromLocalFallback(
        prefix: prefix,
        page: page,
        index: index,
      ),
    );
  }
}
