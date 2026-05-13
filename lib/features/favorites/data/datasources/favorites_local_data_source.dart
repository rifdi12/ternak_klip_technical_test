import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class FavoritesLocalDataSource {
  Future<Set<int>> loadFavoriteIds();
  Future<void> saveFavoriteIds(Set<int> ids);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences _prefs;
  static const _key = 'favorite_movie_ids';

  const FavoritesLocalDataSourceImpl(this._prefs);

  @override
  Future<Set<int>> loadFavoriteIds() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return {};
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => e as int).toSet();
  }

  @override
  Future<void> saveFavoriteIds(Set<int> ids) async {
    await _prefs.setString(_key, jsonEncode(ids.toList()));
  }
}
