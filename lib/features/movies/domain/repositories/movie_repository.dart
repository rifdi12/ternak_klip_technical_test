import '../entities/movie.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> getAllMovies();
  Future<List<Movie>> getMoviesPage(int page, int pageSize);
  Future<List<Movie>> searchMovies(String query);
}
