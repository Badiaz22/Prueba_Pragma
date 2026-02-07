import 'package:catbreeds/domain/entities/entities.dart';
import 'package:catbreeds/data/repository/cat_api_repository.dart';
import 'package:catbreeds/domain/use_cases/i_get_breeds_use_case.dart';

/// Use case for fetching cat breeds with pagination.
///
/// Acts as an intermediary between the presentation layer and the repository.
/// Delegates data retrieval to the repository transparently.
///
/// **Pattern:** Simple delegator implementing the Use Case pattern
/// **Single Responsibility:** Fetch paginated breeds
///
/// **Example:**
/// ```dart
/// final useCase = GetBreedsUseCase(catApiRepository: repository);
/// final breeds = await useCase.getBreeds(page: 0);
/// ```
class GetBreedsUseCase implements IGetBreedsUseCase {
  /// Repository for accessing breed data.
  final ICatApiRepository catApiRepository;

  /// Creates an instance of [GetBreedsUseCase].
  ///
  /// **Parameters:**
  /// - [catApiRepository]: Repository providing API access
  GetBreedsUseCase({required this.catApiRepository});

  /// Fetches breeds from the API for the specified page.
  ///
  /// Delegates the call to the repository, which handles HTTP logic
  /// and data conversion.
  ///
  /// **Parameters:**
  /// - [page]: Page number (0-indexed)
  ///
  /// **Returns:**
  /// List of breeds on the specified page
  @override
  Future<List<BreedEntity>> getBreeds({required int page}) {
    return catApiRepository.getBreeds(page: page);
  }
}
