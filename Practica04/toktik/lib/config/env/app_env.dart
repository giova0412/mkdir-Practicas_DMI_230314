import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  AppEnv._();

  static String vimeoAccessToken = '';
  static String giphyApiKey = '';
  static String pixabayApiKey = '';

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: 'assets/config/env');
    } catch (_) {
      // El archivo puede no existir en algunos entornos; se usan dart-define.
    }

    vimeoAccessToken = (dotenv.env['VIMEO_ACCESS_TOKEN']?.trim().isNotEmpty ?? false)
        ? dotenv.env['VIMEO_ACCESS_TOKEN']!.trim()
        : const String.fromEnvironment('VIMEO_ACCESS_TOKEN');

    giphyApiKey = (dotenv.env['GIPHY_API_KEY']?.trim().isNotEmpty ?? false)
        ? dotenv.env['GIPHY_API_KEY']!.trim()
        : const String.fromEnvironment('GIPHY_API_KEY');

    pixabayApiKey = (dotenv.env['PIXABAY_API_KEY']?.trim().isNotEmpty ?? false)
        ? dotenv.env['PIXABAY_API_KEY']!.trim()
        : const String.fromEnvironment('PIXABAY_API_KEY');
  }
}
