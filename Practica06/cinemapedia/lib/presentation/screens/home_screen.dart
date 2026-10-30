import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      appBar: const CustomAppbar(),
      body: nowPlayingMovies.isEmpty
          ? const Center(child: Text('Cargando películas...'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isWide ? 24 : 16,
                    12,
                    isWide ? 24 : 16,
                    4,
                  ),
                  child: Text(
                    'En cines',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                MoviesSlideshow(movies: nowPlayingMovies),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isWide ? 24 : 16,
                    8,
                    isWide ? 24 : 16,
                    4,
                  ),
                  child: Text(
                    'Populares',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 24 : 12,
                      vertical: 8,
                    ),
                    itemCount: nowPlayingMovies.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final movie = nowPlayingMovies[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: movie.posterPath.startsWith('http')
                                ? Image.network(
                                    movie.posterPath,
                                    width: 60,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset('assets/image.png',
                                                width: 60,
                                                height: 90,
                                                fit: BoxFit.cover),
                                  )
                                : Image.asset(movie.posterPath,
                                    width: 60,
                                    height: 90,
                                    fit: BoxFit.cover),
                          ),
                          title: Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}