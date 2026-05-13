part of 'movie_list_bloc.dart';

sealed class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

final class MovieListInitial extends MovieListState {
  const MovieListInitial();
}

final class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

final class MovieListLoaded extends MovieListState {
  final List<Movie> movies;
  final bool hasMore;
  final bool isLoadingMore;

  const MovieListLoaded({
    required this.movies,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  MovieListLoaded copyWith({
    List<Movie>? movies,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return MovieListLoaded(
      movies: movies ?? this.movies,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [movies, hasMore, isLoadingMore];
}

final class MovieListError extends MovieListState {
  final String message;
  const MovieListError(this.message);

  @override
  List<Object> get props => [message];
}
