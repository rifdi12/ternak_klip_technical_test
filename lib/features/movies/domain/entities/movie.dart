import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final double voteAverage;
  final int runtime;
  final List<String> genres;
  final String posterUrl;
  final String backdropUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.runtime,
    required this.genres,
    required this.posterUrl,
    required this.backdropUrl,
  });

  int get year {
    try {
      return int.parse(releaseDate.substring(0, 4));
    } catch (_) {
      return 0;
    }
  }

  @override
  List<Object> get props => [id];
}
