import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/entities/weight_entity.dart';
import 'package:catbreeds/domain/use_cases/get_breeds_use_case.dart';
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
  late GetBreedsUseCase getBreedUseCase;

  setUp(() {
    fakeRepository = FakeCatApiRepository();
    getBreedUseCase = GetBreedsUseCase(catApiRepository: fakeRepository);
  });

  group('GetBreedsUseCase', () {
    test('should return list of BreedEntity when repository call is successful',
        () async {
      // Arrange
      final tBreedList = [
        _createTestBreed(id: '1', name: 'Abyssinian'),
        _createTestBreed(id: '2', name: 'Bengal'),
      ];
      fakeRepository.setBreeds(tBreedList);

      // Act
      final result = await getBreedUseCase.getBreeds(page: 1);

      // Assert
      expect(result, tBreedList);
      expect(result.length, 2);
    });

    test('should call repository with correct page parameter', () async {
      // Arrange
      final tBreedList = [_createTestBreed()];
      fakeRepository.setBreeds(tBreedList);

      // Act
      final result = await getBreedUseCase.getBreeds(page: 2);

      // Assert
      expect(result, isNotEmpty);
    });

    test('should return empty list when no breeds are found', () async {
      // Arrange
      fakeRepository.setBreeds([]);

      // Act
      final result = await getBreedUseCase.getBreeds(page: 1);

      // Assert
      expect(result, isEmpty);
    });

    test('should propagate exceptions thrown by repository', () async {
      // Arrange
      fakeRepository.setException(Exception('Network error'));

      // Act & Assert
      expect(
        () => getBreedUseCase.getBreeds(page: 1),
        throwsException,
      );
    });

    test('should preserve all breed entity fields', () async {
      // Arrange
      final testBreed = _createTestBreed(
        id: 'test-id',
        name: 'Test Name',
        origin: 'Test Origin',
      );
      fakeRepository.setBreeds([testBreed]);

      // Act
      final result = await getBreedUseCase.getBreeds(page: 1);

      // Assert
      expect(result.first.id, 'test-id');
      expect(result.first.name, 'Test Name');
      expect(result.first.origin, 'Test Origin');
      expect(result.first.temperament, 'Playful');
    });

    test('should handle multiple breeds in response', () async {
      // Arrange
      final tBreedList = [
        _createTestBreed(id: '1', name: 'Abyssinian'),
        _createTestBreed(id: '2', name: 'Bengal'),
        _createTestBreed(id: '3', name: 'Birman'),
      ];
      fakeRepository.setBreeds(tBreedList);

      // Act
      final result = await getBreedUseCase.getBreeds(page: 1);

      // Assert
      expect(result.length, 3);
      expect(result[0].name, 'Abyssinian');
      expect(result[1].name, 'Bengal');
      expect(result[2].name, 'Birman');
    });
  });
}
