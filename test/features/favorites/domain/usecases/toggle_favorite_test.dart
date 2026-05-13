import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ternak_klip_technical_test/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ternak_klip_technical_test/features/favorites/domain/usecases/toggle_favorite.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late MockFavoritesRepository mockRepository;
  late ToggleFavorite useCase;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = ToggleFavorite(mockRepository);
  });

  test('delegates to repository.toggleFavorite with the correct movieId', () async {
    when(() => mockRepository.toggleFavorite(any())).thenAnswer((_) async {});

    await useCase(1);

    verify(() => mockRepository.toggleFavorite(1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('propagates exception when repository throws', () async {
    when(() => mockRepository.toggleFavorite(any()))
        .thenThrow(Exception('Storage error'));

    expect(() => useCase(1), throwsException);
  });
}
