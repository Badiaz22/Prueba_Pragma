import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/use_cases/i_get_breeds_use_case.dart';
import 'package:catbreeds/domain/use_cases/i_filter_breeds_use_case.dart';
import '../test_breed_entity.dart';

class MockBreedProvider extends BreedProvider {
  int _searchBreedsCalls = 0;
  String? _lastSearchQuery;

  // State variables
  List<BreedEntity> _breeds = [];
  List<BreedEntity> _searchResults = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  MockBreedProvider()
      : super(
          getBreedsUseCase: _FakeGetBreedsUseCase(),
          filterBreedsUseCase: _FakeFilterBreedsUseCase(),
        );

  int get searchBreedsCalls => _searchBreedsCalls;
  String? get lastSearchQuery => _lastSearchQuery;

  /// Provides a list of test breed entities for use in tests
  /// Best Practice: Use factory methods from TestBreedEntity for
  /// consistent test data across all test cases
  List<BreedEntity> get breedList => TestBreedEntity.createBreedList();

  // Para controlar los valores en tests
  void setIsLoading(bool value) {
    // ignore: invalid_use_of_protected_member
    _isLoading = value;
    notifyListeners();
  }

  void setHasError(bool value) {
    // ignore: invalid_use_of_protected_member
    _hasError = value;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    // ignore: invalid_use_of_protected_member
    _errorMessage = message;
    notifyListeners();
  }

  void setSearchResults(List<BreedEntity> results) {
    // ignore: invalid_use_of_protected_member
    _searchResults = results;
    notifyListeners();
  }

  void setBreeds(List<BreedEntity> breeds) {
    // ignore: invalid_use_of_protected_member
    _breeds = breeds;
    notifyListeners();
  }

  @override
  Future<void> searchBreeds(String query) async {
    _searchBreedsCalls++;
    _lastSearchQuery = query;
    await super.searchBreeds(query);
  }

  void resetCallCounts() {
    _searchBreedsCalls = 0;
    _lastSearchQuery = null;
  }
}

class _FakeGetBreedsUseCase implements IGetBreedsUseCase {
  @override
  Future<List<BreedEntity>> getBreeds({required int page}) async => [];
}

class _FakeFilterBreedsUseCase implements IFilterBreedsUseCase {
  @override
  Future<List<BreedEntity>> searchBreeds({required String query}) async => [];
}
