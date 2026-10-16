// MP4 públicos, PEQUEÑOS y verificados (HTTP 200) desde la red del alumno.
// video_player NO puede reproducir páginas web de video, solo archivos
// directos .mp4. Por eso los mappers conservan los metadatos reales de cada
// API (título, descripción, likes, views, thumbnail) pero usan estos MP4
// como `videoUrl` reproducible.
//
// IMPORTANTE: el bucket de Google (commondatastorage...) devuelve 403 en
// esta red, así que se usan SOLO hosts verificados: test-videos (1 MB),
// w3schools, MDN y filesamples. Todos cargan en 1-2s en el emulador.
//
// Los assets locales (`assets/videos/*.mp4`) se siguen usando en
// LocalVideoDatasource como prueba de "Manejo de assets".
class SampleNetworkVideos {
  static const List<String> urls = [
    // ~1 MB cada uno, carga instantánea en emulador.
    'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4',
    'https://test-videos.co.uk/vids/jellyfish/mp4/h264/360/Jellyfish_360_10s_1MB.mp4',
    'https://test-videos.co.uk/vids/sintel/mp4/h264/360/Sintel_360_10s_1MB.mp4',
    'https://www.w3schools.com/html/mov_bbb.mp4',
    'https://www.w3schools.com/html/movie.mp4',
    'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
    'https://filesamples.com/samples/video/mp4/sample_640x360.mp4',
    'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4',
  ];

  static String of(int index, {int offset = 0}) {
    return urls[(index + offset) % urls.length];
  }
}
