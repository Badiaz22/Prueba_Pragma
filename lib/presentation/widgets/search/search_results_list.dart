import 'package:flutter/material.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/presentation/widgets/common/breed_card_widget.dart';

/// Widget that displays search results for cat breed queries.
///
/// Renders a scrollable list of [BreedEntity] items with breed cards showing:
/// - Breed image with dark overlay
/// - Name and origin information
/// - Energy level, affection level, and intelligence indicators
/// - Hero animation for smooth transition to detail screen
///
/// **Example:**
/// ```dart
/// SearchResultsList(
///   breeds: searchResults,
///   emptyMessage: 'No matches found',
/// )
/// ```
///
/// Shows a centered empty message when no breeds are found. The [emptyMessage]
/// parameter can be customized, defaulting to 'No breeds found.'
class SearchResultsList extends StatelessWidget {
  /// The list of [BreedEntity] items to display as search results.
  ///
  /// Can be empty, in which case the empty message is shown instead.
  /// Each breed is rendered as a searchable, tappable card.
  final List<BreedEntity> breeds;

  /// The message to display when the breeds list is empty.
  ///
  /// Defaults to `'No breeds found.'` if not provided.
  /// Displayed in a centered, large, bold, gray text style.
  final String emptyMessage;

  /// Creates a [SearchResultsList] widget for displaying breed search results.
  ///
  /// The [breeds] parameter is required and can be empty to show the
  /// [emptyMessage]. The [emptyMessage] parameter is optional and defaults
  /// to `'No breeds found.'` if not provided.
  ///
  /// Each breed card responds to taps by navigating to [CatDetailScreen]
  /// with a fade transition and hero animation for the image.
  const SearchResultsList({
    super.key,
    required this.breeds,
    this.emptyMessage = 'No breeds found.',
  });

  @override
  Widget build(BuildContext context) {
    if (breeds.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
      );
    }

    // Responsive height calculation
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = (screenHeight * 0.35).clamp(220.0, 300.0);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      itemCount: breeds.length,
      itemBuilder: (context, index) => BreedCard(
        breed: breeds[index],
        cardHeight: cardHeight,
      ),
    );
  }
}
