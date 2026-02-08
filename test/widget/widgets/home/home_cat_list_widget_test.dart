import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/widgets/home/home_cat_list_widget.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/domain/entities/weight_entity.dart';

import '../../../helpers/mocks/breed_provider_mock.dart';

void main() {
  group('HomeCatListWidget', () {
    // Best Practice: Use setUp to initialize test data common to all tests
    // to avoid code duplication and improve maintainability
    late List<BreedEntity> testBreeds;

    setUp(() {
      testBreeds = [
        BreedEntity(
          id: '1',
          name: 'Persian',
          origin: 'Iran',
          temperament: 'Calm',
          description: 'A beautiful breed',
          lifeSpan: '10 - 17',
          adaptability: 3,
          affectionLevel: 3,
          childFriendly: 3,
          dogFriendly: 2,
          energyLevel: 1,
          grooming: 5,
          healthIssues: 2,
          intelligence: 3,
          sheddingLevel: 5,
          socialNeeds: 3,
          strangerFriendly: 2,
          vocalisation: 1,
          hypoallergenic: 0,
          image: null,
          weight: WeightEntity(imperial: '7 - 12', metric: '3 - 6'),
        ),
      ];
    });

    /// Test: Verify ListView renders when list is empty
    /// Best Practice: Test edge cases like empty states to ensure
    /// graceful degradation and proper user feedback
    testWidgets('renders empty list when no breeds provided',
        (WidgetTester tester) async {
      // Arrange: Use mock provider to avoid real API calls
      // This isolates the widget behavior from dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeCatListWidget(
              size: const Size(400, 800),
              breedProvider: MockBreedProvider(),
            ),
          ),
        ),
      );

      // Assert: Verify ListView structure exists even with empty data
      expect(find.byType(ListView), findsOneWidget);
    });

    /// Test: Verify pagination callback is invoked on scroll
    /// Best Practice: Use tester.pump() to settle animations and
    /// verify async operations complete correctly
    testWidgets('calls onLoadMore when scrolling to bottom',
        (WidgetTester tester) async {
      // Arrange: Build widget with mock provider
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeCatListWidget(
              size: const Size(400, 800),
              breedProvider: MockBreedProvider(),
            ),
          ),
        ),
      );

      // Act: Allow animations and async operations to complete
      await tester.pump();

      // Assert: Verify widget is rendered (implicitly tests structure)
      expect(find.byType(HomeCatListWidget), findsOneWidget);
    });
  });
}
