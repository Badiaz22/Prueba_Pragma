import 'package:catbreeds/domain/entities/breed_entity.dart';

/// Interface for the breed search and filtering use case.
///
/// Defines the contract for searching breeds matching a term.
/// Encapsulates the business logic for data search.
abstract class IFilterBreedsUseCase {
  /// Searches for breeds by search term.
  ///
  /// **Parameters:**
  /// - [query]: Search term (e.g., "siamese", "bengal")
  ///
  /// **Returns:**
  /// Future that resolves to a list of [BreedEntity] that match
  Future<List<BreedEntity>> searchBreeds({required String query});
}
