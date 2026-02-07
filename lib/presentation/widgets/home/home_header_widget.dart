import 'package:flutter/material.dart';
import 'package:catbreeds/utils/colors.dart';

/// Widget that displays the application header/title on the home screen.
///
/// Shows a centered "Catbreeds" title with responsive sizing.
/// Features include:
/// - Responsive height (15% of parent height)
/// - Responsive font size (8% of screen width)
/// - Bold green text using [AppColors.primaryGreenColor]
/// - Bottom margin for spacing from subsequent content
///
/// **Example:**
/// ```dart
/// HomeHeaderWidget(
///   size: MediaQuery.of(context).size,
/// )
/// ```
///
/// The widget uses responsive sizing to maintain visual consistency
/// across different screen dimensions and orientations.
class HomeHeaderWidget extends StatelessWidget {
  /// The parent widget's size for responsive sizing.
  ///
  /// Used to calculate both the container height (15% of parent height)
  /// and the title font size (8% of screen width) for responsive layout.
  final Size size;

  /// Creates a [HomeHeaderWidget] that displays the app title/header.
  ///
  /// The [size] parameter is required and should be obtained from
  /// `MediaQuery.of(context).size` to ensure proper responsive scaling
  /// of both the container and text dimensions.
  const HomeHeaderWidget({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height * 0.15,
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Catbreeds',
          style: TextStyle(
            fontSize: size.width * 0.08,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreenColor,
          ),
        ),
      ),
    );
  }
}
