import 'package:flutter/material.dart';
import 'package:catbreeds/presentation/delegates/search_delegate.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';

/// Widget that displays a search bar on the home screen.
///
/// Provides a tappable search input widget that opens [BreedSearchDelegate]
/// when activated. Features include:
/// - White container with drop shadow for visual elevation
/// - Search icon and placeholder text
/// - Fully responsive sizing based on parent constraints
/// - Delegates search functionality to [BreedSearchDelegate]
///
/// **Example:**
/// ```dart
/// HomeSearchBarWidget(
///   size: MediaQuery.of(context).size,
///   breedProvider: breedProvider,
/// )
/// ```
///
/// Uses [GestureDetector] for tap detection and maintains consistent
/// spacing and styling with the rest of the home screen UI.
class HomeSearchBarWidget extends StatelessWidget {
  /// The parent widget's size for responsive sizing.
  ///
  /// Used to calculate the search bar width (full width) and height
  /// (7% of parent height) for responsive layout across different devices.
  final Size size;

  /// The [BreedProvider] instance for managing breed search state.
  ///
  /// Passed to [BreedSearchDelegate] to handle search queries and
  /// manage the provider state during search operations.
  final BreedProvider breedProvider;

  /// Creates a [HomeSearchBarWidget] that displays the search input field.
  ///
  /// Both [size] and [breedProvider] parameters are required.
  /// The [size] is typically obtained from `MediaQuery.of(context).size`
  /// to ensure responsive layout across different screen sizes.
  const HomeSearchBarWidget({
    super.key,
    required this.size,
    required this.breedProvider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSearch(
        context: context,
        delegate: BreedSearchDelegate(breedProvider: breedProvider),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Container(
          width: size.width,
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                spreadRadius: 1.0,
                blurRadius: 10.0,
              )
            ],
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5.0),
                Text(
                  'Search a cat breed',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[400],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
