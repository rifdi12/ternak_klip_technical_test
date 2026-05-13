import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ternak_klip_technical_test/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:ternak_klip_technical_test/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:ternak_klip_technical_test/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:ternak_klip_technical_test/features/movies/data/models/movie_model.dart';

class MockFavoritesLocalDataSource extends Mock
    implements FavoritesLocalDataSource {}

class MockMovieLocalDataSource extends Mock implements MovieLocalDataSource {}

void main() {
  late MockFavoritesLocalDataSource mockFavDataSource;
  late MockMovieLocalDataSource mockMovieDataSource;
  late FavoritesRepositoryImpl repository;

  const tMovies = [
    MovieModel(
      id: 1,
      title: 'Inception',
      overview: 'A thief who steals corporate secrets',
      releaseDate: '2010-07-16',
      voteAverage: 8.8,
      runtime: 148,
      genres: ['Action', 'Sci-Fi'],
      posterUrl: 'https://example.com/inception.jpg',
      backdropUrl: 'https://example.com/inception_backdrop.jpg',
    ),
    MovieModel(
      id: 2,
      title: 'The Dark Knight',
      overview: 'Batman faces the Joker',
      releaseDate: '2008-07-18',
      voteAverage: 9.0,
      runtime: 152,
      genres: ['Action', 'Crime'],
      posterUrl: 'https://example.com/tdk.jpg',
      backdropUrl: 'https://example.com/tdk_backdrop.jpg',
    ),
  ];

  setUp(() {
    mockFavDataSource = MockFavoritesLocalDataSource();
    mockMovieDataSource = MockMovieLocalDataSource();
    repository = FavoritesRepositoryImpl(mockFavDataSource, mockMovieDataSource);
    registerFallbackValue(<int>{});
  });

  group('getFavorites', () {
    test('returns movies that match saved favorite IDs', () async {
      when(() => mockFavDataSource.loadFavoriteIds())
          .thenAnswer((_) async => {1});
      when(() => mockMovieDataSource.getAllMovies())
          .thenAnswer((_) async => tMovies);

      final result = await repository.getFavorites();

      expect(result, [tMovies.first]);
      verify(() => mockFavDataSource.loadFavoriteIds()).called(1);
      verify(() => mockMovieDataSource.getAllMovies()).called(1);
    });

    test('returns empty list without hitting movie source when no favorites', () async {
      when(() => mockFavDataSource.loadFavoriteIds())
          .thenAnswer((_) async => {});

      final result = await repository.getFavorites();

      expect(result, isEmpty);
      verifyNever(() => mockMovieDataSource.getAllMovies());
    });

    test('propagates exception when data source throws', () async {
      when(() => mockFavDataSource.loadFavoriteIds())
          .thenThrow(Exception('SharedPreferences unavailable'));

      expect(repository.getFavorites(), throwsException);
    });
  });

  group('toggleFavorite', () {
    test('adds movieId to favorites when not already favorited', () async {
      when(() => mockFavDataSource.loadFavoriteIds())
          .thenAnswer((_) async => {2});
      when(() => mockFavDataSource.saveFavoriteIds(any()))
          .thenAnswer((_) async {});

      await repository.toggleFavorite(1);

      final captured =
          verify(() => mockFavDataSource.saveFavoriteIds(captureAny()))
              .captured;
      expect(captured.first as Set<int>, containsAll([1, 2]));
    });

    test('removes movieId from favorites when already favorited', () async {
      when(() => mockFavDataSource.loadFavoriteIds())
          .thenAnswer((_) async => {1, 2});
      when(() => mockFavDataSource.saveFavoriteIds(any()))
          .thenAnswer((_) async {});

      await repository.toggleFavorite(1);

      final captured =
          verify(() => mockFavDataSource.saveFavoriteIds(captureAny()))
              .captured;
      final saved = captured.first as Set<int>;
      expect(saved, isNot(contains(1)));
      expect(saved, contains(2));
    });
  });

  group('isFavorite', () {
    test('returns true when movieId is in saved favorites', () async {
      when(() => mockFavDataSource.loadFavoriteIds())
          .thenAnswer((_) async => {1, 3});

      final result = await repository.isFavorite(1);

      expect(result, isTrue);
    });

    test('returns false when movieId is not in saved favorites', () async {
      when(() => mockFavDataSource.loadFavoriteIds())
          .thenAnswer((_) async => {2, 3});

      final result = await repository.isFavorite(1);

      expect(result, isFalse);
    });
  });
}
