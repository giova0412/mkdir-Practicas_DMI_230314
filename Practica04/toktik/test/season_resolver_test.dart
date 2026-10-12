import 'package:flutter_test/flutter_test.dart';
import 'package:toktik/config/theme/season_resolver.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';

void main() {
  group('SeasonResolver', () {
    test('selecciona Halloween a finales de octubre', () {
      expect(
        SeasonResolver.resolveByDate(DateTime(2026, 10, 31)),
        Season.halloween,
      );
    });

    test('selecciona Christmas en diciembre', () {
      expect(
        SeasonResolver.resolveByDate(DateTime(2026, 12, 24)),
        Season.christmas,
      );
    });

    test('selecciona Valentine en febrero', () {
      expect(
        SeasonResolver.resolveByDate(DateTime(2026, 2, 14)),
        Season.valentine,
      );
    });

    test('usa Normal fuera de temporada', () {
      expect(
        SeasonResolver.resolveByDate(DateTime(2026, 6, 8)),
        Season.normal,
      );
    });
  });

  test('VideoPostExtended serializa el modelo unificado', () {
    final video = VideoPostExtended(
      id: 'pb_1',
      title: 'Demo',
      description: 'Desc',
      thumbnailUrl: 'x',
      videoUrl: 'assets/videos/1.mp4',
      provider: VideoProvider.pixabay,
      liked: true,
      likes: 10,
      views: 20,
      source: 'Pixabay',
    );

    final restored = VideoPostExtended.fromJson(video.toJson());
    expect(restored.id, 'pb_1');
    expect(restored.liked, isTrue);
    expect(restored.provider, VideoProvider.pixabay);
  });
}
