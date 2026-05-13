part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {
  const SearchInitial();
}

final class SearchLoading extends SearchState {
  const SearchLoading();
}

final class SearchSuccess extends SearchState {
  final List<Movie> results;
  final String query;
  const SearchSuccess({required this.results, required this.query});

  @override
  List<Object> get props => [results, query];
}

final class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);

  @override
  List<Object> get props => [query];
}
