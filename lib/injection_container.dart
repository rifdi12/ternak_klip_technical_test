import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/favorites/data/datasources/favorites_local_data_source.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/favorites/domain/usecases/get_favorites.dart';
import 'features/favorites/domain/usecases/toggle_favorite.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/movies/data/datasources/movie_local_data_source.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/get_movies_page.dart';
import 'features/movies/domain/usecases/search_movies.dart';
import 'features/movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'features/movies/presentation/bloc/search/search_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Data Sources
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl(), sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetMoviesPage(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));

  // BLoCs — factory agar setiap BlocProvider mendapat instance baru
  sl.registerFactory(() => MovieListBloc(sl()));
  sl.registerFactory(() => SearchBloc(sl()));
  sl.registerFactory(() => FavoritesBloc(sl(), sl()));
}
