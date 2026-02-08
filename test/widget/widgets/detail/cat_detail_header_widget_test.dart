import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/widgets/detail/cat_detail_header_widget.dart';

import '../../../helpers/test_breed_entity.dart';

void main() {
  group('CatDetailHeaderWidget', () {
    /// Test: Verify header displays breed name correctly
    /// Best Practice: Use test data factories to keep tests DRY and
    /// ensure consistent data across multiple test cases
    testWidgets('renders header with breed name', (WidgetTester tester) async {
      // Arrange: Create test breed using factory (defaults to Persian)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatDetailHeaderWidget(
              catInfo: TestBreedEntity.create(),
            ),
          ),
        ),
      );

      // Assert: Verify breed name displays
      expect(find.text('Persian'), findsOneWidget);
    });

    /// Test: Verify header displays breed origin information
    /// Best Practice: Test individual data fields independently
    /// to isolate failures to specific data bindings
    testWidgets('displays breed origin', (WidgetTester tester) async {
      // Arrange: Build widget with default breed (Persian from Iran)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatDetailHeaderWidget(
              catInfo: TestBreedEntity.create(),
            ),
          ),
        ),
      );

      // Assert: Verify origin displays
      expect(find.text('Iran'), findsOneWidget);
    });

    /// Test: Verify widget renders gracefully without breed image
    /// Best Practice: Test edge cases (null values, missing data)
    /// to ensure graceful degradation and user-friendly responses
    testWidgets('renders without image when URL is null',
        (WidgetTester tester) async {
      // Arrange: Create breed with null image (default)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatDetailHeaderWidget(
              catInfo: TestBreedEntity.create(),
            ),
          ),
        ),
      );

      // Assert: Verify widget renders even without image
      expect(find.byType(CatDetailHeaderWidget), findsOneWidget);
    });

    /// Test: Verify header displays complete information
    /// Best Practice: Test complete UI contract to ensure all expected
    /// information is present, not just individual pieces
    testWidgets('displays both name and origin', (WidgetTester tester) async {
      // Arrange: Build header widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatDetailHeaderWidget(
              catInfo: TestBreedEntity.create(),
            ),
          ),
        ),
      );

      // Assert: Verify both breed name and origin display together
      // Best Practice: Test complete UI composition to catch layout issues
      expect(find.text('Persian'), findsOneWidget);
      expect(find.text('Iran'), findsOneWidget);
    });
  });
}
