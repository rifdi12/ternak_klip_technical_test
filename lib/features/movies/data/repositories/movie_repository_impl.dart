import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieLocalDataSource _dataSource;
  const MovieRepositoryImpl(this._dataSource);

  @override
  Future<List<Movie>> getAllMovies() => _dataSource.getAllMovies();

  @override
  Future<List<Movie>> getMoviesPage(int page, int pageSize) async {
    final all = await _dataSource.getAllMovies();
    final start = page * pageSize;
    if (start >= all.length) return [];
    final end = (start + pageSize).clamp(0, all.length);
    return all.sublist(start, end);
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    final all = await _dataSource.getAllMovies();
    final lower = query.toLowerCase();
    return all.where((m) => m.title.toLowerCase().contains(lower)).toList();
  }
}
