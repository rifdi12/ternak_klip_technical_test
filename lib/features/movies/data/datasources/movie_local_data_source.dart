import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/movie_model.dart';

abstract interface class MovieLocalDataSource {
  Future<List<MovieModel>> getAllMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static List<MovieModel>? _cache;

  @override
  Future<List<MovieModel>> getAllMovies() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/movies.json');
    final data = json.decode(raw) as List<dynamic>;
    _cache = data
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }
}
