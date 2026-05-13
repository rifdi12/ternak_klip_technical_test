part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

final class FavoritesLoadRequested extends FavoritesEvent {
  const FavoritesLoadRequested();
}

final class FavoriteToggleRequested extends FavoritesEvent {
  final int movieId;
  const FavoriteToggleRequested(this.movieId);

  @override
  List<Object> get props => [movieId];
}
