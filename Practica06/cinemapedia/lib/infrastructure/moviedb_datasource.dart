import 'package:cinemapedia/config/theme/constants/enviroment.dart';
import 'package:cinemapedia/domain/entities/datasources/movie_datasources.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MovieDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX'
    }
  ));

  @override
  Future<List<Movie>> getNowPlaying({ int page = 1 }) async {

    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: { 'page': page }
    );

    final movieDbResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDbResponse.results
        .map((movieDB) => MovieMapper.movieDBToEntity(movieDB))
        .where((movie) => movie.posterPath != 'no-poster')
        .toList();

    return movies;
  }

}
