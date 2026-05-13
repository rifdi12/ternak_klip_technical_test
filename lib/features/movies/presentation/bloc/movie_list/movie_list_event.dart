part of 'movie_list_bloc.dart';

sealed class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

final class MovieListStarted extends MovieListEvent {
  const MovieListStarted();
}

final class MovieListRefreshed extends MovieListEvent {
  const MovieListRefreshed();
}

final class MovieListLoadMoreRequested extends MovieListEvent {
  const MovieListLoadMoreRequested();
}
