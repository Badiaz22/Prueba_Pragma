import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/entities/weight_entity.dart';
import 'package:catbreeds/domain/use_cases/filter_breeds_use_case.dart';
import 'package:catbreeds/data/repository/cat_api_repository.dart';

class FakeCatApiRepository implements ICatApiRepository {
  List<BreedEntity> _breeds = [];
  bool _shouldThrow = false;
  Exception? _exception;

  void setBreeds(List<BreedEntity> breeds) => _breeds = breeds;
  void setException(Exception exception) {
    _shouldThrow = true;
    _exception = exception;
  }

  void reset() {
    _breeds = [];
    _shouldThrow = false;
    _exception = null;
  }

  @override
  Future<List<BreedEntity>> getBreeds({required int page}) async {
    if (_shouldThrow) throw _exception!;
    return _breeds;
  }

  @override
  Future<List<BreedEntity>> searchBreeds({required String query}) async {
    if (_shouldThrow) throw _exception!;
    return _breeds;
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
  late FakeCatApiRepository fakeRepository;
  late FilterBreedsUseCase filterBreedsUseCase;

  setUp(() {
    fakeRepository = FakeCatApiRepository();
    filterBreedsUseCase = FilterBreedsUseCase(catApiRepository: fakeRepository);
  });

  group('FilterBreedsUseCase', () {
    test('should return list of breeds matching search query', () async {
      // Arrange
      final tBreedList = [
        _createTestBreed(id: '1', name: 'Abyssinian'),
      ];
      fakeRepository.setBreeds(tBreedList);

      // Act
      final result = await filterBreedsUseCase.searchBreeds(query: 'Abys');

      // Assert
      expect(result, tBreedList);
      expect(result.length, 1);
      expect(result.first.name, 'Abyssinian');
    });

    test('should handle search queries case-insensitively', () async {
      // Arrange
      fakeRepository.setBreeds([]);

      // Act
      final result =
          await filterBreedsUseCase.searchBreeds(query: 'abyssinian');

      // Assert
      expect(result, isEmpty);
    });

    test('should return empty list with empty query', () async {
      // Arrange
      fakeRepository.setBreeds([]);

      // Act
      final result = await filterBreedsUseCase.searchBreeds(query: '');

      // Assert
      expect(result, isEmpty);
    });

    test('should return multiple breeds with partial matches', () async {
      // Arrange
      final tBreedList = [
        _createTestBreed(id: '1', name: 'African Wildcat'),
        _createTestBreed(id: '2', name: 'American Bobtail'),
      ];
      fakeRepository.setBreeds(tBreedList);

      // Act
      final result = await filterBreedsUseCase.searchBreeds(query: 'can');

      // Assert
      expect(result.length, 2);
    });

    test('should return empty list when no matches found', () async {
      // Arrange
      fakeRepository.setBreeds([]);

      // Act
      final result =
          await filterBreedsUseCase.searchBreeds(query: 'NonexistentBreed');

      // Assert
      expect(result, isEmpty);
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      fakeRepository.setException(Exception('Connection failed'));

      // Act & Assert
      expect(
        () => filterBreedsUseCase.searchBreeds(query: 'test'),
        throwsException,
      );
    });
  });
}
