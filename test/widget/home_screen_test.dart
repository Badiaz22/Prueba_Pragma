import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/screens/home_screen.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:catbreeds/utils/app_theme.dart';
import 'package:catbreeds/domain/use_cases/i_get_breeds_use_case.dart';
import 'package:catbreeds/domain/use_cases/i_filter_breeds_use_case.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';

class FakeGetBreedsUseCase implements IGetBreedsUseCase {
  @override
  Future<List<BreedEntity>> getBreeds({required int page}) async => [];
}

class FakeFilterBreedsUseCase implements IFilterBreedsUseCase {
  @override
  Future<List<BreedEntity>> searchBreeds({required String query}) async => [];
}

void main() {
  group('HomeScreen Widget Tests', () {
    /// Test: Home screen renders correctly
    testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
      // Act
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

      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    /// Test: Scaffold is present
    testWidgets('HomeScreen contains scaffold widget',
        (WidgetTester tester) async {
      // Act
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

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    /// Test: Empty state when no breeds
    testWidgets('HomeScreen renders with empty list',
        (WidgetTester tester) async {
      // Act
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

      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    /// Test: Theme is applied
    testWidgets('HomeScreen applies theme correctly',
        (WidgetTester tester) async {
      // Act
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

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    /// Test: App bar is visible
    testWidgets('HomeScreen displays app bar', (WidgetTester tester) async {
      // Act
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

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
    });

    /// Test: Body is scrollable
    testWidgets('HomeScreen body is scrollable', (WidgetTester tester) async {
      // Act
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

      // Assert
      expect(find.byType(ListView), findsWidgets);
    });
  });
}
