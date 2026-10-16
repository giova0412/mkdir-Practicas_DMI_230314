import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/infrastructure/mappers/sample_network_videos.dart';

class VimeoVideoMapper {
  static VideoPostExtended fromApiItem(Map<String, dynamic> item, int index) {
    final uri = item['uri']?.toString() ?? '';
    final id = uri.replaceAll('/videos/', '').replaceAll('/', '_');
    final pics = item['pictures'] as Map<String, dynamic>? ?? {};
    final sizes = pics['sizes'] as List<dynamic>? ?? [];
    final thumb = sizes.isNotEmpty
        ? (sizes.last as Map<String, dynamic>)['link'] as String?
        : null;
    final stats = item['stats'] as Map<String, dynamic>? ?? {};
    final metadata = item['metadata'] as Map<String, dynamic>? ?? {};
    final connections = metadata['connections'] as Map<String, dynamic>? ?? {};
    final likes = connections['likes'] as Map<String, dynamic>? ?? {};

    return VideoPostExtended(
      id: 'vm_${id.isEmpty ? index : id}',
      title: item['name'] as String? ?? 'Vimeo Video $index',
      description: (item['description'] as String?)?.trim().isNotEmpty == true
          ? item['description'] as String
          : _defaultDescription(index),
      thumbnailUrl: thumb ?? '',
      // Vimeo entrega player URLs, no MP4 directos sin auth extra.
      // Se usan MP4 públicos para reproducción garantizada.
      videoUrl: SampleNetworkVideos.of(index, offset: 3),
      provider: VideoProvider.vimeo,
      likes: (likes['total'] as num?)?.toInt() ?? (500 + index * 17),
      views: (stats['plays'] as num?)?.toInt() ?? (18000 + index * 640),
      source: 'Vimeo',
    );
  }

  static VideoPostExtended fromLocalFallback({
    required String prefix,
    required int page,
    required int index,
  }) {
    return VideoPostExtended(
      id: '${prefix}_p${page}_$index',
      title: '[VM] Creación #${index + 1} (pág. $page)',
      description: _defaultDescription(index),
      thumbnailUrl: '',
      videoUrl: SampleNetworkVideos.of(index + (page * 2), offset: 3),
      provider: VideoProvider.vimeo,
      likes: 500 + index * 57 + page * 7,
      views: 18000 + index * 1400 + page * 300,
      source: 'Vimeo',
    );
  }

  static String _defaultDescription(int index) =>
      'Video de Vimeo #${index + 1}. Contenido de alta calidad para creadores.\n\n'
      'Descripción extensa del video para validar "... más" y el desplazamiento vertical. '
      'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
}
