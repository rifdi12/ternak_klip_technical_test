import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/search_movies.dart';

part 'search_event.dart';
part 'search_state.dart';

EventTransformer<T> _debounce<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc(this._searchMovies) : super(const SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );
    on<SearchCleared>(_onCleared);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }
    emit(const SearchLoading());
    try {
      final results = await _searchMovies(query);
      emit(results.isEmpty
          ? SearchEmpty(query)
          : SearchSuccess(results: results, query: query));
    } catch (_) {
      emit(SearchEmpty(query));
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchInitial());
  }
}
