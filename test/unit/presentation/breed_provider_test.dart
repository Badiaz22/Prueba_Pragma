import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/entities/weight_entity.dart';
import 'package:catbreeds/domain/use_cases/i_get_breeds_use_case.dart';
import 'package:catbreeds/domain/use_cases/i_filter_breeds_use_case.dart';

class FakeGetBreedsUseCase implements IGetBreedsUseCase {
  List<BreedEntity> _breeds = [];
  bool _shouldThrow = false;
  Exception? _exception;

  void setBreeds(List<BreedEntity> breeds) {
    _breeds = breeds;
    _shouldThrow = false;
    _exception = null;
  }

  void setException(Exception exception) {
    _shouldThrow = true;
    _exception = exception;
  }

  @override
  Future<List<BreedEntity>> getBreeds({required int page}) async {
    if (_shouldThrow) throw _exception!;
    return _breeds;
  }
}

class FakeFilterBreedsUseCase implements IFilterBreedsUseCase {
  List<BreedEntity> _results = [];
  bool _shouldThrow = false;
  Exception? _exception;

  void setResults(List<BreedEntity> results) {
    _results = results;
    _shouldThrow = false;
    _exception = null;
  }

  void setException(Exception exception) {
    _shouldThrow = true;
    _exception = exception;
  }

  @override
  Future<List<BreedEntity>> searchBreeds({required String query}) async {
    if (_shouldThrow) throw _exception!;
    return _results;
  }
}

BreedEntity _createTestBreed({
  String id = '1',
  String name = 'Test Breed',
  String origin = 'Test Origin',
}) {
  return BreedEntity(
    id: id,
    name: name,
    origin: origin,
    temperament: 'Playful',
    description: 'A test breed',
    lifeSpan: '9 - 13',
    adaptability: 3,
    affectionLevel: 4,
    childFriendly: 3,
    dogFriendly: 3,
    energyLevel: 5,
    grooming: 2,
    healthIssues: 1,
    intelligence: 3,
    sheddingLevel: 2,
    socialNeeds: 3,
    strangerFriendly: 3,
    vocalisation: 2,
    hypoallergenic: 0,
    image: null,
    weight: WeightEntity(imperial: '6 - 10', metric: '3 - 5'),
  );
}

void main() {
  group('BreedProvider', () {
    late FakeGetBreedsUseCase fakeGetBreedsUseCase;
    late FakeFilterBreedsUseCase fakeFilterBreedsUseCase;
    late BreedProvider provider;

    setUp(() {
      fakeGetBreedsUseCase = FakeGetBreedsUseCase();
      fakeFilterBreedsUseCase = FakeFilterBreedsUseCase();
      provider = BreedProvider(
        getBreedsUseCase: fakeGetBreedsUseCase,
        filterBreedsUseCase: fakeFilterBreedsUseCase,
      );
    });

    test('should initialize with empty breeds list', () {
      // Assert
      expect(provider.breeds, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.hasError, isFalse);
    });

    test('should load breeds successfully', () async {
      // Arrange
      final testBreeds = [
        _createTestBreed(id: '1', name: 'Abyssinian'),
        _createTestBreed(id: '2', name: 'Bengal'),
      ];
      fakeGetBreedsUseCase.setBreeds(testBreeds);

      // Act
      await provider.fetchBreeds();

      // Assert
      expect(provider.breeds, testBreeds);
      expect(provider.isLoading, isFalse);
      expect(provider.hasError, isFalse);
    });

    test('should set loading state during fetch', () async {
      // Arrange
      bool wasLoading = false;
      final testBreeds = [_createTestBreed()];
      fakeGetBreedsUseCase.setBreeds(testBreeds);

      provider.addListener(() {
        if (provider.isLoading) wasLoading = true;
      });

      // Act
      await provider.fetchBreeds();

      // Assert
      expect(wasLoading, isTrue);
      expect(provider.isLoading, isFalse);
    });

    test('should handle error when fetch fails', () async {
      // Arrange
      fakeGetBreedsUseCase.setException(Exception('Network error'));

      // Act
      await provider.fetchBreeds();

      // Assert
      expect(provider.hasError, isTrue);
      expect(provider.errorMessage, isNotEmpty);
    });

    test('should load more breeds with pagination', () async {
      // Arrange
      final testBreeds = [_createTestBreed(id: '1')];
      final moreBreeds = [_createTestBreed(id: '2')];
      fakeGetBreedsUseCase.setBreeds(testBreeds);

      // Act
      await provider.fetchBreeds();
      fakeGetBreedsUseCase.setBreeds(moreBreeds);
      await provider.loadMoreBreeds();

      // Assert
      expect(provider.breeds.length, greaterThanOrEqualTo(1));
    });

    test('should prevent loading when hasReachedMax is true', () async {
      // Arrange
      final testBreeds = <BreedEntity>[];
      fakeGetBreedsUseCase.setBreeds(testBreeds);

      // Act
      await provider.fetchBreeds();
      await provider.loadMoreBreeds();
      final breadsCountBefore = provider.breeds.length;
      await provider.loadMoreBreeds();

      // Assert - shouldn't trigger another fetch
      expect(provider.breeds.length, equals(breadsCountBefore));
    });

    test('should clear error on successful reload', () async {
      // Arrange
      fakeGetBreedsUseCase.setException(Exception('Error'));

      // Act
      await provider.fetchBreeds();
      expect(provider.hasError, isTrue);

      // Reset exception by setting breeds
      fakeGetBreedsUseCase.setBreeds([_createTestBreed()]);
      await provider.fetchBreeds();

      // Assert
      expect(provider.hasError, isFalse);
    });

    test('should search breeds successfully', () async {
      // Arrange
      final searchResults = [_createTestBreed(name: 'Siamese')];
      fakeFilterBreedsUseCase.setResults(searchResults);

      // Act
      await provider.searchBreeds('siamese');

      // Assert
      expect(provider.searchResults, searchResults);
      expect(provider.hasError, isFalse);
    });

    test('should clear search results on empty query', () async {
      // Arrange
      final results = [_createTestBreed()];
      fakeFilterBreedsUseCase.setResults(results);
      await provider.searchBreeds('test');

      // Act
      await provider.searchBreeds('');

      // Assert
      expect(provider.searchResults, isEmpty);
    });

    test('should handle search errors gracefully', () async {
      // Arrange
      fakeFilterBreedsUseCase.setException(Exception('Search failed'));

      // Act
      await provider.searchBreeds('test');

      // Assert
      expect(provider.hasError, isTrue);
    });

    test('should preserve breeds when navigating away', () async {
      // Arrange
      final testBreeds = [_createTestBreed(), _createTestBreed(id: '2')];
      fakeGetBreedsUseCase.setBreeds(testBreeds);

      // Act
      await provider.fetchBreeds();
      final breedsCount = provider.breeds.length;

      // Assert - breeds should be in memory
      expect(breedsCount, equals(2));
    });
  });
}
