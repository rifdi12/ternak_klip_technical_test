import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMoviesPage {
  final MovieRepository _repository;
  const GetMoviesPage(this._repository);

  Future<List<Movie>> call(int page, int pageSize) =>
      _repository.getMoviesPage(page, pageSize);
}
