import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BreedEntity', () {
    final jsonMock = {
      "id": "abys",
      "name": "Abyssinian",
      "weight": {"imperial": "7 - 10", "metric": "3 - 5"},
      "description": "Active cat",
      "temperament": "Active, Energetic",
      "origin": "Egypt",
      "life_span": "12 - 15",
      "adaptability": 4,
      "affection_level": 5,
      "child_friendly": 4,
      "dog_friendly": 4,
      "energy_level": 5,
      "grooming": 1,
      "health_issues": 2,
      "intelligence": 5,
      "shedding_level": 2,
      "social_needs": 5,
      "stranger_friendly": 4,
      "vocalisation": 3,
      "cfa_url": "https://cfa.org",
      "vetstreet_url": "https://vetstreet.com",
      "vcahospitals_url": "https://vca.com",
      "wikipedia_url": "https://wikipedia.org",
      "hypoallergenic": 0,
      "image": {"id": "img1", "url": "https://test.com/cat.jpg"}
    };

    test('fromJson mapea correctamente todos los campos', () {
      final breed = BreedEntity.fromJson(jsonMock);

      expect(breed.id, "abys");
      expect(breed.name, "Abyssinian");
      expect(breed.origin, "Egypt");
      expect(breed.weight.metric, "3 - 5");
      expect(breed.image?.url, "https://test.com/cat.jpg");
    });

    test('fromJson usa valores por defecto cuando faltan campos', () {
      final breed = BreedEntity.fromJson({});

      expect(breed.id, "");
      expect(breed.name, "");
      expect(breed.description, "");
      expect(breed.adaptability, 0);
      expect(breed.weight.metric, "");
      expect(breed.image, null);
    });

    test('fromJson maneja weight null', () {
      final breed = BreedEntity.fromJson(
          {"id": "abys", "name": "Abyssinian", "weight": null});

      expect(breed.weight.metric, "");
      expect(breed.weight.imperial, "");
    });

    test('fromJson maneja image null', () {
      final breed = BreedEntity.fromJson(
          {"id": "abys", "name": "Abyssinian", "image": null});

      expect(breed.image, null);
    });

    test('toJson genera el mapa correctamente', () {
      final breed = BreedEntity.fromJson(jsonMock);

      final json = breed.toJson();

      expect(json["id"], "abys");
      expect(json["name"], "Abyssinian");
      expect(json["weight"], isNotNull);
      expect(json["image"], isNotNull);
    });

    test('toJson y fromJson son consistentes (round trip)', () {
      final breed1 = BreedEntity.fromJson(jsonMock);

      final json = breed1.toJson();

      final breed2 = BreedEntity.fromJson(json);

      expect(breed2.id, breed1.id);
      expect(breed2.name, breed1.name);
      expect(breed2.origin, breed1.origin);
      expect(breed2.weight.metric, breed1.weight.metric);
    });
  });
}
