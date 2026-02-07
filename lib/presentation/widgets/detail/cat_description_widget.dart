import 'package:flutter/material.dart';

/// Widget that displays a breed description section.
///
/// Shows a formatted description of a cat breed with:
/// - "Description" header title
/// - Multi-line description text with increased line height for readability
///
/// **Example:**
/// ```dart
/// CatDescriptionWidget(
///   description: 'The Abyssinian is a slender, fine-boned cat...'
/// )
/// ```

class CatDescriptionWidget extends StatelessWidget {
  /// The breed description text to display.
  ///
  /// Typically contains detailed information about the breed's characteristics,
  /// personality, and origin.
  final String description;

  const CatDescriptionWidget({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14.0,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
