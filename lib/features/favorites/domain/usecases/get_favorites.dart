import '../../../movies/domain/entities/movie.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository _repository;
  const GetFavorites(this._repository);

  Future<List<Movie>> call() => _repository.getFavorites();
}
