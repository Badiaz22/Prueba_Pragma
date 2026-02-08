import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/domain/entities/weight_entity.dart';

void main() {
  group('WeightEntity', () {
    final jsonMock = {
      "imperial": "6 - 10",
      "metric": "3 - 5",
    };

    test('fromJson mapea correctamente los campos', () {
      final weight = WeightEntity.fromJson(jsonMock);

      expect(weight.imperial, "6 - 10");
      expect(weight.metric, "3 - 5");
    });

    test('fromJson usa valores por defecto cuando faltan campos', () {
      final weight = WeightEntity.fromJson({});

      expect(weight.imperial, "");
      expect(weight.metric, "");
    });

    test('toJson genera el mapa correctamente', () {
      final weight = WeightEntity(
        imperial: "6 - 10",
        metric: "3 - 5",
      );

      final json = weight.toJson();

      expect(json["imperial"], "6 - 10");
      expect(json["metric"], "3 - 5");
    });

    test('toJson y fromJson son consistentes (round trip)', () {
      final weight1 = WeightEntity.fromJson(jsonMock);

      final json = weight1.toJson();
      final weight2 = WeightEntity.fromJson(json);

      expect(weight2.imperial, weight1.imperial);
      expect(weight2.metric, weight1.metric);
    });
  });
}
