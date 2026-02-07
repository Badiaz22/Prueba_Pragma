import 'package:catbreeds/domain/entities/weight_entity.dart';
import 'package:catbreeds/domain/entities/image_entity.dart';

/// Domain entity representing a cat breed.
///
/// Contains all information about an individual cat breed,
/// including physical characteristics, temperament, intelligence,
/// care requirements, and external references.
///
/// Mapped from The Cat API and used throughout
/// business logic and presentation.
///
/// **Characteristic Fields (0-5):**
/// Intelligence and temperament fields use a 0-5 scale:
/// - 0-1: Very low
/// - 2-3: Moderate
/// - 4-5: Very high
///
/// **Example:**
/// ```dart
/// final breed = BreedEntity(
///   id: 'abys',
///   name: 'Abyssinian',
///   origin: 'Egypt',
///   adaptability: 4,
///   // ... other fields
/// );
/// ```
class BreedEntity {
  /// Unique identifier of the breed (snake_case).
  final String id;

  /// Common breed name in English.
  final String name;

  /// Typical weight range for this breed.
  final WeightEntity weight;

  /// Detailed description of the breed.
  final String description;

  /// Typical temperament of the breed (comma-separated adjectives).
  final String temperament;

  /// Country or region of breed origin.
  final String origin;

  /// Average life expectancy (e.g., "12 - 17").
  final String lifeSpan;

  /// Adaptability to environmental changes (0-5).
  final int adaptability;

  /// Level of affection toward humans (0-5).
  final int affectionLevel;

  /// How friendly with children (0-5).
  final int childFriendly;

  /// Compatibility with dogs (0-5).
  final int dogFriendly;

  /// Energy level (0-5).
  final int energyLevel;

  /// Grooming and coat care needs (0-5).
  final int grooming;

  /// Predisposition to health issues (0-5).
  final int healthIssues;

  /// Intelligence level (0-5).
  final int intelligence;

  /// Amount of shedding (0-5).
  final int sheddingLevel;

  /// Need for social interaction (0-5).
  final int socialNeeds;

  /// Friendliness toward strangers (0-5).
  final int strangerFriendly;

  /// Tendency to vocalize/meow (0-5).
  final int vocalisation;

  /// URL in the CFA catalog, if available.
  final String? cfaUrl;

  /// URL on Vetstreet, if available.
  final String? vetstreetUrl;

  /// URL on VCA Animal Hospitals, if available.
  final String? vcahospitalsUrl;

  /// URL on Wikipedia, if available.
  final String? wikipediaUrl;

  /// Whether the breed is hypoallergenic (0 = no, 1 = yes).
  final int hypoallergenic;

  /// Representative image of the breed, if available.
  final ImageEntity? image;

  /// Creates an instance of [BreedEntity] with all required fields.
  ///
  /// Most fields are required to ensure data integrity.
  /// URLs and image are optional as they're not always available.
  BreedEntity({
    required this.id,
    required this.name,
    required this.weight,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    required this.adaptability,
    required this.affectionLevel,
    required this.childFriendly,
    required this.dogFriendly,
    required this.energyLevel,
    required this.grooming,
    required this.healthIssues,
    required this.intelligence,
    required this.sheddingLevel,
    required this.socialNeeds,
    required this.strangerFriendly,
    required this.vocalisation,
    this.cfaUrl,
    this.vetstreetUrl,
    this.vcahospitalsUrl,
    this.wikipediaUrl,
    required this.hypoallergenic,
    this.image,
  });

  /// Creates an instance of [BreedEntity] from API JSON.
  ///
  /// Maps JSON fields with snake_case names to camelCase properties.
  /// Missing values are replaced with safe defaults (empty strings, 0).
  ///
  /// **Parameters:**
  /// - [json]: Decoded JSON object from the API
  ///
  /// **Returns:**
  /// Instance of [BreedEntity] with mapped JSON data
  ///
  /// **Throws:**
  /// N/A - Missing values are replaced with defaults.
  factory BreedEntity.fromJson(Map<String, dynamic> json) {
    return BreedEntity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      weight: json['weight'] != null
          ? WeightEntity.fromJson(json['weight'])
          : WeightEntity(imperial: '', metric: ''),
      description: json['description'] ?? '',
      temperament: json['temperament'] ?? '',
      origin: json['origin'] ?? '',
      lifeSpan: json['life_span'] ?? '',
      adaptability: json['adaptability'] ?? 0,
      affectionLevel: json['affection_level'] ?? 0,
      childFriendly: json['child_friendly'] ?? 0,
      dogFriendly: json['dog_friendly'] ?? 0,
      energyLevel: json['energy_level'] ?? 0,
      grooming: json['grooming'] ?? 0,
      healthIssues: json['health_issues'] ?? 0,
      intelligence: json['intelligence'] ?? 0,
      sheddingLevel: json['shedding_level'] ?? 0,
      socialNeeds: json['social_needs'] ?? 0,
      strangerFriendly: json['stranger_friendly'] ?? 0,
      vocalisation: json['vocalisation'] ?? 0,
      cfaUrl: json['cfa_url'],
      vetstreetUrl: json['vetstreet_url'],
      vcahospitalsUrl: json['vcahospitals_url'],
      wikipediaUrl: json['wikipedia_url'],
      hypoallergenic: json['hypoallergenic'] ?? 0,
      image: json['image'] != null ? ImageEntity.fromJson(json['image']) : null,
    );
  }

  /// Converts this [BreedEntity] instance to JSON.
  ///
  /// Uses snake_case field names for API compatibility.
  ///
  /// **Returns:**
  /// Serializable JSON map representing this breed
  ///
  /// **Usage:**
  /// For local caching or sending to secondary backends.
  ///
  /// **Example:**
  /// ```dart
  /// final json = breed.toJson();
  /// final jsonString = jsonEncode(json);
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'weight': weight.toJson(),
      'description': description,
      'temperament': temperament,
      'origin': origin,
      'life_span': lifeSpan,
      'adaptability': adaptability,
      'affection_level': affectionLevel,
      'child_friendly': childFriendly,
      'dog_friendly': dogFriendly,
      'energy_level': energyLevel,
      'grooming': grooming,
      'health_issues': healthIssues,
      'intelligence': intelligence,
      'shedding_level': sheddingLevel,
      'social_needs': socialNeeds,
      'stranger_friendly': strangerFriendly,
      'vocalisation': vocalisation,
      'cfa_url': cfaUrl,
      'vetstreet_url': vetstreetUrl,
      'vcahospitals_url': vcahospitalsUrl,
      'wikipedia_url': wikipediaUrl,
      'hypoallergenic': hypoallergenic,
      'image': image?.toJson(),
    };
  }
}
