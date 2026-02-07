import 'package:catbreeds/domain/use_cases/i_filter_breeds_use_case.dart';
import 'package:catbreeds/domain/use_cases/i_get_breeds_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/exceptions/app_exceptions.dart';

/// State management provider for cat breed data.
///
/// This [ChangeNotifier] manages the complete lifecycle of breed data,
/// including initial loading, pagination, search, and error handling.
///
/// **Responsibilities:**
/// - Load cat breeds from the API
/// - Manage pagination to load more breeds
/// - Search breeds by name
/// - Handle loading and error states
/// - Notify subscribers of state changes
///
/// **States:**
/// - `isLoading`: Indicates if an operation is in progress
/// - `hasError`: Indicates if an error occurred
/// - `errorMessage`: Descriptive error message
/// - `breeds`: Current list of loaded breeds
/// - `searchResults`: Results from the current search
/// - `hasReachedMax`: Indicates if pagination end is reached
///
/// **Example usage:**
/// ```dart
/// final provider = BreedProvider(
///   getBreedsUseCase: GetBreedsUseCase(repository),
///   filterBreedsUseCase: FilterBreedsUseCase(repository),
/// );
/// await provider.fetchBreeds();
/// print(provider.breeds.length);
/// await provider.searchBreeds('siamese');
/// await provider.loadMoreBreeds();
/// ```
class BreedProvider extends ChangeNotifier {
  final IGetBreedsUseCase getBreedsUseCase;
  final IFilterBreedsUseCase filterBreedsUseCase;

  // State variables
  List<BreedEntity> _breeds = [];
  List<BreedEntity> _searchResults = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Pagination variables
  int _currentPage = 0;
  bool _hasReachedMax = false;

  /// Creates an instance of [BreedProvider].
  ///
  /// **Parameters:**
  /// - [getBreedsUseCase]: Use case for fetching breeds from the API
  /// - [filterBreedsUseCase]: Use case for searching and filtering breeds
  BreedProvider({
    required this.getBreedsUseCase,
    required this.filterBreedsUseCase,
  });

  // ==================== GETTERS ====================

  /// List of currently loaded breeds.
  List<BreedEntity> get breeds => _breeds;

  /// Results from the most recent search.
  List<BreedEntity> get searchResults => _searchResults;

  /// Indicates if an operation is in progress (loading, searching, etc.).
  bool get isLoading => _isLoading;

  /// Indicates if an error occurred in the most recent operation.
  bool get hasError => _hasError;

  /// Descriptive error message, if any.
  String get errorMessage => _errorMessage;

  /// Indicates if the end of pagination has been reached.
  bool get hasReachedMax => _hasReachedMax;

  // ==================== PUBLIC METHODS ====================

  /// Loads the first page of breeds from the API.
  ///
  /// This method resets pagination and loads the initial set of breeds.
  /// Updates state to `isLoading` during the operation and notifies
  /// subscribers when complete.
  ///
  /// If breeds are already loaded and an operation is in progress, this method
  /// returns without doing anything to prevent concurrent requests.
  ///
  /// **Throws:**
  /// - [TimeoutException] if request exceeds time limit
  /// - [NetworkException] if connectivity issues occur
  /// - [ApiException] if API returns an error
  /// - [ParsingException] if response is invalid
  /// - [UnknownException] for other unexpected errors
  Future<void> fetchBreeds() async {
    if (_isLoading && _breeds.isNotEmpty) return;

    _setLoading();
    _resetPaginationState();

    try {
      debugPrint('Fetching breeds from page $_currentPage...');
      final breeds = await getBreedsUseCase.getBreeds(page: _currentPage);
      debugPrint('Loaded ${breeds.length} breeds');
      _setSuccess(breeds);
    } catch (e) {
      debugPrint('Error fetching breeds: $e');
      _handleError(e);
    }
  }

  /// Loads the next page of breeds to implement infinite pagination.
  ///
  /// This method increments the page number and loads the next set of breeds.
  /// Automatically filters duplicates before adding to the list.
  ///
  /// Does nothing if:
  /// - The end of pagination has been reached (`hasReachedMax`)
  /// - An operation is in progress (`isLoading`)
  ///
  /// If an error occurs, reverts the page increment to maintain state consistency.
  ///
  /// **Throws:**
  /// - Same exceptions as [fetchBreeds]
  Future<void> loadMoreBreeds() async {
    if (_hasReachedMax || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentPage++;
      final moreBreeds = await getBreedsUseCase.getBreeds(page: _currentPage);

      if (moreBreeds.isEmpty) {
        _hasReachedMax = true;
      } else {
        final newBreeds = _filterDuplicateBreeds(moreBreeds);
        _breeds = [..._breeds, ...newBreeds];
      }

      _isLoading = false;
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _currentPage--; // Revert page increment on error
      _handleError(e, isLoadMore: true);
    }
  }

  /// Searches for breeds matching the specified query.
  ///
  /// Executes a search on server data using the provided query.
  /// Stores results in [searchResults] separately from the main breeds list.
  ///
  /// If the query is an empty string, clears search results
  /// without making an API request.
  ///
  /// **Parameters:**
  /// - [query]: Search string (e.g., "siamese", "persian")
  ///
  /// **Throws:**
  /// - Same exceptions as [fetchBreeds]
  Future<void> searchBreeds(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final results = await filterBreedsUseCase.searchBreeds(query: query);
      _searchResults = results;
      _isLoading = false;
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Clears search results and resets pagination state.
  ///
  /// Use this method when the user cancels a search to return
  /// to the full list view.
  void clearSearch() {
    _searchResults = [];
    _currentPage = 0;
    _hasReachedMax = false;
    notifyListeners();
  }

  // ==================== PRIVATE HELPER METHODS ====================

  /// Updates the state to loading.
  ///
  /// Sets `isLoading` to true and clears any previous error state.
  /// Notifies subscribers of the change.
  void _setLoading() {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }

  /// Updates the state to success with loaded data.
  ///
  /// Sets the breeds list, marks the operation as completed
  /// and clears any error state. Notifies subscribers.
  ///
  /// **Parameters:**
  /// - [breeds]: List of breeds that were successfully loaded
  void _setSuccess(List<BreedEntity> breeds) {
    _breeds = breeds;
    _isLoading = false;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }

  /// Updates the state to error with a descriptive message.
  ///
  /// Marks the operation as completed, sets the error flag,
  /// and stores the message to show to the user. Notifies subscribers.
  ///
  /// **Parameters:**
  /// - [message]: Descriptive error message to display
  void _setError(String message) {
    _isLoading = false;
    _hasError = true;
    _errorMessage = message;
    notifyListeners();
  }

  /// Resets all pagination and search variables.
  ///
  /// Used in [fetchBreeds] to start fresh when performing
  /// an initial load.
  void _resetPaginationState() {
    _currentPage = 0;
    _hasReachedMax = false;
    _searchResults = [];
  }

  /// Filters duplicate breeds from the new list by comparing IDs.
  ///
  /// Prevents adding breeds that already exist in [_breeds] when loading
  /// the next page. Compares by breed ID.
  ///
  /// **Parameters:**
  /// - [newBreeds]: List of new breeds to filter
  ///
  /// **Returns:**
  /// List of breeds that don't exist in [_breeds]
  List<BreedEntity> _filterDuplicateBreeds(List<BreedEntity> newBreeds) {
    return newBreeds
        .where((newBreed) =>
            !_breeds.any((existing) => existing.id == newBreed.id))
        .toList();
  }

  /// Handles exceptions of different types and updates error state.
  ///
  /// Converts specific exception types to readable user messages.
  /// Supports all custom application exceptions.
  ///
  /// **Parameters:**
  /// - [exception]: The exception to handle
  /// - [isLoadMore]: If true, uses specific messages for pagination loading
  void _handleError(
    dynamic exception, {
    bool isLoadMore = false,
  }) {
    String message;

    if (exception is TimeoutException) {
      message = exception.message;
    } else if (exception is NetworkException) {
      message = exception.message;
    } else if (exception is ApiException) {
      message = exception.message;
    } else if (exception is ParsingException) {
      message = exception.message;
    } else if (exception is UnknownException) {
      message = exception.message;
    } else {
      message = isLoadMore
          ? 'An error occurred while loading more breeds'
          : 'An unexpected error occurred. Please try again.';
    }

    _setError(message);
  }
}
