import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/entities/weight_entity.dart';

/// Factory for creating [BreedEntity] instances for testing purposes.
///
/// Provides predefined test data with sensible defaults to avoid
/// repetitive entity creation in tests.
class TestBreedEntity {
  /// Creates a default [BreedEntity] with all required fields populated.
  ///
  /// All parameters are optional and can be overridden to customize
  /// the entity for specific test scenarios.
  ///
  /// **Example:**
  /// ```dart
  /// // Default Persian cat
  /// final breed = TestBreedEntity.create();
  ///
  /// // Custom Bengal cat
  /// final bengal = TestBreedEntity.create(
  ///   id: 'bengal',
  ///   name: 'Bengal',
  ///   energyLevel: 5,
  /// );
  /// ```
  static BreedEntity create({
    String id = '1',
    String name = 'Persian',
    String origin = 'Iran',
    String temperament = 'Calm, Gentle, Quiet',
    String description =
        'The Persian is known for its long, luxurious coat and calm temperament.',
    String lifeSpan = '10 - 17',
    int adaptability = 3,
    int affectionLevel = 3,
    int childFriendly = 3,
    int dogFriendly = 2,
    int energyLevel = 1,
    int grooming = 5,
    int healthIssues = 2,
    int intelligence = 3,
    int sheddingLevel = 5,
    int socialNeeds = 3,
    int strangerFriendly = 2,
    int vocalisation = 1,
    int hypoallergenic = 0,
    WeightEntity? weight,
    dynamic image,
  }) {
    return BreedEntity(
      id: id,
      name: name,
      origin: origin,
      temperament: temperament,
      description: description,
      lifeSpan: lifeSpan,
      adaptability: adaptability,
      affectionLevel: affectionLevel,
      childFriendly: childFriendly,
      dogFriendly: dogFriendly,
      energyLevel: energyLevel,
      grooming: grooming,
      healthIssues: healthIssues,
      intelligence: intelligence,
      sheddingLevel: sheddingLevel,
      socialNeeds: socialNeeds,
      strangerFriendly: strangerFriendly,
      vocalisation: vocalisation,
      hypoallergenic: hypoallergenic,
      weight: weight ?? WeightEntity(imperial: '7 - 12', metric: '3 - 6'),
      image: image,
    );
  }

  /// Creates a high-energy active cat (Bengal-like).
  static BreedEntity createActiveBreed({
    String id = 'bengal',
    String name = 'Bengal',
    String origin = 'USA',
  }) {
    return create(
      id: id,
      name: name,
      origin: origin,
      temperament: 'Active, Playful, Bold',
      energyLevel: 5,
      intelligence: 4,
      affectionLevel: 3,
      sheddingLevel: 2,
      grooming: 2,
      weight: WeightEntity(imperial: '6 - 10', metric: '3 - 5'),
    );
  }

  /// Creates a calm family-friendly cat (Maine Coon-like).
  static BreedEntity createFamilyFriendlyBreed({
    String id = 'maine_coon',
    String name = 'Maine Coon',
    String origin = 'Maine, USA',
  }) {
    return create(
      id: id,
      name: name,
      origin: origin,
      temperament: 'Friendly, Gentle, Intelligent',
      energyLevel: 3,
      intelligence: 5,
      affectionLevel: 4,
      childFriendly: 5,
      dogFriendly: 4,
      sheddingLevel: 5,
      grooming: 4,
      weight: WeightEntity(imperial: '11 - 25', metric: '5 - 11'),
    );
  }

  /// Creates a social and vocal cat (Siamese-like).
  static BreedEntity createSocialBreed({
    String id = 'siamese',
    String name = 'Siamese',
    String origin = 'Thailand',
  }) {
    return create(
      id: id,
      name: name,
      origin: origin,
      temperament: 'Social, Intelligent, Vocal',
      energyLevel: 3,
      intelligence: 5,
      affectionLevel: 5,
      vocalisation: 5,
      socialNeeds: 4,
      strangerFriendly: 4,
      sheddingLevel: 1,
      grooming: 2,
      weight: WeightEntity(imperial: '6 - 8', metric: '3 - 4'),
    );
  }

  /// Creates a list of diverse test breeds useful for list-based tests.
  static List<BreedEntity> createBreedList({int count = 3}) {
    return [
      create(id: '1', name: 'Persian'),
      createActiveBreed(),
      createFamilyFriendlyBreed(),
      if (count > 3) createSocialBreed(),
    ].take(count).toList();
  }
}
