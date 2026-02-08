import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/widgets/detail/cat_temperament_widget.dart';

void main() {
  group('CatTemperamentWidget', () {
    /// Test: Verify widget displays single temperament trait with section title
    /// Best Practice: Include the section header in assertions to verify
    /// complete UI composition, not just data presence
    testWidgets('displays temperament label', (WidgetTester tester) async {
      // Arrange: Define single test temperament
      const String temperament = 'Calm';

      // Act: Build widget with temperament data
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CatTemperamentWidget(temperament: temperament),
          ),
        ),
      );

      // Assert: Verify both section title and trait are displayed
      // Best Practice: Test the complete UI contract, including headers
      expect(find.text('Temperament'), findsOneWidget);
      expect(find.text(temperament), findsOneWidget);
    });

    /// Test: Verify widget parses comma-separated traits and renders
    /// each as a separate chip
    /// Best Practice: String parsing logic is common in widgets.
    /// Test with realistic comma-separated data to ensure splitting
    /// and trimming work correctly
    testWidgets('handles multiple temperament traits',
        (WidgetTester tester) async {
      // Arrange: Use realistic comma-separated temperament string
      const String temperament = 'Bold, Active, Fearless, Affectionate, Loyal';

      // Act: Build widget with multiple traits
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CatTemperamentWidget(temperament: temperament),
          ),
        ),
      );

      // Assert: Verify each trait renders individually
      // Best Practice: Check for each chip independently to catch
      // partial parsing failures that full string checks would miss
      expect(find.text('Bold'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Fearless'), findsOneWidget);
      expect(find.text('Affectionate'), findsOneWidget);
      expect(find.text('Loyal'), findsOneWidget);

      // Verify container structure for chip layout
      // Best Practice: Verify expected widget counts to validate structure
      expect(find.byType(Container), findsWidgets);
    });

    /// Test: Verify widget handles single trait without parsing errors
    /// Best Practice: Test edge cases for string processing (single item,
    /// no commas) to ensure robust parsing logic
    testWidgets('renders single temperament trait',
        (WidgetTester tester) async {
      // Arrange: Single trait without commas
      const String singleTrait = 'Gentle';

      // Act: Build widget with single trait
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CatTemperamentWidget(temperament: singleTrait),
          ),
        ),
      );

      // Assert: Verify section header, trait, and layout structure
      // Best Practice: Test both content and structure to ensure
      // edge cases render with proper formatting
      expect(find.text('Temperament'), findsOneWidget);
      expect(find.text(singleTrait), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });
  });
}
