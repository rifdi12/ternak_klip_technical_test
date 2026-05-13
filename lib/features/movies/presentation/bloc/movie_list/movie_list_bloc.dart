import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_movies_page.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetMoviesPage _getMoviesPage;
  static const _pageSize = 15;
  int _page = 0;

  MovieListBloc(this._getMoviesPage) : super(const MovieListInitial()) {
    on<MovieListStarted>(_onStarted);
    on<MovieListRefreshed>(_onRefreshed);
    on<MovieListLoadMoreRequested>(_onLoadMore);
  }

  Future<void> _onStarted(
    MovieListStarted event,
    Emitter<MovieListState> emit,
  ) async {
    _page = 0;
    emit(const MovieListLoading());
    await Future.delayed(Duration(seconds: 2));
    try {
      final movies = await _getMoviesPage(_page, _pageSize);
      _page = 1;
      emit(
        MovieListLoaded(movies: movies, hasMore: movies.length == _pageSize),
      );
    } catch (e) {
      emit(MovieListError(e.toString()));
    }
  }

  Future<void> _onRefreshed(
    MovieListRefreshed event,
    Emitter<MovieListState> emit,
  ) async {
    _page = 0;
    emit(const MovieListLoading());
    await Future.delayed(Duration(seconds: 2));
    try {
      final movies = await _getMoviesPage(_page, _pageSize);
      _page = 1;
      emit(
        MovieListLoaded(movies: movies, hasMore: movies.length == _pageSize),
      );
    } catch (e) {
      emit(MovieListError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    MovieListLoadMoreRequested event,
    Emitter<MovieListState> emit,
  ) async {
    final current = state;
    if (current is! MovieListLoaded ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }
    emit(current.copyWith(isLoadingMore: true));
    await Future.delayed(Duration(seconds: 2));
    try {
      final more = await _getMoviesPage(_page, _pageSize);
      _page++;
      emit(
        MovieListLoaded(
          movies: [...current.movies, ...more],
          hasMore: more.length == _pageSize,
        ),
      );
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}
