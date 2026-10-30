import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

class MoviesNotifier extends Notifier<List<Movie>> {
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
      final movies = await repository.getNowPlaying(page: currentPage);
      state = [...state, ...movies];
    } catch (_) {
      // Ignorar errores de red en pruebas/arranque
    } finally {
      isLoading = false;
    }
  }
}

final nowPlayingMoviesProvider =
    NotifierProvider<MoviesNotifier, List<Movie>>(MoviesNotifier.new);