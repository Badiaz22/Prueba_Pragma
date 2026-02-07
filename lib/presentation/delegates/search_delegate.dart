import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:flutter/material.dart';
import 'package:catbreeds/utils/colors.dart';
import 'package:catbreeds/presentation/widgets/search/search_results_list.dart';

class BreedSearchDelegate extends SearchDelegate {
  final BreedProvider breedProvider;
  String? _lastSearchedQuery;

  BreedSearchDelegate({required this.breedProvider});

  @override
  String get searchFieldLabel => 'Search a cat breed';

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      );

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

  @override
  Widget buildResults(BuildContext context) {
    // Trigger search on next frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      breedProvider.searchBreeds(query);
    });

    return _buildSearchContent();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Only search if query has actually changed
    if (query != _lastSearchedQuery) {
      _lastSearchedQuery = query;
      if (query.isNotEmpty) {
        breedProvider.searchBreeds(query);
      } else {
        breedProvider.clearSearch();
      }
    }

    if (query.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSearchContent();
  }

  /// Builds the search content with loading, error, and results states
  Widget _buildSearchContent() {
    return Container(
      color: AppColors.whiteBackgroundColor,
      child: ListenableBuilder(
        listenable: breedProvider,
        builder: (context, child) {
          if (breedProvider.isLoading) {
            return _buildLoadingState();
          } else if (breedProvider.hasError) {
            return _buildErrorState();
          } else if (breedProvider.searchResults.isNotEmpty) {
            return SearchResultsList(
              breeds: breedProvider.searchResults,
            );
          } else {
            return _buildNoResultsState();
          }
        },
      ),
    );
  }

  /// Builds empty state when no query is entered
  Widget _buildEmptyState() {
    return Container(
      color: AppColors.whiteBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Find your cat',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Discover the best breed for you.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Builds loading state
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryGreenColor,
      ),
    );
  }

  /// Builds error state
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.grey[400],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            breedProvider.errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds no results state
  Widget _buildNoResultsState() {
    return Center(
      child: Text(
        'No breeds found.',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
