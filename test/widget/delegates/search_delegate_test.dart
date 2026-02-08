import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:catbreeds/presentation/delegates/search_delegate.dart';
import '../../helpers/mocks/breed_provider_mock.dart';

void main() {
  late MockBreedProvider mockProvider;

  setUp(() {
    mockProvider = MockBreedProvider();
  });

  Future<void> pumpSearch(
    WidgetTester tester,
    BreedProvider provider,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: BreedSearchDelegate(
                  breedProvider: provider,
                ),
              );
            },
            child: const Text("Open"),
          ),
        ),
      ),
    );

    await tester.tap(find.text("Open"));
    await tester.pumpAndSettle();
  }

  testWidgets('displays empty state when there is no query', (tester) async {
    await pumpSearch(tester, mockProvider);

    expect(find.text('Find your cat'), findsOneWidget);
  });

  testWidgets('calls searchBreeds when typing', (tester) async {
    await pumpSearch(tester, mockProvider);

    await tester.enterText(find.byType(TextField), 'bengal');
    await tester.pump();

    expect(mockProvider.searchBreedsCalls, greaterThan(0));
    expect(mockProvider.lastSearchQuery, contains('bengal'));
  });

  testWidgets('displays loading when isLoading is true', (tester) async {
    mockProvider.setIsLoading(true);

    await pumpSearch(tester, mockProvider);

    await tester.enterText(find.byType(TextField), 'bengal');
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('clears search when pressing back', (tester) async {
    await pumpSearch(tester, mockProvider);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // clearSearch debería haber sido llamado por buildLeading
    expect(mockProvider.searchResults, isEmpty);
  });

  testWidgets('displays clear button when there is query', (tester) async {
    /// Test: Verify clear button appears when search field has text
    /// Best Practice: Test buildActions() returns different widgets based on
    /// query state to ensure proper UX for clearing searches
    await pumpSearch(tester, mockProvider);

    // Initially no query = no clear button
    expect(find.byIcon(Icons.clear), findsNothing);

    // Type text
    await tester.enterText(find.byType(TextField), 'bengal');
    await tester.pumpAndSettle();

    // Now clear button should appear in buildActions
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });

  testWidgets('clears field when pressing clear button', (tester) async {
    /// Test: Verify clear button clears the search field
    /// Best Practice: Test that clearing the query also triggers proper
    /// state reset (empty state display, clearSearch() call)
    await pumpSearch(tester, mockProvider);

    await tester.enterText(find.byType(TextField), 'persian');
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.clear), findsOneWidget);

    // Tap clear button
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    // Query should be cleared and empty state shown
    expect(find.text('Find your cat'), findsOneWidget);
  });

  testWidgets('displays results when searchResults is not empty',
      (tester) async {
    /// Test: Verify SearchResultsList renders when results are available
    /// Best Practice: Mock data with actual breeds and verify list displays
    /// them correctly, testing the complete successful search flow
    final testBreeds = [
      mockProvider.breedList[0],
      mockProvider.breedList[1],
    ];
    mockProvider.setSearchResults(testBreeds);
    mockProvider.setIsLoading(false);
    mockProvider.setHasError(false);

    await pumpSearch(tester, mockProvider);

    await tester.enterText(find.byType(TextField), 'test');
    await tester.pumpAndSettle();

    // SearchResultsList should be visible
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('displays no results when query returns no results',
      (tester) async {
    /// Test: Verify SearchNoResultsState displays when no breeds match
    /// Best Practice: Test the empty results feedback to user, ensuring
    /// they know the search ran but found nothing
    mockProvider.setSearchResults([]);
    mockProvider.setIsLoading(false);
    mockProvider.setHasError(false);

    await pumpSearch(tester, mockProvider);

    await tester.enterText(find.byType(TextField), 'nonexistent');
    await tester.pumpAndSettle();

    expect(find.text('No breeds found.'), findsOneWidget);
  });

  testWidgets('does not search twice if query does not change', (tester) async {
    /// Test: Verify query deduplication - only search if query actually changed
    /// Best Practice: Optimize performance by tracking _lastSearchedQuery
    /// and avoiding duplicate API calls for the same search term
    await pumpSearch(tester, mockProvider);

    final initialCallCount = mockProvider.searchBreedsCalls;

    // Type 'ben'
    await tester.enterText(find.byType(TextField), 'ben');
    await tester.pumpAndSettle();

    final afterFirstSearch = mockProvider.searchBreedsCalls;
    expect(afterFirstSearch, greaterThan(initialCallCount));

    // Simulate user typing slowly - same 'ben' again shouldn't trigger search
    // In real scenario, this happens when buildSuggestions rebuilds
    // but query hasn't changed
    mockProvider.searchResults.clear();
    await tester.pumpAndSettle();

    final afterSecondCheck = mockProvider.searchBreedsCalls;

    // Should not increase because query didn't change
    expect(afterSecondCheck, equals(afterFirstSearch));
  });

  testWidgets('searchFieldLabel is correct', (tester) async {
    /// Test: Verify search field has correct placeholder label
    /// Best Practice: Test getters for UI text to ensure consistency
    /// and proper user guidance in search interface
    await pumpSearch(tester, mockProvider);

    expect(find.byType(TextField), findsOneWidget);
    // The SearchDelegate sets the label internally, verify it's accessible
    final delegate = BreedSearchDelegate(breedProvider: mockProvider);
    expect(delegate.searchFieldLabel, 'Search a cat breed');
  });

  testWidgets('buildResults searches when pressing search', (tester) async {
    /// Test: Verify buildResults() triggers search via postFrameCallback
    /// Best Practice: Test that submitting search from keyboard triggers
    /// the correct search operation without blocking UI
    const query = 'siamese';
    await pumpSearch(tester, mockProvider);

    await tester.enterText(find.byType(TextField), query);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(mockProvider.lastSearchQuery, contains(query));
  });
}
