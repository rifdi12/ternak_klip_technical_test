import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository _repository;
  const ToggleFavorite(this._repository);

  Future<void> call(int movieId) => _repository.toggleFavorite(movieId);
}
