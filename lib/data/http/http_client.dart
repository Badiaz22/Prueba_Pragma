import 'package:http/http.dart' as http;
import 'package:catbreeds/domain/exceptions/app_exceptions.dart';

/// A robust HTTP client that extends [http.BaseClient] with automatic retry capability.
///
/// This client implements retry logic with exponential backoff to handle transient
/// network failures. Each failed request due to timeout or network error will be
/// automatically retried up to [maxRetries] times before throwing an exception.
///
/// **Features:**
/// - Automatic retry with exponential backoff
/// - Configurable timeout for each request
/// - Internal client reuse to minimize overhead
/// - Specific handling for timeout and network exceptions
///
/// **Example:**
/// ```dart
/// final httpClient = HttpClientWithRetry(
///   maxRetries: 3,
///   timeout: Duration(seconds: 30),
///   retryDelay: Duration(milliseconds: 500),
/// );
/// final response = await httpClient.get(Uri.parse('https://api.example.com/data'));
/// ```
///
/// **Throws:**
/// - [TimeoutException] if request exceeds timeout after all retries
/// - [NetworkException] if network error occurs after all retries
class HttpClientWithRetry extends http.BaseClient {
  /// Maximum number of retry attempts (inclusive).
  final int maxRetries;

  /// Maximum duration allowed for each HTTP request.
  final Duration timeout;

  /// Initial delay between retries. Multiplied exponentially with each retry.
  final Duration retryDelay;

  /// Reusable internal HTTP client for all requests.
  final http.Client _inner = http.Client();

  /// Creates an instance of [HttpClientWithRetry] with configurable parameters.
  ///
  /// Default values:
  /// - `maxRetries`: 3 attempts
  /// - `timeout`: 30 seconds
  /// - `retryDelay`: 500 milliseconds
  HttpClientWithRetry({
    this.maxRetries = 3,
    this.timeout = const Duration(seconds: 30),
    this.retryDelay = const Duration(milliseconds: 500),
  });

  /// Sends an HTTP request with automatic retry logic.
  ///
  /// This method is the core of the client that overrides [http.BaseClient.send].
  /// It attempts to send the [request] and, if it fails, automatically retries
  /// up to [maxRetries] times with exponential backoff.
  ///
  /// **Parameters:**
  /// - [request]: The HTTP request to send
  ///
  /// **Returns:**
  /// A [Future] that resolves to [http.StreamedResponse] if successful.
  ///
  /// **Throws:**
  /// - [TimeoutException] if request exceeds [timeout]
  /// - [NetworkException] if network error occurs after all retries
  /// - [AppException] if an application exception occurs (re-thrown without retries)
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    int retryCount = 0;

    while (true) {
      try {
        // Use internal client instead of creating new ones
        final streamedResponse = await _inner.send(request).timeout(
          timeout,
          onTimeout: () {
            throw TimeoutException(
                'Request exceeded ${timeout.inSeconds} seconds');
          },
        );

        return streamedResponse;
      } on TimeoutException {
        retryCount++;

        if (retryCount >= maxRetries) {
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(
          retryDelay * retryCount, // Exponential backoff
        );
      } on AppException {
        rethrow;
      } catch (e) {
        retryCount++;

        if (retryCount >= maxRetries) {
          throw NetworkException('Network error: ${e.toString()}');
        }

        // Wait before retrying
        await Future.delayed(
          retryDelay * retryCount,
        );
      }
    }
  }

  /// Closes the internal HTTP client.
  ///
  /// Should be called when the client is no longer needed to free
  /// system resources.
  @override
  void close() {
    _inner.close();
    super.close();
  }
}
