import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:catbreeds/data/http/http_client.dart';
import 'package:catbreeds/domain/entities/entities.dart';
import 'package:catbreeds/domain/exceptions/app_exceptions.dart';

/// Interface for the cat API repository.
///
/// Defines contracts for accessing cat breed data from the API.
/// Implementations handle HTTP communication, data parsing,
/// and conversion to domain entities.
abstract class ICatApiRepository {
  /// Gets a page of cat breeds.
  ///
  /// **Parameters:**
  /// - [page]: Page number (0-indexed)
  ///
  /// **Returns:**
  /// List of [BreedEntity] on the specified page
  ///
  /// **Throws:**
  /// - [TimeoutException] if request exceeds time limit
  /// - [NetworkException] if connectivity issues occur
  /// - [ApiException] if API returns an error
  /// - [ParsingException] if response is invalid
  Future<List<BreedEntity>> getBreeds({required int page});

  /// Searches for breeds matching the specified query.
  ///
  /// **Parameters:**
  /// - [query]: Search term (e.g., "siamese", "bengal")
  ///
  /// **Returns:**
  /// List of [BreedEntity] matching the search
  ///
  /// **Throws:**
  /// - Same exceptions as [getBreeds]
  Future<List<BreedEntity>> searchBreeds({required String query});
}

/// Implementation of the repository for the cat API.
///
/// Manages communication with The Cat API (thecatapi.com),
/// including authentication, encoding/decoding data,
/// and HTTP error handling.
///
/// **Configuration:**
/// Requires the following environment variables in `.env`:
/// - `CAT_API_KEY`: API key for authentication
/// - `CAT_API_BASE_URL`: Base URL for the API (optional, defaults to https://api.thecatapi.com/v1)
///
/// **Example:**
/// ```dart
/// final repository = CatApiRepository();
/// final breeds = await repository.getBreeds(page: 0);
/// final results = await repository.searchBreeds(query: 'persian');
/// ```
class CatApiRepository implements ICatApiRepository {
  /// API key for authenticating requests to The Cat API.
  late final String _apiKey;

  /// Base URL of The Cat API.
  late final String _baseUrl;

  /// HTTP client with automatic retry capability.
  late final HttpClientWithRetry _httpClient;

  /// Creates an instance of [CatApiRepository].
  ///
  /// Loads configuration from environment variables and creates the HTTP client.
  /// Throws [ApiException] if the required API key is not found.
  ///
  /// **Throws:**
  /// - [ApiException] if `CAT_API_KEY` is not configured in `.env`
  CatApiRepository({
    HttpClientWithRetry? httpClient,
  }) {
    _apiKey = dotenv.env['CAT_API_KEY'] ?? '';
    _baseUrl = dotenv.env['CAT_API_BASE_URL'] ?? 'https://api.thecatapi.com/v1';
    _httpClient = httpClient ?? HttpClientWithRetry();

    if (_apiKey.isEmpty) {
      throw ApiException('CAT_API_KEY not found in environment variables');
    }
  }

  /// Gets a paginated list of cat breeds from the API.
  ///
  /// Makes a GET request to `/breeds` with pagination.
  /// Decodes the JSON response and converts each item to [BreedEntity].
  ///
  /// **Parameters:**
  /// - [page]: Page number (0-indexed), returns up to 10 breeds per page by default
  ///
  /// **Returns:**
  /// List of [BreedEntity] with up to 10 items per page
  ///
  /// **Throws:**
  /// - [ApiException] for HTTP errors (401, 404, 5xx)
  /// - [ParsingException] if JSON is invalid
  /// - [TimeoutException] if request exceeds time limit
  /// - [NetworkException] if network issues occur
  /// - [UnknownException] for unexpected errors
  @override
  Future<List<BreedEntity>> getBreeds({required int page}) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/breeds?limit=10&page=$page'),
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => BreedEntity.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw ApiException('Breeds not found on page $page', statusCode: 404);
      } else if (response.statusCode == 401) {
        throw ApiException('Unauthorized: Invalid API Key', statusCode: 401);
      } else {
        throw ApiException(
          'Failed to load breeds: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on AppException {
      rethrow;
    } on FormatException {
      throw ParsingException('Invalid response format from server');
    } catch (e) {
      throw UnknownException('Error loading breeds: ${e.toString()}');
    }
  }

  /// Searches for breeds matching the specified term.
  ///
  /// Makes a GET request to `/breeds/search` with the query.
  /// Search is partial and case-insensitive.
  ///
  /// **Parameters:**
  /// - [query]: Search term (e.g., "siamese", "siam" also matches)
  ///
  /// **Returns:**
  /// List of [BreedEntity] that partially match the search
  ///
  /// **Throws:**
  /// - [ApiException] for HTTP errors
  /// - [ParsingException] if JSON is invalid
  /// - [TimeoutException] if request exceeds time limit
  /// - [NetworkException] if network issues occur
  /// - [UnknownException] for unexpected errors
  @override
  Future<List<BreedEntity>> searchBreeds({required String query}) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/breeds/search?q=$query'),
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => BreedEntity.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw ApiException('No breeds found for "$query"', statusCode: 404);
      } else if (response.statusCode == 401) {
        throw ApiException('Unauthorized: Invalid API Key', statusCode: 401);
      } else {
        throw ApiException(
          'Failed to search breeds: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on AppException {
      rethrow;
    } on FormatException {
      throw ParsingException('Invalid response format from server');
    } catch (e) {
      throw UnknownException('Error searching breeds: ${e.toString()}');
    }
  }
}
