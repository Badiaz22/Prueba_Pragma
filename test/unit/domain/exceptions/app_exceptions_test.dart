import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/domain/exceptions/app_exceptions.dart';

void main() {
  group('AppExceptions', () {
    group('NetworkException', () {
      test('creates NetworkException with default message', () {
        // Arrange & Act
        final exception = NetworkException();

        // Assert
        expect(exception.message,
            equals('Network error. Please check your connection.'));
        expect(exception.toString(),
            equals('Network error. Please check your connection.'));
      });

      test('creates NetworkException with custom message', () {
        // Arrange
        const customMessage = 'WiFi disconnected';

        // Act
        final exception = NetworkException(customMessage);

        // Assert
        expect(exception.message, equals(customMessage));
        expect(exception.toString(), equals(customMessage));
      });

      test('NetworkException is an AppException', () {
        // Arrange & Act
        final exception = NetworkException();

        // Assert
        expect(exception, isA<AppException>());
      });
    });

    group('TimeoutException', () {
      test('creates TimeoutException with default message', () {
        // Arrange & Act
        final exception = TimeoutException();

        // Assert
        expect(exception.message, equals('Request timeout. Please try again.'));
        expect(
            exception.toString(), equals('Request timeout. Please try again.'));
      });

      test('creates TimeoutException with custom message', () {
        // Arrange
        const customMessage = '60 second timeout exceeded';

        // Act
        final exception = TimeoutException(customMessage);

        // Assert
        expect(exception.message, equals(customMessage));
        expect(exception.toString(), equals(customMessage));
      });

      test('TimeoutException is an AppException', () {
        // Arrange & Act
        final exception = TimeoutException();

        // Assert
        expect(exception, isA<AppException>());
      });
    });

    group('ApiException', () {
      test('creates ApiException with message only', () {
        // Arrange
        const message = 'Server error';

        // Act
        final exception = ApiException(message);

        // Assert
        expect(exception.message, equals(message));
        expect(exception.statusCode, isNull);
        expect(exception.toString(), equals(message));
      });

      test('creates ApiException with message and status code', () {
        // Arrange
        const message = 'Not found';
        const statusCode = 404;

        // Act
        final exception = ApiException(message, statusCode: statusCode);

        // Assert
        expect(exception.message, equals(message));
        expect(exception.statusCode, equals(404));
      });

      test('ApiException with 401 status code', () {
        // Arrange & Act
        final exception = ApiException('Unauthorized', statusCode: 401);

        // Assert
        expect(exception.statusCode, equals(401));
      });

      test('ApiException with 500 status code', () {
        // Arrange & Act
        final exception =
            ApiException('Internal Server Error', statusCode: 500);

        // Assert
        expect(exception.statusCode, equals(500));
      });

      test('ApiException is an AppException', () {
        // Arrange & Act
        final exception = ApiException('Error');

        // Assert
        expect(exception, isA<AppException>());
      });
    });

    group('ParsingException', () {
      test('creates ParsingException with default message', () {
        // Arrange & Act
        final exception = ParsingException();

        // Assert
        expect(
            exception.message, equals('Error parsing data. Please try again.'));
        expect(exception.toString(),
            equals('Error parsing data. Please try again.'));
      });

      test('creates ParsingException with custom message', () {
        // Arrange
        const customMessage = 'Invalid JSON format';

        // Act
        final exception = ParsingException(customMessage);

        // Assert
        expect(exception.message, equals(customMessage));
        expect(exception.toString(), equals(customMessage));
      });

      test('ParsingException is an AppException', () {
        // Arrange & Act
        final exception = ParsingException();

        // Assert
        expect(exception, isA<AppException>());
      });
    });

    group('UnknownException', () {
      test('creates UnknownException with default message', () {
        // Arrange & Act
        final exception = UnknownException();

        // Assert
        expect(exception.message,
            equals('An unknown error occurred. Please try again.'));
        expect(exception.toString(),
            equals('An unknown error occurred. Please try again.'));
      });

      test('creates UnknownException with custom message', () {
        // Arrange
        const customMessage = 'Unexpected system error';

        // Act
        final exception = UnknownException(customMessage);

        // Assert
        expect(exception.message, equals(customMessage));
        expect(exception.toString(), equals(customMessage));
      });

      test('UnknownException is an AppException', () {
        // Arrange & Act
        final exception = UnknownException();

        // Assert
        expect(exception, isA<AppException>());
      });
    });

    group('Exception inheritance', () {
      test('all exceptions implement AppException', () {
        // Arrange
        final exceptions = <AppException>[
          NetworkException(),
          TimeoutException(),
          ApiException('Error'),
          ParsingException(),
          UnknownException(),
        ];

        // Assert
        for (final exception in exceptions) {
          expect(exception, isA<AppException>());
          expect(exception, isA<Exception>());
        }
      });

      test('exception message can be thrown and caught', () {
        // Arrange & Act & Assert
        expect(
          () => throw NetworkException('Custom error'),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('Message consistency', () {
      test('exception messages are consistent across toString and message', () {
        // Arrange
        const customMessage = 'Test message';
        final exception = ApiException(customMessage);

        // Assert
        expect(exception.toString(), equals(exception.message));
      });

      test('all exceptions with null messages use defaults', () {
        // Arrange & Act
        final networkException = NetworkException(null);
        final timeoutException = TimeoutException(null);
        final parsingException = ParsingException(null);
        final unknownException = UnknownException(null);

        // Assert
        expect(networkException.message, isNotEmpty);
        expect(timeoutException.message, isNotEmpty);
        expect(parsingException.message, isNotEmpty);
        expect(unknownException.message, isNotEmpty);
      });
    });
  });
}
