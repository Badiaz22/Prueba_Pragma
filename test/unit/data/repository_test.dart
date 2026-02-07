import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';

void main() {
  group('CatApiRepository', () {
    /// Test: Breed entity parsing from JSON
    test('should correctly parse JSON to BreedEntity', () {
      // Arrange
      final json = {
        'id': 'abys',
        'name': 'Abyssinian',
        'origin': 'Egypt',
        'temperament': 'Playful, Friendly',
        'description': 'A slender cat breed',
        'life_span': '9 - 13',
        'adaptability': 3,
        'affection_level': 4,
        'energy_level': 5,
        'intelligence': 3,
        'image': null,
        'weight': null,
      };

      // Act
      final breed = BreedEntity.fromJson(json);

      // Assert
      expect(breed.id, 'abys');
      expect(breed.name, 'Abyssinian');
      expect(breed.origin, 'Egypt');
      expect(breed.adaptability, 3);
    });

    /// Test: Handle null image in JSON
    test('should handle null image gracefully', () {
      // Arrange
      final json = {
        'id': 'test',
        'name': 'Test',
        'origin': 'Test',
        'temperament': 'Test',
        'description': 'Test',
        'life_span': '10 - 12',
        'adaptability': 3,
        'affection_level': 4,
        'energy_level': 5,
        'intelligence': 3,
        'image': null,
        'weight': null,
      };

      // Act
      final breed = BreedEntity.fromJson(json);

      // Assert
      expect(breed.image, isNull);
    });

    /// Test: All required fields are present
    test('should parse all required fields from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'Aegean',
        'origin': 'Greece',
        'temperament': 'Affectionate',
        'description': 'Island cat',
        'life_span': '9 - 13',
        'adaptability': 4,
        'affection_level': 5,
        'energy_level': 4,
        'intelligence': 4,
        'image': null,
        'weight': null,
      };

      // Act
      final breed = BreedEntity.fromJson(json);

      // Assert
      expect(breed.id, isNotEmpty);
      expect(breed.name, isNotEmpty);
      expect(breed.origin, isNotEmpty);
      expect(breed.temperament, isNotEmpty);
      expect(breed.description, isNotEmpty);
      expect(breed.adaptability, greaterThanOrEqualTo(0));
      expect(breed.affectionLevel, greaterThanOrEqualTo(0));
    });

    /// Test: Numeric fields are correctly parsed
    test('should parse numeric attributes correctly', () {
      // Arrange
      final json = {
        'id': 'test',
        'name': 'Test',
        'origin': 'Test',
        'temperament': 'Test',
        'description': 'Test',
        'life_span': '10 - 12',
        'adaptability': 5,
        'affection_level': 4,
        'energy_level': 3,
        'intelligence': 2,
        'image': null,
        'weight': null,
      };

      // Act
      final breed = BreedEntity.fromJson(json);

      // Assert
      expect(breed.adaptability, 5);
      expect(breed.affectionLevel, 4);
      expect(breed.energyLevel, 3);
      expect(breed.intelligence, 2);
    });

    /// Test: String fields trim whitespace
    test('should handle string fields correctly', () {
      // Arrange
      final json = {
        'id': 'test_id',
        'name': 'Test Breed',
        'origin': 'Test Origin',
        'temperament': 'Playful, Calm, Friendly',
        'description': 'This is a test breed description',
        'life_span': '12 - 15',
        'adaptability': 3,
        'affection_level': 4,
        'energy_level': 5,
        'intelligence': 3,
        'image': null,
        'weight': null,
      };

      // Act
      final breed = BreedEntity.fromJson(json);

      // Assert
      expect(breed.name, 'Test Breed');
      expect(breed.temperament, 'Playful, Calm, Friendly');
      expect(breed.lifeSpan, '12 - 15');
    });

    /// Test: Multiple breeds can be parsed
    test('should allow creating multiple breed instances', () {
      // Arrange
      final json1 = {
        'id': '1',
        'name': 'Breed1',
        'origin': 'Origin1',
        'temperament': 'Temp1',
        'description': 'Desc1',
        'life_span': '10 - 12',
        'adaptability': 1,
        'affection_level': 2,
        'energy_level': 3,
        'intelligence': 4,
        'image': null,
        'weight': null,
      };

      final json2 = {
        'id': '2',
        'name': 'Breed2',
        'origin': 'Origin2',
        'temperament': 'Temp2',
        'description': 'Desc2',
        'life_span': '13 - 15',
        'adaptability': 2,
        'affection_level': 3,
        'energy_level': 4,
        'intelligence': 5,
        'image': null,
        'weight': null,
      };

      // Act
      final breed1 = BreedEntity.fromJson(json1);
      final breed2 = BreedEntity.fromJson(json2);

      // Assert
      expect(breed1.id, '1');
      expect(breed2.id, '2');
      expect(breed1.name, 'Breed1');
      expect(breed2.name, 'Breed2');
    });
  });
}
