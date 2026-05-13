import '../../../movies/domain/entities/movie.dart';

abstract interface class FavoritesRepository {
  Future<List<Movie>> getFavorites();
  Future<void> toggleFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
}
