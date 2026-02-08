import 'package:flutter/material.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:catbreeds/presentation/widgets/search/search_results_list.dart';
import 'package:catbreeds/presentation/widgets/search/search_state_widgets.dart';

/// Search delegate for browsing and searching cat breeds.
///
/// Implements the [SearchDelegate] interface to provide a full-screen
/// search interface with suggestions and results for cat breed discovery.
///
/// **Responsibilities:**
/// 1. Display search suggestions as user types
/// 2. Submit search queries when user presses search
/// 3. Show loading, error, results, and empty states
/// 4. Manage search field label and styling
/// 5. Handle clear and back button actions
///
/// **How it works:**
/// - When search opens, [buildSuggestions] is called repeatedly as user types
/// - When user presses search button, [buildResults] is called
/// - All state changes are reflected via [ListenableBuilder] listening to
///   [BreedProvider] which acts as a ChangeNotifier
/// - Query deduplication via [_lastSearchedQuery] prevents duplicate API calls
///
/// **Example usage:**
/// ```dart
/// showSearch(
///   context: context,
///   delegate: BreedSearchDelegate(breedProvider: provider),
/// );
/// ```
///
/// **Best Practice:** Delegates implement SearchDelegate for Material Design
/// consistency and automatic integration with AppBar search icon behavior
class BreedSearchDelegate extends SearchDelegate {
  /// The state management provider for breed search operations.
  ///
  /// Provides:
  /// - searchBreeds(query) - Initiates breed search
  /// - clearSearch() - Resets search results
  /// - Listenable interface for rebuilding UI on state changes
  /// - searchResults, isLoading, hasError, errorMessage properties
  final BreedProvider breedProvider;

  /// Tracks the last search query to avoid duplicate searches.
  ///
  /// **Why needed:** buildSuggestions() is called on every widget rebuild,
  /// but we only want to search when the user actually types something new.
  /// This variable stores the previous query to compare with current query.
  ///
  /// **Example:**
  /// - User types "ben" → search called, _lastSearchedQuery = "ben"
  /// - Widget rebuilds from other source → query still "ben" → no search
  /// - User adds "g" → search called, _lastSearchedQuery = "beng"
  ///
  /// **Best Practice:** Query deduplication improves performance by reducing
  /// unnecessary API calls, especially important for real-time search
  String? _lastSearchedQuery;

  /// Creates a [BreedSearchDelegate] with required [breedProvider].
  ///
  /// **Parameters:**
  /// - [breedProvider]: Required instance managing breed search state
  BreedSearchDelegate({required this.breedProvider});

  /// Placeholder text displayed in the search field.
  ///
  /// Provides user guidance about what they can search for.
  /// Displayed when the search field is empty.
  ///
  /// **Best Practice:** Use clear, actionable placeholder text to improve UX
  @override
  String get searchFieldLabel => 'Search a cat breed';

  /// Text styling for the search input field.
  ///
  /// Customizes appearance of user-typed text in the search field.
  /// Currently uses:
  /// - 16pt font size for readability
  /// - Grey color for visual hierarchy
  ///
  /// **Best Practice:** Consistent styling with app theme ensures visual
  /// coherence and follows Material Design guidelines
  @override
  TextStyle get searchFieldStyle => const TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      );

  /// Builds action buttons displayed on the right of the search field.
  ///
  /// **What it does:**
  /// - Shows a clear button when user has typed text (query.isNotEmpty)
  /// - Shows nothing when search field is empty
  /// - Tapping clear button sets query = '', triggering UI refresh
  ///
  /// **Why buildSuggestions is called after clear:**
  /// Setting query = '' triggers SearchDelegate to call buildSuggestions()
  /// with empty query, which then calls breedProvider.clearSearch() to
  /// reset results and display empty state
  ///
  /// **Best Practice:** Provide quick action buttons for common operations
  /// like clear to improve UX and reduce taps needed
  ///
  /// **Returns:**
  /// List of [Widget] actions or [] if no actions needed
  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.isNotEmpty
        ? [
            IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          ]
        : [];
  }

  /// Builds the leading button (left side of search field).
  ///
  /// **What it does:**
  /// Displays a back arrow button that allows user to close the search
  /// interface and return to previous screen.
  ///
  /// **Cleanup on close:**
  /// When user presses back:
  /// 1. Call breedProvider.clearSearch() - Reset internal state
  /// 2. Call close(context, null) - Close search interface
  ///
  /// This ensures search results don't persist when reopening search later.
  ///
  /// **Best Practice:** Always clean up state when closing search to prevent
  /// showing stale results on next search open
  ///
  /// **Returns:**
  /// A [Widget] (typically an IconButton) for back navigation
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        breedProvider.clearSearch();
        close(context, null);
      },
    );
  }

  /// Builds the content shown when user submits search (presses search button).
  ///
  /// **Execution flow:**
  /// 1. addPostFrameCallback() schedules search on next frame to avoid
  ///    setState during build (Flutter lifecycle optimization)
  /// 2. ListenableBuilder rebuilds whenever breedProvider notifies listeners
  /// 3. Content changes based on loading/error/results/empty states
  ///
  /// **State handling:**
  /// - isLoading: Shows [SearchLoadingState] spinner
  /// - hasError: Shows [SearchErrorState] with error message
  /// - searchResults.isNotEmpty: Shows [SearchResultsList] with breeds
  /// - else: Shows [SearchNoResultsState] when search finds nothing
  ///
  /// **Why postFrameCallback?**
  /// Calling breedProvider.searchBreeds() directly in build() would trigger
  /// setState during build phase, causing "setState during build" errors.
  /// Deferring with addPostFrameCallback safely schedules it for next frame.
  ///
  /// **Best Practice:** Use postFrameCallback for side effects that shouldn't
  /// block the render phase. Never call setState-inducing operations directly
  /// in build methods.
  ///
  /// **Returns:**
  /// A [Widget] displaying search results or state-specific content
  @override
  Widget buildResults(BuildContext context) {
    // Trigger search on next frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      breedProvider.searchBreeds(query);
    });

    return ListenableBuilder(
      listenable: breedProvider,
      builder: (context, child) {
        if (breedProvider.isLoading) {
          return const SearchLoadingState();
        } else if (breedProvider.hasError) {
          return SearchErrorState(
            errorMessage: breedProvider.errorMessage,
          );
        } else if (breedProvider.searchResults.isNotEmpty) {
          return SearchResultsList(
            breeds: breedProvider.searchResults,
          );
        } else {
          return const SearchNoResultsState();
        }
      },
    );
  }

  /// Builds the suggestions shown as user types in the search field.
  ///
  /// **Called continuously as user types**, unlike buildResults() which
  /// is only called when user presses the search button.
  ///
  /// **Query deduplication logic:**
  /// ```
  /// if (query != _lastSearchedQuery) {  // Only if query changed
  ///   _lastSearchedQuery = query;        // Update tracking variable
  ///   if (query.isNotEmpty) {
  ///     breedProvider.searchBreeds(query);  // Search for new query
  ///   } else {
  ///     breedProvider.clearSearch();        // Clear for empty query
  ///   }
  /// }
  /// ```
  ///
  /// This prevents unnecessary API calls when:
  /// - Widget rebuilds from other sources (scroll, orientation change)
  /// - But user hasn't actually changed their typing
  ///
  /// **State progression:**
  /// 1. Empty query → Show [SearchEmptyState] with instructions
  /// 2. User types → Execute search, show loading state
  /// 3. Results available → Show [SearchResultsList]
  /// 4. No results → Show [SearchNoResultsState]
  /// 5. Error occurred → Show [SearchErrorState]
  ///
  /// **Best Practice:** Implement query deduplication in Search/Filter
  /// operations to optimize performance and reduce server load
  ///
  /// **Returns:**
  /// A [Widget] displaying suggestions or state-specific content
  @override
  Widget buildSuggestions(BuildContext context) {
    // Only search if query has actually changed
    // Best Practice: Deduplicate searches to avoid duplicate API calls
    // when widget rebuilds for unrelated reasons
    if (query != _lastSearchedQuery) {
      _lastSearchedQuery = query;
      if (query.isNotEmpty) {
        breedProvider.searchBreeds(query);
      } else {
        breedProvider.clearSearch();
      }
    }

    // Show empty state when user hasn't typed anything yet
    if (query.isEmpty) {
      return const SearchEmptyState();
    }

    // Show state-dependent content based on provider state
    return ListenableBuilder(
      listenable: breedProvider,
      builder: (context, child) {
        if (breedProvider.isLoading) {
          return const SearchLoadingState();
        } else if (breedProvider.hasError) {
          return SearchErrorState(
            errorMessage: breedProvider.errorMessage,
          );
        } else if (breedProvider.searchResults.isNotEmpty) {
          return SearchResultsList(
            breeds: breedProvider.searchResults,
          );
        } else {
          return const SearchNoResultsState();
        }
      },
    );
  }
}
