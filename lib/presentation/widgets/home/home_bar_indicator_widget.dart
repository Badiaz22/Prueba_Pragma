import 'package:flutter/material.dart';

/// Widget that displays a visual indicator bar for numeric values.
///
/// Shows a filled bar within a background container to represent a value
/// from 0.0 to 1.0. Used to visualize breed attributes like energy level,
/// affection level, and intelligence on the home screen list cards.
///
/// **Example:**
/// ```dart
/// HomeBarIndicatorWidget(
///   value: 0.75, // 75% filled
/// )
/// ```
///
/// The widget uses a background bar (semi-transparent white) with an overlaid
/// filled bar (solid white) that scales according to the provided value.
class HomeBarIndicatorWidget extends StatelessWidget {
  /// The fill level of the indicator bar (0.0 to 1.0).
  ///
  /// A value of 0.0 shows an empty bar, while 1.0 shows a completely filled bar.
  /// Values between 0.0 and 1.0 show proportionally filled bars. Typically values
  /// are normalized from attribute scores using `(score / 5).clamp(0.0, 1.0)`.
  final double value;

  /// Creates a [HomeBarIndicatorWidget] that visualizes a normalized numeric value.
  ///
  /// The [value] parameter is required and should typically be a value
  /// between 0.0 (empty) and 1.0 (full), though values outside this range
  /// will be rendered (clamped in some contexts).
  ///
  /// The indicator bar has fixed dimensions (4.0 width, 30.0 height) and
  /// fills from bottom to top based on the value.
  const HomeBarIndicatorWidget({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4.0,
      height: 30.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: Colors.white10,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 4.0,
          height: 30.0 * value,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
