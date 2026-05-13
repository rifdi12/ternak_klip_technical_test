part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoadSuccess extends FavoritesState {
  final List<Movie> favorites;

  const FavoritesLoadSuccess(this.favorites);

  Set<int> get favoriteIds => favorites.map((m) => m.id).toSet();

  bool isFavorite(int id) => favoriteIds.contains(id);

  @override
  List<Object> get props => [favorites];
}
