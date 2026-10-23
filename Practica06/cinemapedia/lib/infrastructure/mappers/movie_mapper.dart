import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb_movie.dart';

class MovieMapper {

  static Movie movieDBToEntity( MovieMovieDB movieDB ) => Movie(
    adult:            movieDB.adult,
    backdropPath:     movieDB.backdropPath.isNotEmpty ? movieDB.backdropPath : 'no-backdrop',
    genreIds:         movieDB.genreIds.map((genre) => genre.toString()).toList(),
    id:               movieDB.id,
    originalLanguage: movieDB.originalLanguage,
    originalTitle:    movieDB.originalTitle,
    overview:         movieDB.overview,
    popularity:       movieDB.popularity,
    posterPath:       movieDB.posterPath.isNotEmpty ? movieDB.posterPath : 'no-poster',
    releaseDate:      DateTime.tryParse(movieDB.releaseDate) ?? DateTime.now(),
    title:            movieDB.title,
    video:            movieDB.video,
    voteAverage:      movieDB.voteAverage,
    voteCount:        movieDB.voteCount,
  );

}
