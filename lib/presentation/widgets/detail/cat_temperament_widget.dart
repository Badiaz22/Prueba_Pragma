import 'package:catbreeds/utils/colors.dart';
import 'package:flutter/material.dart';

/// Widget that displays the temperament traits of a breed in a chip-style layout.
///
/// Shows a list of temperament characteristics as styled chips/pills with:
/// - Natural comma-separated parsing to extract individual traits
/// - Rounded container styling for each trait
/// - Appropriate spacing and sizing for visual hierarchy
///
/// **Example:**
/// ```dart
/// CatTemperamentWidget(
///   temperament: 'Playful, Friendly, Affectionate, Curious, Intelligent'
/// )
/// ```
///
/// The widget automatically trims whitespace from each trait after splitting.
class CatTemperamentWidget extends StatelessWidget {
  /// The temperament string containing comma-separated traits.
  ///
  /// This string will be split by commas and trimmed to extract
  /// individual personality traits of the breed. Each trait is then
  /// displayed as a separate chip.
  ///
  /// Example: `'Playful, Friendly, Affectionate, Curious, Intelligent'`
  final String temperament;

  /// Creates a [CatTemperamentWidget] that displays breed temperament traits.
  ///
  /// The [temperament] parameter is required and should contain comma-separated
  /// trait names that will be parsed and displayed as individual chips.
  ///
  /// The widget uses [Wrap] layout for responsive chip arrangement with
  /// 8.0 logical pixels spacing between elements.
  const CatTemperamentWidget({
    super.key,
    required this.temperament,
  });

  @override
  Widget build(BuildContext context) {
    final temperaments = temperament.split(',');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Temperament',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: temperaments
                .map((temp) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: AppColors.greyBackgroundColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        temp.trim(),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
