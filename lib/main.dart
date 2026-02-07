import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/use_cases/filter_breeds_use_case.dart';
import 'package:catbreeds/domain/use_cases/get_breeds_use_case.dart';
import 'package:catbreeds/presentation/screens/cat_detail_screen.dart';
import 'package:catbreeds/presentation/screens/home_screen.dart';
import 'package:catbreeds/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:catbreeds/di/dependecy_injection.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Global breeds provider accessible throughout the app.
late BreedProvider _breedProvider;

/// Main entry point of the Catbreeds application.
///
/// **Responsibilities:**
/// 1. Loads environment variables from `.env`
/// 2. Initializes dependency injection
/// 3. Creates the global state provider
/// 4. Starts the Flutter application
///
/// **Initialization flow:**
/// ```
/// WidgetsFlutterBinding.ensureInitialized()
///   ↓
/// dotenv.load() - Load environment variables
///   ↓
/// DependencyInjection.initialize() - Configure dependency injection
///   ↓
/// _breedProvider = BreedProvider(...) - Create state provider
///   ↓
/// runApp(MyApp()) - Start the app
/// ```
///
/// **Error Handling:**
/// - Non-fatal warnings if `.env` doesn't load (uses defaults)
/// - Fatal errors if dependency injection fails
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
    debugPrint('.env loaded successfully');
  } catch (e) {
    debugPrint(' Warning loading .env: $e');
  }

  try {
    DependencyInjection.initialize();
    _breedProvider = BreedProvider(
      getBreedsUseCase: DependencyInjection.get<GetBreedsUseCase>(),
      filterBreedsUseCase: DependencyInjection.get<FilterBreedsUseCase>(),
    );
    debugPrint(' Dependency injection initialized');
  } catch (e) {
    debugPrint(' Error initializing app: $e');
    rethrow;
  }

  runApp(const MyApp());
}

/// Root widget of the Catbreeds application.
///
/// Configures:
/// - **Theme:** AppTheme.light() for clean interface
/// - **Navigation:** onGenerateRoute for route handling
/// - **Home:** HomeScreen with injected BreedProvider
///
/// **Supported routes:**
/// - `/`: HomeScreen (breeds list)
/// - `/catDetail`: CatDetailScreen (breed details, receives [BreedEntity])
///
/// **Navigation example:**
/// ```dart
/// Navigator.of(context).pushNamed('catDetail', arguments: breedEntity);
/// ```
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catsbreed',
      theme: AppTheme.light(),
      onGenerateRoute: (page) {
        if (page.name == 'catDetail') {
          final BreedEntity catInfo = page.arguments as BreedEntity;
          return MaterialPageRoute(
              builder: (context) => CatDetailScreen(
                    catInfo: catInfo,
                  ));
        }
        return MaterialPageRoute(
            builder: (context) => HomeScreen(breedProvider: _breedProvider));
      },
      home: Scaffold(
        body: HomeScreen(
          breedProvider: _breedProvider,
        ),
      ),
    );
  }
}
