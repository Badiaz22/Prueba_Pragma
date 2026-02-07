/// Base class for all application exceptions.
///
/// Defines the common interface for custom exceptions, providing
/// a descriptive message that can be displayed to users.
///
/// **Example:**
/// ```dart
/// try {
///   // do something
/// } on NetworkException catch (e) {
///   print(e.message); // "Network error. Please check your connection."
/// }
/// ```
abstract class AppException implements Exception {
  /// The descriptive message of the exception to display to users.
  final String message;

  /// Creates an instance of [AppException] with a message.
  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when a network connectivity error occurs.
///
/// Thrown when internet connection fails, network is unavailable,
/// or there are connectivity issues on the device.
///
/// Default message: "Network error. Please check your connection."
class NetworkException extends AppException {
  /// Creates a [NetworkException] with a custom or default message.
  NetworkException([String? message])
      : super(message ?? 'Network error. Please check your connection.');
}

/// Exception thrown when an HTTP request exceeds its time limit.
///
/// Thrown when a request takes longer than allowed to complete.
/// Typically indicates slow connection or unresponsive server.
///
/// Default message: "Request timeout. Please try again."
class TimeoutException extends AppException {
  /// Creates a [TimeoutException] with a custom or default message.
  TimeoutException([String? message])
      : super(message ?? 'Request timeout. Please try again.');
}

/// Exception thrown when the API returns an HTTP error.
///
/// Thrown when the server returns an HTTP status code indicating an error
/// (4xx or 5xx). Includes the status code for detailed diagnosis.
///
/// **Common status codes:**
/// - 400: Bad Request
/// - 401: Unauthorized (invalid credentials)
/// - 403: Forbidden (access denied)
/// - 404: Not Found
/// - 500: Internal Server Error
/// - 503: Service Unavailable
class ApiException extends AppException {
  /// The HTTP status code returned by the server, if available.
  final int? statusCode;

  /// Creates an [ApiException] with a message and optional status code.
  ///
  /// **Parameters:**
  /// - [message]: Description of the error that occurred
  /// - [statusCode]: HTTP code from the server (optional)
  ApiException(super.message, {this.statusCode});
}

/// Exception thrown when JSON data parsing fails.
///
/// Thrown when the server response is not in the expected format,
/// JSON is invalid, or data structure is incompatible.
///
/// Default message: "Error parsing data. Please try again."
class ParsingException extends AppException {
  /// Creates a [ParsingException] with a custom or default message.
  ParsingException([String? message])
      : super(message ?? 'Error parsing data. Please try again.');
}

/// Exception thrown for unclassified unexpected errors.
///
/// Used as a fallback when an error occurs that doesn't fit any of the
/// specific exception categories.
///
/// Default message: "An unknown error occurred. Please try again."
class UnknownException extends AppException {
  /// Creates an [UnknownException] with a custom or default message.
  UnknownException([String? message])
      : super(message ?? 'An unknown error occurred. Please try again.');
}
