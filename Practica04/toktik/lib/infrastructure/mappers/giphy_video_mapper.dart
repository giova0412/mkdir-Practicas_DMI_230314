import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/infrastructure/mappers/sample_network_videos.dart';

/// Giphy devuelve MP4 DIRECTOS (images.original.mp4), clips cortos ideales
/// para un feed vertical estilo TikTok. Key gratis en developers.giphy.com.
class GiphyVideoMapper {
  static VideoPostExtended fromApiItem(Map<String, dynamic> item, int index) {
    final id = '${item['id'] ?? 'gf_$index'}';
    final rawTitle = (item['title'] as String?)?.trim() ?? '';
    final user = item['user'] as Map<String, dynamic>?;
    final author = (user?['display_name'] as String?)?.trim().isNotEmpty == true
        ? user!['display_name'] as String
        : ((user?['username'] as String?)?.trim().isNotEmpty == true
            ? '@${user!['username']}'
            : 'Giphy Creator');
    final pageUrl = item['url'] as String? ?? 'https://giphy.com/gifs/$id';

    final images = item['images'] as Map<String, dynamic>?;
    // En emulador se prefieren variantes chicas: original es pesado.
    String? mp4;
    for (final key in [
      'fixed_height_small',
      'fixed_width_small',
      'downsized_small',
      'fixed_height',
      'downsized',
      'original',
    ]) {
      final variant = images?[key] as Map<String, dynamic>?;
      final candidate = variant?['mp4'] as String?;
      if (candidate != null && candidate.startsWith('http')) {
        mp4 = candidate;
        break;
      }
    }
    final still = images?['fixed_height_still'] as Map<String, dynamic>?;
    final preview = images?['preview_gif'] as Map<String, dynamic>?;
    String thumb = (still?['url'] as String?) ?? '';
    if (!thumb.startsWith('http')) {
      thumb = (preview?['url'] as String?) ?? '';
    }

    return VideoPostExtended(
      id: 'gf_$id',
      title: rawTitle.isNotEmpty ? _cleanTitle(rawTitle) : 'Giphy · $author',
      description:
          '${rawTitle.isNotEmpty ? rawTitle : "GIF de Giphy por $author."}\n\nAutor: $author. '
          'Fuente original: $pageUrl\n\n'
          'Clip corto de Giphy en MP4 directo, ideal para el feed vertical. '
          'Descripción extensa para probar "... más" y el scroll vertical.',
      thumbnailUrl: thumb,
      videoUrl: (mp4 != null && mp4.startsWith('http'))
          ? mp4
          : SampleNetworkVideos.of(index, offset: 5),
      provider: VideoProvider.giphy,
      likes: 600 + (id.hashCode.abs() % 3000) + index * 9,
      views: 15000 + (id.hashCode.abs() % 70000) + index * 550,
      source: 'Giphy',
    );
  }

  static String _cleanTitle(String s) {
    // "Funny Cat GIF by X" -> "Funny Cat"
    final cut = s.indexOf(' GIF');
    final base = (cut > 0 ? s.substring(0, cut) : s).trim();
    if (base.isEmpty) return s;
    return base[0].toUpperCase() + base.substring(1);
  }

  static VideoPostExtended fromLocalFallback({
    required String prefix,
    required int page,
    required int index,
  }) {
    return VideoPostExtended(
      id: '${prefix}_p${page}_$index',
      title: '[GF] Clip #${index + 1} (pág. $page)',
      description:
          'Clip de muestra Giphy #${index + 1}.\n\nAgrega tu GIPHY_API_KEY en assets/config/env '
          '(gratis en developers.giphy.com/dashboard) para ver GIFs reales en MP4 directo.',
      thumbnailUrl: '',
      videoUrl: SampleNetworkVideos.of(index + (page * 2), offset: 5),
      provider: VideoProvider.giphy,
      likes: 600 + index * 47 + page * 5,
      views: 15000 + index * 1300 + page * 250,
      source: 'Giphy',
    );
  }
}
