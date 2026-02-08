import 'dart:convert';

import 'package:catbreeds/data/http/http_client.dart';
import 'package:catbreeds/data/repository/cat_api_repository.dart';
import 'package:catbreeds/domain/entities/entities.dart';
import 'package:catbreeds/domain/exceptions/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'cat_api_repository_test.mocks.dart';

@GenerateMocks([HttpClientWithRetry])
void main() {
  late MockHttpClientWithRetry mockClient;
  late CatApiRepository repository;

  setUp(() async {
    mockClient = MockHttpClientWithRetry();

    dotenv.testLoad(
      fileInput: '''
CAT_API_KEY=test_key
CAT_API_BASE_URL=https://api.test.com/v1
''',
    );

    repository = CatApiRepository(
      httpClient: mockClient,
    );
  });

  group('getBreeds', () {
    test('retorna lista de BreedEntity cuando la respuesta es 200', () async {
      final mockJson = jsonEncode([
        {
          "id": "abys",
          "name": "Abyssinian",
          "origin": "Egypt",
          "temperament": "Active"
        }
      ]);

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(mockJson, 200),
      );

      final result = await repository.getBreeds(page: 0);

      expect(result, isA<List<BreedEntity>>());
      expect(result.isNotEmpty, true);
    });

    test('lanza ApiException cuando statusCode es 404', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(
        () => repository.getBreeds(page: 0),
        throwsA(isA<ApiException>()),
      );
    });

    test('lanza ParsingException cuando el JSON es inválido', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('invalid json', 200),
      );

      expect(
        () => repository.getBreeds(page: 0),
        throwsA(isA<ParsingException>()),
      );
    });

    test('relanza AppException sin modificar', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenThrow(ApiException('API error'));

      expect(
        () => repository.getBreeds(page: 0),
        throwsA(isA<ApiException>()),
      );
    });

    test('lanza UnknownException en errores inesperados', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenThrow(Exception('random error'));

      expect(
        () => repository.getBreeds(page: 0),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('searchBreeds', () {
    test('retorna lista cuando la respuesta es 200', () async {
      final mockJson = jsonEncode([
        {
          "id": "beng",
          "name": "Bengal",
          "origin": "USA",
          "temperament": "Alert"
        }
      ]);

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(mockJson, 200),
      );

      final result = await repository.searchBreeds(query: 'beng');

      expect(result, isA<List<BreedEntity>>());
      expect(result.isNotEmpty, true);
    });

    test('lanza ApiException cuando 404', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(
        () => repository.searchBreeds(query: 'x'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
