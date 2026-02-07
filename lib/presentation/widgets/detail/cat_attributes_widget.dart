import 'package:catbreeds/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:catbreeds/domain/entities/breed_entity.dart';

/// Widget that displays a single attribute row with label and progress bar.
///
/// Shows a breed attribute with:
/// - Label and value (e.g., "Energy Level 4/5")
/// - A visual progress bar normalized to a 0-1 scale
///
/// **Example:**
/// ```dart
/// AttributeRowWidget(
///   label: 'Energy Level',
///   value: 4,
/// )
/// ```
class AttributeRowWidget extends StatelessWidget {
  /// Display label for the attribute.
  final String label;

  /// Numeric value of the attribute (0-5 scale).
  final int value;

  /// Creates an instance of [AttributeRowWidget].
  ///
  /// **Parameters:**
  /// - [label]: The attribute name to display
  /// - [value]: The attribute value (typically 0-5)
  const AttributeRowWidget({
    super.key,
    required this.label,
    required this.value,
  });

  /// Normalizes a 0-5 value to a 0-1 range for LinearProgressIndicator.
  ///
  /// Converts the 5-point scale to a 0-1 decimal for the progress bar.
  /// Clamps the result between 0.0 and 1.0 to prevent overflow.
  ///
  /// **Parameters:**
  /// - [value]: The original value (typically 0-5)
  ///
  /// **Returns:**
  /// A normalized value between 0.0 and 1.0
  double _normalizeValue(int value) {
    return (value / 5).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final normalizedValue = _normalizeValue(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              '$value/5',
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: normalizedValue,
            minHeight: 8.0,
            backgroundColor: AppColors.greyBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryGreenColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget that displays all cat breed attributes in a scrollable list.
///
/// Shows 8 key attributes of a cat breed:
/// - Energy Level
/// - Affection
/// - Intelligence
/// - Sociability
/// - Child Friendly
/// - Dog Friendly
/// - Grooming
/// - Health Issues
///
/// Each attribute is displayed with a visual progress bar (0-5 scale).
///
/// **Example:**
/// ```dart
/// CatAttributesWidget(catInfo: breedEntity)
/// ```

class CatAttributesWidget extends StatelessWidget {
  /// Breed information to display attributes from.
  final BreedEntity catInfo;

  /// Creates an instance of [CatAttributesWidget].
  ///
  /// **Parameters:**
  /// - [catInfo]: The breed entity containing attribute values
  const CatAttributesWidget({
    super.key,
    required this.catInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attributes',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20.0),
          AttributeRowWidget(label: 'Energy Level', value: catInfo.energyLevel),
          const SizedBox(height: 16.0),
          AttributeRowWidget(label: 'Affection', value: catInfo.affectionLevel),
          const SizedBox(height: 16.0),
          AttributeRowWidget(
              label: 'Intelligence', value: catInfo.intelligence),
          const SizedBox(height: 16.0),
          AttributeRowWidget(label: 'Sociability', value: catInfo.socialNeeds),
          const SizedBox(height: 16.0),
          AttributeRowWidget(
              label: 'Child Friendly', value: catInfo.childFriendly),
          const SizedBox(height: 16.0),
          AttributeRowWidget(label: 'Dog Friendly', value: catInfo.dogFriendly),
          const SizedBox(height: 16.0),
          AttributeRowWidget(label: 'Grooming', value: catInfo.grooming),
          const SizedBox(height: 16.0),
          AttributeRowWidget(
              label: 'Health Issues', value: catInfo.healthIssues),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
