import 'package:catbreeds/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';

/// Widget that displays a single info card with icon, value, and label.
///
/// Creates a card with:
/// - An icon at the top
/// - A bold value text
/// - A label below the value
/// - Styled with green colors and rounded corners
///
/// **Example:**
/// ```dart
/// InfoCardWidget(
///   label: 'Weight',
///   value: '3 - 5 kg',
///   icon: Icons.scale,
/// )
/// ```
class InfoCardWidget extends StatelessWidget {
  /// Label to display below the value.
  final String label;

  /// Value to display (e.g., weight, life span).
  final String value;

  /// Icon to display at the top of the card.
  final IconData icon;

  /// Creates an instance of [InfoCardWidget].
  ///
  /// **Parameters:**
  /// - [label]: The attribute label (e.g., "Weight", "Life Span")
  /// - [value]: The attribute value to display
  /// - [icon]: The icon to show at the top of the card
  const InfoCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.greyBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.0, color: AppColors.primaryGreenColor),
            const SizedBox(height: 8.0),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget that displays basic information cards about a cat breed.
///
/// Shows three info cards in a horizontal row:
/// - Weight (in metric system)
/// - Life span
/// - Hypoallergenic status
///
/// Each card displays an icon, value, and label.
///
/// **Example:**
/// ```dart
/// CatBasicInfoWidget(catInfo: breedEntity)
/// ```

class CatBasicInfoWidget extends StatelessWidget {
  /// Breed information to display basic details from.
  final BreedEntity catInfo;

  /// Creates an instance of [CatBasicInfoWidget].
  ///
  /// **Parameters:**
  /// - [catInfo]: The breed entity containing weight, life span, and hypoallergenic info
  const CatBasicInfoWidget({
    super.key,
    required this.catInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoCardWidget(
                label: 'Weight',
                value: catInfo.weight.metric,
                icon: Icons.scale,
              ),
              InfoCardWidget(
                label: 'Life',
                value: catInfo.lifeSpan,
                icon: Icons.calendar_today,
              ),
              InfoCardWidget(
                label: 'Hypoallergenic',
                value: catInfo.hypoallergenic == 1 ? 'Yes' : 'No',
                icon: Icons.favorite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
