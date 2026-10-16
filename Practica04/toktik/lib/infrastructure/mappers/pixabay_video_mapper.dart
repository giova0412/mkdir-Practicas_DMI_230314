import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/infrastructure/mappers/sample_network_videos.dart';

/// Pixabay devuelve MP4 DIRECTOS (videos.medium.url), así que sí se pueden
/// reproducir con video_player sin trucos. Rápida y con keys disponibles
/// (Pexels suspendió emisión de keys nuevas).
class PixabayVideoMapper {
  static VideoPostExtended fromApiItem(Map<String, dynamic> item, int index) {
    final id = '${item['id'] ?? 'pb_$index'}';
    final tags = (item['tags'] as String?)?.trim() ?? '';
    final pageUrl = item['pageURL'] as String? ?? '';
    final duration = (item['duration'] as num?)?.toInt() ?? 0;
    final user = (item['user'] as String?)?.trim().isNotEmpty == true
        ? item['user'] as String
        : 'Pixabay Creator';

    final videos = item['videos'] as Map<String, dynamic>?;
    final preview = item['previewURL'] as String? ??
        item['userImageURL'] as String? ??
        '';

    return VideoPostExtended(
      id: 'pb_$id',
      title: tags.isNotEmpty ? _titleCase(tags.split(',').first.trim()) : 'Pixabay · $user',
      description:
          '${tags.isNotEmpty ? tags : "Video de Pixabay #$id por $user."}\n\nDuración: ${_fmtDuration(duration)}. '
          'Fuente original: $pageUrl\n\n'
          'Este video es un MP4 directo de Pixabay, por eso carga al instante en el emulador. '
          'Descripción extensa para probar "... más" y el scroll vertical.',
      thumbnailUrl: preview,
      videoUrl: _pickFastMp4(videos) ?? SampleNetworkVideos.of(index, offset: 2),
      provider: VideoProvider.pixabay,
      likes: 700 + (id.hashCode.abs() % 3500) + index * 11,
      views: 20000 + (id.hashCode.abs() % 80000) + index * 650,
      source: 'Pixabay',
    );
  }

  /// Prefiere tiny/small (livianos para emulador) y solo si no hay usa medium.
  /// Se evita 'large' a propósito: en vertical es 2160x3840/4096 y el
  /// decoder del emulador (goldfish) marca NoSupport / Format exceeds.
  static String? _pickFastMp4(Map<String, dynamic>? videos) {
    if (videos == null) return null;
    for (final key in ['tiny', 'small', 'medium']) {
      final v = videos[key] as Map<String, dynamic>?;
      final url = v?['url'] as String?;
      if (url != null && url.startsWith('http')) return url;
    }
    return null;
  }

  static String _titleCase(String s) {
    if (s.isEmpty) return s;
    final words = s.split(' ');
    return words
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  static String _fmtDuration(int seconds) {
    if (seconds <= 0) return 'video corto';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m == 0) return '${s}s';
    return '${m}m ${s}s';
  }

  static VideoPostExtended fromLocalFallback({
    required String prefix,
    required int page,
    required int index,
  }) {
    return VideoPostExtended(
      id: '${prefix}_p${page}_$index',
      title: '[PB] Clip #${index + 1} (pág. $page)',
      description:
          'Clip de muestra Pixabay #${index + 1}.\n\nAgrega tu PIXABAY_API_KEY en assets/config/env '
          '(gratis en pixabay.com/api/docs) para ver videos reales con MP4 directos.',
      thumbnailUrl: '',
      videoUrl: SampleNetworkVideos.of(index + (page * 2), offset: 2),
      provider: VideoProvider.pixabay,
      likes: 700 + index * 53 + page * 5,
      views: 20000 + index * 1600 + page * 300,
      source: 'Pixabay',
    );
  }
}
