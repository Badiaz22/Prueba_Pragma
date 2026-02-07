import 'package:catbreeds/data/repository/cat_api_repository.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/use_cases/i_filter_breeds_use_case.dart';

/// Use case for filtering and searching cat breeds.
///
/// Acts as an intermediary between the presentation layer and the repository.
/// Delegates search to the repository that communicates with the API.
///
/// **Pattern:** Simple delegator implementing the Use Case pattern
/// **Single Responsibility:** Search breeds by term
///
/// **Example:**
/// ```dart
/// final useCase = FilterBreedsUseCase(catApiRepository: repository);
/// final results = await useCase.searchBreeds(query: 'persian');
/// ```
class FilterBreedsUseCase implements IFilterBreedsUseCase {
  /// Repository for accessing breed data.
  final ICatApiRepository catApiRepository;

  /// Creates an instance of [FilterBreedsUseCase].
  ///
  /// **Parameters:**
  /// - [catApiRepository]: Repository providing API access
  FilterBreedsUseCase({required this.catApiRepository});

  /// Searches for breeds in the API matching the term.
  ///
  /// Delegates the search to the repository, which handles HTTP communication
  /// and data conversion.
  ///
  /// **Parameters:**
  /// - [query]: Search term
  ///
  /// **Returns:**
  /// List of breeds matching the search
  @override
  Future<List<BreedEntity>> searchBreeds({required String query}) {
    return catApiRepository.searchBreeds(query: query);
  }
}
