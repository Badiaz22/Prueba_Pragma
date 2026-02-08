import 'package:flutter/material.dart';
import 'package:catbreeds/utils/colors.dart';

/// Widget displayed when search is empty and no query is entered.
///
/// Shows instructional text to guide users to start searching.
/// Uses a centered layout with primary and secondary messages.
///
/// **Example:**
/// ```dart
/// SearchEmptyState()
/// ```
class SearchEmptyState extends StatelessWidget {
  /// Creates a [SearchEmptyState] widget.
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Widget displayed while search results are being loaded.
///
/// Shows a centered circular progress indicator with the app's primary color.
/// Used during active search queries while waiting for API results.
///
/// **Example:**
/// ```dart
/// SearchLoadingState()
/// ```
class SearchLoadingState extends StatelessWidget {
  /// Creates a [SearchLoadingState] widget.
  const SearchLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteBackgroundColor,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreenColor,
        ),
      ),
    );
  }
}

/// Widget displayed when a search error occurs.
///
/// Shows an error icon with the error message from the provider.
/// Centered layout with icon above the message text.
///
/// **Parameters:**
/// - `errorMessage`: The error message to display from the provider
///
/// **Example:**
/// ```dart
/// SearchErrorState(
///   errorMessage: breedProvider.errorMessage,
/// )
/// ```
class SearchErrorState extends StatelessWidget {
  /// The error message to display to the user.
  ///
  /// Typically comes from [BreedProvider.errorMessage].
  /// Displayed below the error icon with center alignment.
  final String errorMessage;

  /// Creates a [SearchErrorState] widget with the provided error message.
  ///
  /// The [errorMessage] parameter is required and will be displayed
  /// centered below an error icon.
  const SearchErrorState({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteBackgroundColor,
      child: Center(
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
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget displayed when search returns no results.
///
/// Shows a message indicating that no breeds matched the search query.
/// Useful feedback for users when their search doesn't yield results.
///
/// **Example:**
/// ```dart
/// SearchNoResultsState()
/// ```
class SearchNoResultsState extends StatelessWidget {
  /// Creates a [SearchNoResultsState] widget.
  const SearchNoResultsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteBackgroundColor,
      child: Center(
        child: Text(
          'No breeds found.',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
