import 'package:catbreeds/data/repository/cat_api_repository.dart';
import 'package:catbreeds/domain/use_cases/filter_breeds_use_case.dart';
import 'package:catbreeds/domain/use_cases/get_breeds_use_case.dart';

/// Service locator for managing application dependencies.
///
/// Implements the Singleton pattern to provide centralized dependency management.
/// All dependencies are created once and reused throughout the application lifetime.
///
/// **Responsibilities:**
/// - Create and manage instances of repositories and use cases
/// - Provide type-safe access to dependencies via the generic [get] method
/// - Ensure single instance of each dependency class
///
/// **Usage:**
/// ```dart
/// // Initialize during app startup (in main.dart)
/// DependencyInjection.initialize();
///
/// // Retrieve dependencies anywhere
/// final repository = DependencyInjection.get<CatApiRepository>();
/// final useCase = DependencyInjection.get<GetBreedsUseCase>();
/// ```
///
/// **Current Dependencies:**
/// - [CatApiRepository]: Repository for API communication
/// - [GetBreedsUseCase]: Use case for fetching breeds
/// - [FilterBreedsUseCase]: Use case for searching breeds
class DependencyInjection {
  /// Singleton instance of the dependency injection container.
  ///
  /// Lazily created and reused for all dependency requests.
  static final DependencyInjection _instance = DependencyInjection._internal();

  /// Repository instance for API communication.
  ///
  /// Manages HTTP requests and breed data retrieval.
  late CatApiRepository _catApiRepository;

  /// Use case instance for fetching paginated breeds.
  ///
  /// Delegates to [_catApiRepository] for data retrieval.
  late GetBreedsUseCase _getBreedsUseCase;

  /// Use case instance for searching breeds.
  ///
  /// Delegates to [_catApiRepository] for search operations.
  late FilterBreedsUseCase _filterBreedsUseCase;

  /// Factory constructor that returns the singleton instance.
  ///
  /// Ensures only one instance of [DependencyInjection] exists throughout
  /// the application. Called via `DependencyInjection()`.
  factory DependencyInjection() {
    return _instance;
  }

  /// Private internal constructor to prevent instantiation.
  ///
  /// Forces usage of the factory constructor to maintain singleton pattern.
  DependencyInjection._internal();

  /// Initializes all application dependencies.
  ///
  /// **MUST be called once during app startup** (typically in `main()`)
  /// before accessing any dependencies via [get].
  ///
  /// Creates instances of:
  /// - [CatApiRepository] for API communication
  /// - [GetBreedsUseCase] with injected repository
  /// - [FilterBreedsUseCase] with injected repository
  ///
  /// **Example:**
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await dotenv.load();
  ///   DependencyInjection.initialize(); // Initialize here
  ///   runApp(const MyApp());
  /// }
  /// ```
  ///
  /// **Throws:**
  /// - [ApiException] if repository initialization fails (e.g., missing API key)
  static void initialize() {
    _instance._catApiRepository = CatApiRepository();
    _instance._getBreedsUseCase = GetBreedsUseCase(
      catApiRepository: _instance._catApiRepository,
    );
    _instance._filterBreedsUseCase = FilterBreedsUseCase(
      catApiRepository: _instance._catApiRepository,
    );
  }

  /// Retrieves a dependency by type using generic type-safety.
  ///
  /// Returns the singleton instance of the requested type if it has been
  /// initialized. Throws an exception if the type is not registered.
  ///
  /// **Type Parameters:**
  /// - [T]: The type of dependency to retrieve
  ///
  /// **Returns:**
  /// An instance of type [T] if registered, otherwise throws [Exception]
  ///
  /// **Registered Types:**
  /// - [CatApiRepository]: For API communication
  /// - [GetBreedsUseCase]: For fetching breeds
  /// - [FilterBreedsUseCase]: For searching breeds
  ///
  /// **Example:**
  /// ```dart\n  /// // Get repository
  /// final repo = DependencyInjection.get<CatApiRepository>();
  ///
  /// // Get use case
  /// final useCase = DependencyInjection.get<GetBreedsUseCase>();
  /// ```
  ///
  /// **Throws:**
  /// - [Exception] if type [T] is not registered in the container
  static T get<T>() {
    if (T == CatApiRepository) {
      return _instance._catApiRepository as T;
    } else if (T == GetBreedsUseCase) {
      return _instance._getBreedsUseCase as T;
    } else if (T == FilterBreedsUseCase) {
      return _instance._filterBreedsUseCase as T;
    }
    // Type not found in the container
    throw Exception('Type $T not found in DependencyInjection');
  }
}
