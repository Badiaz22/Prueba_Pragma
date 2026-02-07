import 'package:flutter/material.dart';
import 'package:catbreeds/utils/colors.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';

/// Widget that displays the header section of a breed detail screen.
///
/// Provides an attractive hero-animated image background with breed name and origin
/// overlay. Features include:
/// - Full-width container with 300 logical pixels height
/// - `Hero` animation for smooth image transition from list to detail view
/// - Gradient overlay for text readability
/// - Fallback to asset image if breed image is unavailable
/// - Displays breed name (large, bold) and origin (smaller, lighter)
///
/// **Example:**
/// ```dart
/// CatDetailHeaderWidget(
///   catInfo: breedEntity,
/// )
/// ```
///
/// The widget automatically handles null image cases with appropriate styling
/// and color adjustments for visual consistency.
class CatDetailHeaderWidget extends StatelessWidget {
  /// The [BreedEntity] containing breed information to display.
  ///
  /// Used to extract the breed's image URL, name, origin, and ID
  /// for hero animation tagging. The widget adapts its styling
  /// based on image availability.
  final BreedEntity catInfo;

  /// Creates a [CatDetailHeaderWidget] that displays a breed's header information.
  ///
  /// The [catInfo] parameter is required and contains all data needed for the header display.
  /// The widget creates a unique hero animation tag based on the breed's ID for smooth
  /// transitions from list view to detail view.
  ///
  /// Uses a `Hero` animation with tag `'cat_image_${catInfo.id}'` for coordinated
  /// visual transition of the image between screens.
  const CatDetailHeaderWidget({
    super.key,
    required this.catInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'cat_image_${catInfo.id}',
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: catInfo.image == null ? AppColors.greyBackgroundColor : null,
          image: DecorationImage(
            image: catInfo.image != null
                ? NetworkImage(catInfo.image!.url)
                : const AssetImage('assets/images/cat.png') as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: catInfo.image == null
                ? const ColorFilter.mode(
                    Colors.black45,
                    BlendMode.darken,
                  )
                : null,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                catInfo.image != null ? Colors.black45 : Colors.transparent,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(catInfo.name),
                ),
                const SizedBox(height: 8.0),
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18.0,
                  ),
                  child: Text(catInfo.origin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
