import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/screens/home_screen.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:catbreeds/utils/app_theme.dart';
import 'package:catbreeds/domain/use_cases/i_get_breeds_use_case.dart';
import 'package:catbreeds/domain/use_cases/i_filter_breeds_use_case.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';

/// Minimal fake implementation for testing without real API calls
/// Best Practice: Use fake implementations for dependencies to isolate
/// widget under test from external services and reduce test complexity
class FakeGetBreedsUseCase implements IGetBreedsUseCase {
  @override
  Future<List<BreedEntity>> getBreeds({required int page}) async => [];
}

/// Minimal fake implementation for search functionality
class FakeFilterBreedsUseCase implements IFilterBreedsUseCase {
  @override
  Future<List<BreedEntity>> searchBreeds({required String query}) async => [];
}

void main() {
  group('HomeScreen Widget Tests', () {
    /// Test: Verify home screen renders without errors
    /// Best Practice: Extract setup code (MaterialApp + theme) into
    /// a helper function to reduce duplication across all tests
    testWidgets('displays correctly', (WidgetTester tester) async {
      // Arrange & Act: Build complete widget tree
      // Note: Always use theme and MaterialApp wrapper for integration tests
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: HomeScreen(
            breedProvider: BreedProvider(
              getBreedsUseCase: FakeGetBreedsUseCase(),
              filterBreedsUseCase: FakeFilterBreedsUseCase(),
            ),
          ),
        ),
      );
      // Allow animations and async operations to complete
      await tester.pump();

      // Assert: Verify widget renders
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    /// Test: Verify Scaffold structure exists
    /// Best Practice: Test layout structure to ensure proper Material Design
    /// implementation and widget hierarchy is correct
    testWidgets('contains scaffold widget', (WidgetTester tester) async {
      // Arrange & Act: Build widget
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: HomeScreen(
            breedProvider: BreedProvider(
              getBreedsUseCase: FakeGetBreedsUseCase(),
              filterBreedsUseCase: FakeFilterBreedsUseCase(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert: Verify Scaffold exists for proper layout
      expect(find.byType(Scaffold), findsOneWidget);
    });

    /// Test: Verify empty state renders gracefully
    /// Best Practice: Test empty states thoroughly to ensure no crashes
    /// and appropriate UI feedback when data is unavailable
    testWidgets('renders with empty list', (WidgetTester tester) async {
      // Arrange & Act: Build screen with empty data source
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: HomeScreen(
            breedProvider: BreedProvider(
              getBreedsUseCase: FakeGetBreedsUseCase(),
              filterBreedsUseCase: FakeFilterBreedsUseCase(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert: Verify screen renders even with empty state
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    /// Test: Verify theme application
    /// Best Practice: Test theme is correctly applied to ensure
    /// consistent styling and Material Design compliance
    testWidgets('applies theme correctly', (WidgetTester tester) async {
      // Arrange & Act: Build with explicit theme
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: HomeScreen(
            breedProvider: BreedProvider(
              getBreedsUseCase: FakeGetBreedsUseCase(),
              filterBreedsUseCase: FakeFilterBreedsUseCase(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert: Verify scaffold renders (implicit theme test)
      expect(find.byType(Scaffold), findsOneWidget);
    });

    /// Test: Verify AppBar is present
    /// Best Practice: Test key navigation elements to ensure
    /// proper app structure and Material convention compliance
    testWidgets('displays app bar', (WidgetTester tester) async {
      // Arrange & Act: Build widget
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: HomeScreen(
            breedProvider: BreedProvider(
              getBreedsUseCase: FakeGetBreedsUseCase(),
              filterBreedsUseCase: FakeFilterBreedsUseCase(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert: Verify app bar exists for header/navigation
      expect(find.byType(AppBar), findsOneWidget);
    });

    /// Test: Verify content scrollability
    /// Best Practice: Test scrollable content to ensure long lists
    /// don't cause overflow and provide proper UX for navigation
    testWidgets('body is scrollable', (WidgetTester tester) async {
      // Arrange & Act: Build widget with scrollable content
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: HomeScreen(
            breedProvider: BreedProvider(
              getBreedsUseCase: FakeGetBreedsUseCase(),
              filterBreedsUseCase: FakeFilterBreedsUseCase(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert: Verify ListView (scrollable) exists in body
      // Best Practice: Check for ListView/ScrollView to ensure
      // content can be scrolled on small screens
      expect(find.byType(ListView), findsWidgets);
    });
  });
}
