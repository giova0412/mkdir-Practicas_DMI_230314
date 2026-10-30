import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

enum MovieCategory { nowPlaying, popular, upcoming, topRated }

class MoviesNotifier extends Notifier<List<Movie>> {
  final MovieCategory category;
  MoviesNotifier(this.category);

  int currentPage = 0;
  bool isLoading = false;

  @override
  List<Movie> build() => [];

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    try {
      final repository = ref.read(movieRepositoryProvider);
      final List<Movie> movies;
      switch (category) {
        case MovieCategory.nowPlaying:
          movies = await repository.getNowPlaying(page: currentPage);
          break;
        case MovieCategory.popular:
          movies = await repository.getPopular(page: currentPage);
          break;
        case MovieCategory.upcoming:
          movies = await repository.getUpcoming(page: currentPage);
          break;
        case MovieCategory.topRated:
          movies = await repository.getTopRated(page: currentPage);
          break;
      }
      state = [...state, ...movies];
    } catch (_) {
      // Ignorar errores de red en pruebas/arranque
    } finally {
      isLoading = false;
    }
  }
}

final moviesProvider =
    NotifierProvider.family<MoviesNotifier, List<Movie>, MovieCategory>(
  (category) => MoviesNotifier(category),
);

final nowPlayingMoviesProvider = moviesProvider(MovieCategory.nowPlaying);
final popularMoviesProvider = moviesProvider(MovieCategory.popular);
final upcomingMoviesProvider = moviesProvider(MovieCategory.upcoming);
final topRatedMoviesProvider = moviesProvider(MovieCategory.topRated);