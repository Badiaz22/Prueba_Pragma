import 'package:flutter/material.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';
import 'package:catbreeds/presentation/screens/cat_detail_screen.dart';
import 'package:catbreeds/presentation/widgets/home/home_bar_indicator_widget.dart';

/// Reusable card widget for displaying a single cat breed.
///
/// Displays breed information in a visually appealing card format with:
/// - Full-screen image background with dark overlay
/// - Breed name and origin information
/// - Energy level, affection level, and intelligence indicators
/// - Pets icon badge in top-left corner
/// - Forward arrow button for navigation hint
/// - Hero animation for smooth transition to detail screen
///
/// **Used in:**
/// - Home screen breed list (infinite scroll)
/// - Search results list
///
/// **Best Practice:** Extracting reusable cards eliminates duplication
/// and ensures consistent UI across screens. Changes to card design
/// only need to be made in one place.
///
/// **Example:**
/// ```dart
/// BreedCard(
///   breed: breedEntity,
///   cardHeight: 300.0,
/// )
/// ```
///
/// The card automatically handles:
/// - Navigation to [CatDetailScreen] on tap
/// - Responsive image loading (network or fallback asset)
/// - Touch feedback via [GestureDetector]
class BreedCard extends StatelessWidget {
  /// The breed entity containing all information to display.
  ///
  /// Required field providing:
  /// - id: Used for Hero tag uniqueness
  /// - name: Displayed as heading
  /// - origin: Displayed as subtitle
  /// - image: ImageEntity with URL (or null for fallback)
  /// - energyLevel, affectionLevel, intelligence: For indicators
  final BreedEntity breed;

  /// Height of the card in pixels.
  ///
  /// Defaults to 280.0 if not provided.
  /// Recommended range: 220-380 for optimal aspect ratio.
  ///
  /// **Best Practice:** Make card height responsive by calculating
  /// from screen height in parent widget (e.g., screenHeight * 0.35)
  /// before passing to BreedCard.
  final double cardHeight;

  /// Creates a [BreedCard] displaying a cat breed.
  ///
  /// **Parameters:**
  /// - [breed]: Required BreedEntity with all breed data
  /// - [cardHeight]: Optional height (defaults to 280.0)
  const BreedCard({
    super.key,
    required this.breed,
    this.cardHeight = 280.0,
  });

  /// Normalizes a 0-5 integer value to 0.0-1.0 float for progress indicators.
  ///
  /// **Why needed:** Progress indicators expect normalized 0.0-1.0 values,
  /// but breed attributes use 0-5 scale from The Cat API.
  ///
  /// **Example:**
  /// - energyLevel: 4 → 4/5 = 0.8 (80% of indicator)
  /// - intelligence: 2 → 2/5 = 0.4 (40% of indicator)
  ///
  /// clamp(0.0, 1.0) ensures value never exceeds 1.0 for safety.
  ///
  /// **Best Practice:** Centralize normalization logic so it's applied
  /// consistently throughout the app when displaying scale values.
  double _normalizeValue(int value) {
    return (value / 5).clamp(0.0, 1.0);
  }

  /// Navigates to the breed detail screen with fade transition.
  ///
  /// **What happens:**
  /// 1. Create PageRouteBuilder with custom fade transition
  /// 2. FadeTransition fades in the new screen smoothly
  /// 3. CatDetailScreen receives the full breed entity
  /// 4. Hero animation tag matches the image for smooth morphing
  ///
  /// **Best Practice:** Use custom PageRouteBuilder for:
  /// - Smooth transition animations
  /// - Passing data between screens
  /// - Coordinating Hero animations across screens
  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: CatDetailScreen(catInfo: breed),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Hero(
        /// Hero tag must be unique per breed to properly animate.
        /// Using breed.id ensures uniqueness across different breed instances.
        tag: 'cat_image_${breed.id}',
        child: Material(
          /// Transparency required here because Hero animates between screens
          /// and the Material widget needs to know the content is transparent
          /// to properly blend with background during transition.
          type: MaterialType.transparency,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            padding: const EdgeInsets.all(20.0),
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),

              /// Image decoration creates background with overlay
              image: DecorationImage(
                /// Fallback to asset image if network image not available
                image: breed.image != null
                    ? NetworkImage(breed.image!.url)
                    : const AssetImage('assets/images/cat.png')
                        as ImageProvider,
                fit: BoxFit.cover,

                /// Dark overlay improves text readability over images
                colorFilter: const ColorFilter.mode(
                  Colors.black45,
                  BlendMode.darken,
                ),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15.0,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                /// Pets icon badge in top-left corner
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

                /// Main content: breed info and indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Left column: text and indicators
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Breed name - large, bold, white
                        DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text(breed.name),
                        ),
                        const SizedBox(height: 5.0),

                        /// Breed origin - slightly smaller, semi-transparent
                        DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16.0,
                          ),
                          child: Text(breed.origin),
                        ),
                        const SizedBox(height: 12.0),

                        /// Three indicator bars for breed characteristics
                        /// Best Practice: Use decorative bars to show
                        /// characteristics at a glance without cluttering UI
                        Row(
                          children: [
                            /// Energy level indicator
                            HomeBarIndicatorWidget(
                              value: _normalizeValue(breed.energyLevel),
                            ),
                            const SizedBox(width: 8.0),

                            /// Affection level indicator
                            HomeBarIndicatorWidget(
                              value: _normalizeValue(breed.affectionLevel),
                            ),
                            const SizedBox(width: 8.0),

                            /// Intelligence level indicator
                            HomeBarIndicatorWidget(
                              value: _normalizeValue(breed.intelligence),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// Right column: forward arrow for navigation hint
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          /// Disabled button (onPressed: null) - visual hint only
                          /// Actual tap handling is on parent GestureDetector
                          onPressed: null,
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
