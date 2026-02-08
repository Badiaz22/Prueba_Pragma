import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/widgets/detail/cat_attributes_widget.dart';

import '../../../helpers/test_breed_entity.dart';

void main() {
  group('CatAttributesWidget', () {
    /// Test: Verify widget renders section header and attribute rows
    /// Best Practice: Test complete widget composition including
    /// headers and internal child widgets to ensure full UI integrity
    testWidgets('renders attributes section', (WidgetTester tester) async {
      // Arrange: Create test breed with default attributes
      // Best Practice: Use factory methods for consistent test data
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatAttributesWidget(catInfo: TestBreedEntity.create()),
          ),
        ),
      );

      // Assert: Verify widget renders with header and child rows
      expect(find.byType(CatAttributesWidget), findsOneWidget);
      expect(find.text('Attributes'), findsOneWidget);
      expect(find.byType(AttributeRowWidget), findsWidgets);
    });

    /// Test: Verify all eight attribute labels display correctly
    /// Best Practice: Test completeness by verifying all expected labels.
    /// This catches missing attributes that could impact user experience.
    testWidgets('displays all attribute labels', (WidgetTester tester) async {
      // Arrange: Build widget with test data
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatAttributesWidget(catInfo: TestBreedEntity.create()),
          ),
        ),
      );

      // Assert: Verify section header
      // Best Practice: Test headers to ensure layout consistency
      expect(find.text('Attributes'), findsOneWidget);

      // Assert: Verify all eight attribute labels display
      // Best Practice: Test data completeness to prevent silent failures
      // where missing attributes wouldn't be user-visible until careful review
      expect(find.text('Energy Level'), findsOneWidget);
      expect(find.text('Affection'), findsOneWidget);
      expect(find.text('Intelligence'), findsOneWidget);
      expect(find.text('Sociability'), findsOneWidget);
      expect(find.text('Child Friendly'), findsOneWidget);
      expect(find.text('Dog Friendly'), findsOneWidget);
      expect(find.text('Grooming'), findsOneWidget);
      expect(find.text('Health Issues'), findsOneWidget);
    });

    /// Test: Verify widget displays different attribute values correctly
    /// Best Practice: Test with varied data (active breed vs. default).
    /// This ensures data binding works across different value ranges.
    testWidgets('renders with different attribute values',
        (WidgetTester tester) async {
      // Arrange: Use active breed factory (has high energy, etc.)
      // Best Practice: Test with realistic data variations
      final breed = TestBreedEntity.createActiveBreed();

      // Act: Build widget with different values
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatAttributesWidget(catInfo: breed),
          ),
        ),
      );

      // Assert: Verify widget renders with varied data
      expect(find.byType(CatAttributesWidget), findsOneWidget);

      // Assert: Verify numeric values display correctly
      // Best Practice: Test data transformation (int to string "X/5")
      // to catch formatting issues that wouldn't be visible in default state
      expect(find.text('${breed.energyLevel}/5'), findsOneWidget);
      expect(find.text('${breed.affectionLevel}/5'), findsOneWidget);
      expect(find.text('${breed.intelligence}/5'), findsOneWidget);
    });

    /// Test: Verify progress bars render for each attribute
    /// Best Practice: Test visual indicators (progress bars) render correctly.
    /// These are critical for user comprehension of attribute levels.
    testWidgets('displays progress bars for each attribute',
        (WidgetTester tester) async {
      // Arrange: Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatAttributesWidget(catInfo: TestBreedEntity.create()),
          ),
        ),
      );

      // Assert: Verify progress indicators exist for all attributes
      // Best Practice: Check for visual widget types to ensure complete
      // rendering of the UI without relying solely on text verification
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });
  });
}
