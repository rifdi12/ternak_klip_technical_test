import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;

  FavoritesBloc(this._getFavorites, this._toggleFavorite)
      : super(const FavoritesInitial()) {
    on<FavoritesLoadRequested>(_onLoadRequested);
    on<FavoriteToggleRequested>(_onToggleRequested);
  }

  Future<void> _onLoadRequested(
    FavoritesLoadRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favorites = await _getFavorites();
      emit(FavoritesLoadSuccess(favorites));
    } catch (_) {
      emit(const FavoritesLoadSuccess([]));
    }
  }

  Future<void> _onToggleRequested(
    FavoriteToggleRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    await _toggleFavorite(event.movieId);
    final favorites = await _getFavorites();
    emit(FavoritesLoadSuccess(favorites));
  }
}
