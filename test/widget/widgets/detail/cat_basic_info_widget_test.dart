import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/widgets/detail/cat_basic_info_widget.dart';
import '../../../helpers/test_breed_entity.dart';

void main() {
  group('CatBasicInfoWidget', () {
    /// Test: Verify all three info cards render correctly
    /// Best Practice: Use test factory methods (TestBreedEntity.create())
    /// to avoid boilerplate and ensure consistent test data across tests
    testWidgets('renders all three info cards', (WidgetTester tester) async {
      // Arrange: Create realistic test data using factory
      final breed = TestBreedEntity.create();

      // Act: Build the complete widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatBasicInfoWidget(catInfo: breed),
          ),
        ),
      );

      // Assert: Verify all three card labels are present
      // Best Practice: Test complete UI composition to ensure
      // no cards are accidentally omitted during development
      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('Life'), findsOneWidget);
      expect(find.text('Hypoallergenic'), findsOneWidget);
    });

    /// Test: Verify weight data is displayed in metric format
    /// Best Practice: Test data transformation (imperial vs metric)
    /// to ensure correct unit conversions in production
    testWidgets('displays weight metric correctly',
        (WidgetTester tester) async {
      // Arrange: Create breed with defined weight
      final breed = TestBreedEntity.create();

      // Act: Build widget with breed data
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatBasicInfoWidget(catInfo: breed),
          ),
        ),
      );

      // Assert: Verify metric weight displays correctly
      // Best Practice: Use actual data from test entity to catch
      // transformation bugs and ensure data binding works correctly
      expect(find.text(breed.weight.metric), findsOneWidget);
    });

    /// Test: Verify life span data displays correctly
    /// Best Practice: Test additional data fields independently
    /// to isolate failures to specific data bindings
    testWidgets('displays life span correctly', (WidgetTester tester) async {
      // Arrange: Create breed with life span data
      final breed = TestBreedEntity.create();

      // Act: Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatBasicInfoWidget(catInfo: breed),
          ),
        ),
      );

      // Assert: Verify life span displays
      expect(find.text(breed.lifeSpan), findsOneWidget);
    });

    /// Test: Verify conditional display of hypoallergenic status
    /// Best Practice: Test boolean-to-string conversions and
    /// conditional rendering (ternary operators in widgets)
    testWidgets('displays hypoallergenic as Yes when value is 1',
        (WidgetTester tester) async {
      // Arrange: Create breed with hypoallergenic enabled
      final breed = TestBreedEntity.create(hypoallergenic: 1);

      // Act: Build widget with hypoallergenic breed
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatBasicInfoWidget(catInfo: breed),
          ),
        ),
      );

      // Assert: Verify conditional rendering for true state
      expect(find.text('Yes'), findsOneWidget);
    });

    /// Test: Verify hypoallergenic displays as No for false state
    /// Best Practice: Test both branches of conditional logic (true/false)
    /// to ensure complete coverage of conditional rendering
    testWidgets('displays hypoallergenic as No when value is 0',
        (WidgetTester tester) async {
      // Arrange: Create breed without hypoallergenic trait
      final breed = TestBreedEntity.create(hypoallergenic: 0);

      // Act: Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatBasicInfoWidget(catInfo: breed),
          ),
        ),
      );

      // Assert: Verify false branch of conditional renders correctly
      expect(find.text('No'), findsOneWidget);
    });

    /// Test: Verify icons display correctly in all three cards
    /// Best Practice: Test visual assets (icons) to ensure they're
    /// correctly mapped to their respective data fields
    testWidgets('displays icons correctly', (WidgetTester tester) async {
      // Arrange: Create test data
      final breed = TestBreedEntity.create();

      // Act: Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatBasicInfoWidget(catInfo: breed),
          ),
        ),
      );

      // Assert: Verify all three icons are present
      // Best Practice: Check for specific icons to validate correct
      // visual representation of data categories
      expect(find.byIcon(Icons.scale), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    /// Test: Verify Row layout is used for horizontal card arrangement
    /// Best Practice: Test layout widgets to ensure responsive design
    /// and proper widget tree structure
    testWidgets('renders with Row layout', (WidgetTester tester) async {
      // Arrange: Create test data
      final breed = TestBreedEntity.create();

      // Act: Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatBasicInfoWidget(catInfo: breed),
          ),
        ),
      );

      // Assert: Verify Row layout is used for card arrangement
      // Best Practice: Validate layout structure to ensure responsive
      // behavior is maintained across widget updates
      expect(find.byType(Row), findsOneWidget);
    });
  });

  group('InfoCardWidget', () {
    /// Test: Verify individual card renders label and value correctly
    /// Best Practice: InfoCardWidget requires Row parent context
    /// (uses Expanded internally). Always test in proper context.
    testWidgets('renders within Row context', (WidgetTester tester) async {
      // Arrange: Build widget in proper Row context
      // Note: Expanded widgets MUST be in Row/Column/Flex
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                InfoCardWidget(
                  label: 'Weight',
                  value: '3 - 5 kg',
                  icon: Icons.scale,
                ),
              ],
            ),
          ),
        ),
      );

      // Assert: Verify text content renders
      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('3 - 5 kg'), findsOneWidget);
    });

    /// Test: Verify icon displays correctly in card
    /// Best Practice: Test visual assets independently of text
    /// to catch icon mapping errors
    testWidgets('displays icon correctly within Row',
        (WidgetTester tester) async {
      // Arrange: Build widget in Row context with specific icon
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                InfoCardWidget(
                  label: 'Life Span',
                  value: '10 - 17 years',
                  icon: Icons.calendar_today,
                ),
              ],
            ),
          ),
        ),
      );

      // Assert: Verify correct icon is displayed
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    /// Test: Verify card renders as styled Container
    /// Best Practice: Test widget composition to ensure styling
    /// and layout structure are correctly applied
    testWidgets('renders as card widget', (WidgetTester tester) async {
      // Arrange: Build in Row context
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                InfoCardWidget(
                  label: 'Origin',
                  value: 'Iran',
                  icon: Icons.public,
                ),
              ],
            ),
          ),
        ),
      );

      // Assert: Verify container structure exists
      expect(find.byType(Container), findsWidgets);
    });

    /// Test: Verify card handles different label and value combinations
    /// Best Practice: Test with multiple data variations to ensure
    /// widget is flexible and reusable across different data types
    testWidgets('handles different labels and values',
        (WidgetTester tester) async {
      // Arrange: Build with different label text
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                InfoCardWidget(
                  label: 'Energy Level',
                  value: 'High',
                  icon: Icons.flash_on,
                ),
              ],
            ),
          ),
        ),
      );

      // Assert: Verify custom text renders without issues
      expect(find.text('Energy Level'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
    });
  });
}
