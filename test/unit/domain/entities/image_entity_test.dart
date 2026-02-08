import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/domain/entities/image_entity.dart';

void main() {
  group('ImageEntity', () {
    final jsonMock = {
      "id": "GhAqFaX2K",
      "width": 1080,
      "height": 720,
      "url": "https://cdn2.thecatapi.com/images/GhAqFaX2K.jpg",
    };

    test('fromJson mapea correctamente todos los campos', () {
      final image = ImageEntity.fromJson(jsonMock);

      expect(image.id, "GhAqFaX2K");
      expect(image.width, 1080);
      expect(image.height, 720);
      expect(image.url, "https://cdn2.thecatapi.com/images/GhAqFaX2K.jpg");
    });

    test('fromJson usa valores por defecto cuando faltan campos', () {
      final image = ImageEntity.fromJson({});

      expect(image.id, "");
      expect(image.width, 0);
      expect(image.height, 0);
      expect(image.url, "");
    });

    test('toJson genera el mapa correctamente', () {
      final image = ImageEntity(
        id: "GhAqFaX2K",
        width: 1080,
        height: 720,
        url: "https://cdn2.thecatapi.com/images/GhAqFaX2K.jpg",
      );

      final json = image.toJson();

      expect(json["id"], "GhAqFaX2K");
      expect(json["width"], 1080);
      expect(json["height"], 720);
      expect(json["url"], "https://cdn2.thecatapi.com/images/GhAqFaX2K.jpg");
    });

    test('toJson y fromJson son consistentes (round trip)', () {
      final image1 = ImageEntity.fromJson(jsonMock);

      final json = image1.toJson();

      final image2 = ImageEntity.fromJson(json);

      expect(image2.id, image1.id);
      expect(image2.width, image1.width);
      expect(image2.height, image1.height);
      expect(image2.url, image1.url);
    });
  });
}
