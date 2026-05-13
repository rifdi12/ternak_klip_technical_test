import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ternak_klip_technical_test/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ternak_klip_technical_test/features/favorites/domain/usecases/get_favorites.dart';
import 'package:ternak_klip_technical_test/features/movies/domain/entities/movie.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late MockFavoritesRepository mockRepository;
  late GetFavorites useCase;

  const tMovies = [
    Movie(
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
  ];

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = GetFavorites(mockRepository);
  });

  test('returns list of favorite movies from repository', () async {
    when(() => mockRepository.getFavorites()).thenAnswer((_) async => tMovies);

    final result = await useCase();

    expect(result, tMovies);
    verify(() => mockRepository.getFavorites()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('returns empty list when repository has no favorites', () async {
    when(() => mockRepository.getFavorites()).thenAnswer((_) async => []);

    final result = await useCase();

    expect(result, isEmpty);
  });

  test('propagates exception when repository throws', () async {
    when(() => mockRepository.getFavorites())
        .thenThrow(Exception('Cache failure'));

    expect(() => useCase(), throwsException);
  });
}
