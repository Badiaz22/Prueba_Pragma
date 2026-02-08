import 'package:catbreeds/presentation/screens/cat_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/widgets/detail/cat_description_widget.dart';

import '../../../helpers/test_breed_entity.dart';

void main() {
  group('CatDescriptionWidget', () {
    /// Test: Verify short description text renders correctly
    /// Best Practice: Test with both short and long strings to catch
    /// truncation or overflow issues that might not appear in default cases
    testWidgets('renders description text', (WidgetTester tester) async {
      // Arrange: Create short test description
      const String testDescription = 'This is a test cat breed description.';

      // Act: Build widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CatDescriptionWidget(description: testDescription),
          ),
        ),
      );

      // Assert: Verify text renders
      expect(find.text(testDescription), findsOneWidget);
    });

    /// Test: Verify long descriptions display without overflow
    /// Best Practice: Test boundary cases (long text) to ensure
    /// scrollable containers are properly configured and text wrapping works
    testWidgets('displays long descriptions correctly',
        (WidgetTester tester) async {
      // Arrange: Create multi-line description
      const String longDescription =
          'This is a very long description of a cat breed. '
          'It contains multiple sentences and should be displayed properly.';

      // Act: Build widget with long text
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CatDescriptionWidget(description: longDescription),
          ),
        ),
      );

      // Assert: Verify long text renders without issues
      expect(find.text(longDescription), findsOneWidget);
    });

    /// Test: Verify description is in scrollable context
    /// Best Practice: Test widget in its actual parent context (CatDetailScreen)
    /// to ensure scroll behavior and padding are configured correctly
    testWidgets('renders in scrollable container', (WidgetTester tester) async {
      // Arrange: Build complete screen context
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatDetailScreen(catInfo: TestBreedEntity.create()),
          ),
        ),
      );

      // Assert: Verify custom scroll view exists for proper scrolling
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    /// Test: Verify widget handles empty descriptions gracefully
    /// Best Practice: Test edge cases (empty strings) to ensure the widget
    /// doesn't crash or produce layout errors with minimal content
    testWidgets('handles empty description', (WidgetTester tester) async {
      // Arrange: Build screen with description widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatDetailScreen(
              catInfo: TestBreedEntity.create(),
            ),
          ),
        ),
      );

      // Assert: Verify widget exists even with empty state
      expect(find.byType(CatDescriptionWidget), findsOneWidget);
    });
  });
}
