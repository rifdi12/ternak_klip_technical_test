import '../../../movies/data/datasources/movie_local_data_source.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _favDataSource;
  final MovieLocalDataSource _movieDataSource;

  const FavoritesRepositoryImpl(this._favDataSource, this._movieDataSource);

  @override
  Future<List<Movie>> getFavorites() async {
    final ids = await _favDataSource.loadFavoriteIds();
    if (ids.isEmpty) return [];
    final all = await _movieDataSource.getAllMovies();
    return all.where((m) => ids.contains(m.id)).toList();
  }

  @override
  Future<void> toggleFavorite(int movieId) async {
    final ids = await _favDataSource.loadFavoriteIds();
    if (ids.contains(movieId)) {
      ids.remove(movieId);
    } else {
      ids.add(movieId);
    }
    await _favDataSource.saveFavoriteIds(ids);
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    final ids = await _favDataSource.loadFavoriteIds();
    return ids.contains(movieId);
  }
}
