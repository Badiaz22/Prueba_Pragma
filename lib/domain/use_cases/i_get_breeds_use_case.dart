import 'package:catbreeds/domain/entities/entities.dart';

/// Interface for the breeds retrieval use case.
///
/// Defines the contract for fetching breeds from the repository.
/// Encapsulates the business logic for data retrieval.
abstract class IGetBreedsUseCase {
  /// Gets a page of breeds.
  ///
  /// **Parameters:**
  /// - [page]: Page number (0-indexed)
  ///
  /// **Returns:**
  /// Future that resolves to a list of [BreedEntity]
  Future<List<BreedEntity>> getBreeds({required int page});
}
