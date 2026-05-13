import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository _repository;
  const SearchMovies(this._repository);

  Future<List<Movie>> call(String query) => _repository.searchMovies(query);
}
