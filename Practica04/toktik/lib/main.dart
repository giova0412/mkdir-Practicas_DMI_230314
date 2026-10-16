import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/env/app_env.dart';
import 'package:toktik/domain/usecases/get_discover_videos.dart';
import 'package:toktik/domain/usecases/get_favorite_videos.dart';
import 'package:toktik/domain/usecases/get_for_you_videos.dart';
import 'package:toktik/domain/usecases/toggle_video_like.dart';
import 'package:toktik/infrastructure/datasources/giphy_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/pixabay_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/vimeo_video_datasource.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/favorites_provider.dart';
import 'package:toktik/presentation/providers/for_you_provider.dart';
import 'package:toktik/presentation/providers/playback_controller.dart';
import 'package:toktik/presentation/providers/season_theme_manager.dart';
import 'package:toktik/presentation/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  final storage = await LocalStorageService.init();
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final LocalStorageService storage;

  const MyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    final repository = VideoPostsRepositoryImpl(
      localDatasource: LocalVideoDatasource(),
      giphyDatasource: GiphyVideoDatasource(),
      vimeoDatasource: VimeoVideoDatasource(),
      pixabayDatasource: PixabayVideoDatasource(),
      storage: storage,
    );

    final toggleLike = ToggleVideoLike(storage);

    return MultiProvider(
      providers: [
        Provider.value(value: storage),
        ChangeNotifierProvider(
          create: (_) => SeasonThemeManager(storage),
        ),
        ChangeNotifierProvider(create: (_) => PlaybackController()),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => DiscoverProvider(
            getDiscoverVideosUseCase: GetDiscoverVideos(repository),
            toggleVideoLikeUseCase: toggleLike,
          )..load(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ForYouProvider(
            getForYouVideosUseCase: GetForYouVideos(repository),
            toggleVideoLikeUseCase: toggleLike,
          )..load(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => FavoritesProvider(
            getFavoriteVideosUseCase: GetFavoriteVideos(repository, storage),
            toggleVideoLikeUseCase: toggleLike,
          )..load(),
        ),
      ],
      child: Consumer<SeasonThemeManager>(
        builder: (context, seasons, _) {
          return MaterialApp(
            title: 'VidFlow',
            debugShowCheckedModeBanner: false,
            theme: seasons.materialTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
