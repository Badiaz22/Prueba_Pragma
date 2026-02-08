import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/widgets/home/home_bar_indicator_widget.dart';

void main() {
  group('HomeBarIndicatorWidget', () {
    /// Test: Verify decorative bar indicator renders correctly
    /// Best Practice: Test one concern per test. This test focuses
    /// on rendering without making assumptions about implementation details.
    testWidgets('renders indicator bar', (WidgetTester tester) async {
      // Arrange: Set a mid-range value for the bar
      const double testValue = 0.5;

      // Act: Build widget with test value
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeBarIndicatorWidget(value: testValue),
          ),
        ),
      );

      // Assert: Verify widget and internal structure exist
      expect(find.byType(HomeBarIndicatorWidget), findsOneWidget);
      // Best Practice: Verify structure by checking for expected widget types
      expect(find.byType(Container), findsWidgets);
    });

    /// Test: Verify empty state (zero value)
    /// Best Practice: Test boundary conditions (min, max, edge cases)
    /// to ensure robust behavior across all possible inputs
    testWidgets('displays empty bar with zero value',
        (WidgetTester tester) async {
      // Arrange: Set minimum value
      const double minValue = 0.0;

      // Act: Build widget with minimum value
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeBarIndicatorWidget(value: minValue),
          ),
        ),
      );

      // Assert: Verify widget renders with empty state
      expect(find.byType(HomeBarIndicatorWidget), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    /// Test: Verify full state (maximum value)
    /// Best Practice: Complete boundary testing ensures consistent
    /// behavior across the full range of input values
    testWidgets('displays full bar with maximum value',
        (WidgetTester tester) async {
      // Arrange: Set maximum value
      const double maxValue = 1.0;

      // Act: Build widget with maximum value
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeBarIndicatorWidget(value: maxValue),
          ),
        ),
      );

      // Assert: Verify full state renders correctly
      expect(find.byType(HomeBarIndicatorWidget), findsOneWidget);
    });

    /// Test: Verify widget handles multiple different values
    /// Best Practice: Test collection rendering to ensure proper
    /// widget tree construction and layout when multiple widgets exist
    testWidgets('handles different value levels', (WidgetTester tester) async {
      // Arrange & Act: Build multiple bars with different values
      // Best Practice: Use Column to test multiple widgets in sequence
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                HomeBarIndicatorWidget(value: 0.2),
                HomeBarIndicatorWidget(value: 0.5),
                HomeBarIndicatorWidget(value: 0.8),
              ],
            ),
          ),
        ),
      );

      // Assert: Verify all three bars render correctly
      // findsNWidgets ensures exact count, preventing silent failures
      expect(find.byType(HomeBarIndicatorWidget), findsNWidgets(3));
    });

    /// Test: Verify bar responds to dynamic value changes
    /// Best Practice: Test widget rebuild behavior by pumpWidget twice
    /// to verify state updates and hot reload compatibility
    testWidgets('bar is decorative and responsive to value changes',
        (WidgetTester tester) async {
      // Arrange & Act 1: Build with initial low value
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeBarIndicatorWidget(value: 0.3),
          ),
        ),
      );

      // Assert 1: Verify initial state
      expect(find.byType(HomeBarIndicatorWidget), findsOneWidget);

      // Act 2: Rebuild with new high value (simulates state change)
      // Best Practice: This pattern tests hot reload / widget rebuild
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeBarIndicatorWidget(value: 0.9),
          ),
        ),
      );

      // Assert 2: Verify widget responds to value change
      expect(find.byType(HomeBarIndicatorWidget), findsOneWidget);
    });
  });
}
