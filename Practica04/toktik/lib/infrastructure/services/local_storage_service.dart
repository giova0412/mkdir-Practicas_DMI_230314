import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';

class LocalStorageService {
  static const String _kSeasonModeKey = 'season_mode';
  static const String _kVideoLikesKey = 'video_likes';
  static const String _kFavoriteVideosKey = 'favorite_videos';

  final SharedPreferences _prefs;

  LocalStorageService._(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService._(prefs);
  }

  Season getSeasonMode() => SeasonX.fromStorage(_prefs.getString(_kSeasonModeKey));

  Future<void> setSeasonMode(Season season) async {
    await _prefs.setString(_kSeasonModeKey, season.storageKey);
  }

  Map<String, dynamic> getVideoLikes(String videoId) {
    return _getAllVideoLikesMap()[videoId] ?? const {};
  }

  Map<String, Map<String, dynamic>> getAllVideoLikes() => _getAllVideoLikesMap();

  Future<VideoPostExtended> toggleLike(VideoPostExtended video) async {
    final stored = getVideoLikes(video.id);
    final wasLiked = stored['liked'] as bool? ?? video.liked;
    final currentLikes = (stored['likes'] as num?)?.toInt() ?? video.likes;

    final newLiked = !wasLiked;
    final newLikes = newLiked
        ? currentLikes + 1
        : (currentLikes - 1).clamp(0, 1 << 31);

    await _setVideoLikes(video.id, liked: newLiked, likes: newLikes);

    final updated = video.copyWith(liked: newLiked, likes: newLikes);
    if (newLiked) {
      await _upsertFavoriteSnapshot(updated);
    } else {
      await _removeFavoriteSnapshot(video.id);
    }
    return updated;
  }

  Future<void> _setVideoLikes(
    String videoId, {
    required bool liked,
    required int likes,
  }) async {
    final allData = _getAllVideoLikesMap();
    allData[videoId] = {
      'liked': liked,
      'likes': likes < 0 ? 0 : likes,
    };
    await _prefs.setString(_kVideoLikesKey, json.encode(allData));
  }

  Map<String, Map<String, dynamic>> _getAllVideoLikesMap() {
    final raw = _prefs.getString(_kVideoLikesKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      return decoded.map(
        (k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)),
      );
    } catch (_) {
      return {};
    }
  }

  VideoPostExtended applyStoredLike(VideoPostExtended video) {
    final stored = getVideoLikes(video.id);
    if (stored.isEmpty) return video;
    return video.copyWith(
      liked: stored['liked'] as bool? ?? video.liked,
      likes: (stored['likes'] as num?)?.toInt() ?? video.likes,
    );
  }

  Set<String> getFavoriteVideoIds() {
    final fromLikes = _getAllVideoLikesMap().entries
        .where((e) => e.value['liked'] == true)
        .map((e) => e.key)
        .toSet();
    fromLikes.addAll(_getFavoriteSnapshotsMap().keys);
    return fromLikes;
  }

  List<VideoPostExtended> getFavoriteSnapshots() {
    final likes = _getAllVideoLikesMap();
    return _getFavoriteSnapshotsMap().values.map((video) {
      final stored = likes[video.id];
      if (stored == null) return video.copyWith(liked: true);
      return video.copyWith(
        liked: stored['liked'] as bool? ?? true,
        likes: (stored['likes'] as num?)?.toInt() ?? video.likes,
      );
    }).where((v) => v.liked).toList();
  }

  Map<String, VideoPostExtended> _getFavoriteSnapshotsMap() {
    final raw = _prefs.getString(_kFavoriteVideosKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      return decoded.map(
        (k, v) => MapEntry(
          k,
          VideoPostExtended.fromJson(Map<String, dynamic>.from(v as Map)),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> _upsertFavoriteSnapshot(VideoPostExtended video) async {
    final all = _getFavoriteSnapshotsMap();
    all[video.id] = video;
    await _saveSnapshots(all);
  }

  Future<void> _removeFavoriteSnapshot(String videoId) async {
    final all = _getFavoriteSnapshotsMap();
    all.remove(videoId);
    await _saveSnapshots(all);
  }

  Future<void> _saveSnapshots(Map<String, VideoPostExtended> all) async {
    await _prefs.setString(
      _kFavoriteVideosKey,
      json.encode(all.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }
}
