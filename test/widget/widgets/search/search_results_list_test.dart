import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/widgets/search/search_results_list.dart';

import '../../../helpers/test_breed_entity.dart';

void main() {
  group('SearchResultsList', () {
    /// Test: Verify single breed renders in list
    /// Best Practice: Test with minimal data to isolate widget rendering
    /// from complexity of complete datasets
    testWidgets('renders breed list items', (WidgetTester tester) async {
      // Arrange: Create test breed list
      // Best Practice: Use test factories to avoid boilerplate
      final testBreeds = [TestBreedEntity.createActiveBreed()];

      // Act: Build widget with breed data
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(breeds: testBreeds),
          ),
        ),
      );

      // Assert: Verify breed name displays in list
      expect(find.text('Bengal'), findsOneWidget);
    });

    /// Test: Verify empty state displays custom message
    /// Best Practice: Test empty states thoroughly as these often cause
    /// crashes or poor UX if not handled correctly
    testWidgets('shows empty message when no breeds found',
        (WidgetTester tester) async {
      // Arrange: Define custom empty message
      const String emptyMessage = 'No breeds found.';

      // Act: Build widget with empty list
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              breeds: [],
              emptyMessage: emptyMessage,
            ),
          ),
        ),
      );

      // Assert: Verify empty state message displays
      expect(find.text(emptyMessage), findsOneWidget);
    });

    /// Test: Verify multiple breeds render correctly in list
    /// Best Practice: Test collection rendering with multiple items
    /// to ensure ListView builds correctly and no items are dropped
    testWidgets('renders multiple breeds in list', (WidgetTester tester) async {
      // Arrange: Create diverse breed list using factories
      // Best Practice: Use factory methods to avoid 50+ lines of setup
      final multipleBreeds = [
        TestBreedEntity.createActiveBreed(),
        TestBreedEntity.createSocialBreed(),
      ];

      // Act: Build widget with multiple breeds
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(breeds: multipleBreeds),
          ),
        ),
      );

      // Assert: Verify both breeds display
      expect(find.text('Bengal'), findsOneWidget);
      expect(find.text('Siamese'), findsOneWidget);
    });

    /// Test: Verify widget uses custom empty message parameter
    /// Best Practice: Test customizable parameters are properly used
    /// by the widget to ensure flexibility works as designed
    testWidgets('uses custom empty message', (WidgetTester tester) async {
      // Arrange: Define alternative empty message
      const String customMessage = 'No matches found for your search.';

      // Act: Build with custom message
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              breeds: [],
              emptyMessage: customMessage,
            ),
          ),
        ),
      );

      // Assert: Verify custom message displays instead of default
      expect(find.text(customMessage), findsOneWidget);
    });
  });
}
