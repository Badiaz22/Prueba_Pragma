import 'dart:async';
import 'dart:io';

import 'package:catbreeds/data/http/http_client.dart';
import 'package:catbreeds/domain/exceptions/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_client_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late HttpClientWithRetry client;
  late http.Request request;

  setUp(() {
    mockClient = MockClient();
    client = HttpClientWithRetry(
      client: mockClient,
      maxRetries: 3,
      retryDelay: Duration.zero,
      timeout: const Duration(seconds: 1),
    );
    request = http.Request('GET', Uri.parse('https://test.com'));
  });

  group('HttpClientWithRetry', () {
    test('retorna respuesta cuando el request es exitoso en el primer intento',
        () async {
      when(mockClient.send(any)).thenAnswer(
        (_) async => http.StreamedResponse(Stream.value([]), 200),
      );

      final response = await client.send(request);

      expect(response.statusCode, 200);
      verify(mockClient.send(any)).called(1);
    });

    test('lanza TimeoutException después de agotar los retries', () async {
      var callCount = 0;
      when(mockClient.send(any)).thenAnswer((_) async {
        callCount++;
        throw TimeoutException('timeout');
      });

      expect(
        () async => await client.send(request),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('lanza NetworkException después de agotar retries por error de red',
        () async {
      var callCount = 0;
      when(mockClient.send(any)).thenAnswer((_) async {
        callCount++;
        throw const SocketException('network error');
      });

      expect(
        () async => await client.send(request),
        throwsA(isA<NetworkException>()),
      );
    });

    test('lanza ApiException sin reintentar', () async {
      when(mockClient.send(any)).thenThrow(ApiException('api error'));

      expect(
        () async => await client.send(request),
        throwsA(isA<ApiException>()),
      );

      verify(mockClient.send(any)).called(1);
    });

    test('respuesta exitosa en segundo intento', () async {
      var callCount = 0;
      when(mockClient.send(any)).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          throw TimeoutException('timeout');
        }
        return http.StreamedResponse(Stream.value([]), 200);
      });

      final response = await client.send(request);

      expect(response.statusCode, 200);
      expect(callCount, 2);
    });

    test('close cierra el cliente interno', () {
      client.close();
      verify(mockClient.close()).called(1);
    });
  });
}
