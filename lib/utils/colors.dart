import 'package:flutter/material.dart';

/// Centralized color palette for the Catbreeds application.
///
/// Provides a consistent set of colors used throughout the app for maintaining
/// visual coherence and brand identity. All colors are predefined as static
/// properties to ensure easy access and modification across the entire application.
///
/// **Color Palette:**
/// - White background for primary surfaces
/// - Light grey for secondary backgrounds and containers
/// - Dark grey for borders and subtle accents
/// - Primary green for branding and interactive elements
///
/// **Usage:**
/// ```dart
/// Container(
///   color: AppColors.primaryGreenColor,
///   child: const Text('Featured content'),
/// )
/// ```
///
/// All colors are defined as [Color] objects with ARGB hex values,
/// making them compatible with any Flutter widget that accepts color parameters.
class AppColors {
  /// Primary white background color for main surfaces and screens.
  ///
  /// Hex: #FDFDFD (nearly pure white with minimal tint)
  ///
  /// **Used for:**
  /// - Main scaffold background
  /// - Card and container backgrounds
  /// - AppBar background
  /// - Dialog backgrounds
  /// - Primary content areas requiring clean, bright backgrounds
  static Color whiteBackgroundColor = const Color(0xffFDFDFD);

  /// Light grey background color for secondary surfaces and subtle accents.
  ///
  /// Hex: #E5E7E4 (soft, warm grey)
  ///
  /// **Used for:**
  /// - Input field backgrounds
  /// - Chip and tag backgrounds
  /// - Secondary container backgrounds
  /// - Dividers and subtle separators
  /// - Hover states on interactive elements
  /// - Alternative background for less prominent content
  static Color greyBackgroundColor = const Color(0xffE5E7E4);

  /// Dark grey color for borders, dividers, and subtle visual hierarchy.
  ///
  /// Hex: #CDD8DA (muted blue-grey tone)
  ///
  /// **Used for:**
  /// - Border colors on cards and containers
  /// - Divider lines and separators
  /// - Icon accents and subtle visual cues
  /// - Disabled state backgrounds
  /// - Secondary text colors in certain contexts
  /// - Focus states and outlines (when accent not needed)
  static Color darkGreyBackgroundColor = const Color(0xffCDD8DA);

  /// Primary brand color - teal/green for interactive elements and accents.
  ///
  /// Hex: #2E6160 (natural, calm teal-green)
  ///
  /// **Used for:**
  /// - AppBar themes and headers
  /// - Primary buttons and CTAs
  /// - Icon button themes
  /// - Active/focused state indicators
  /// - Theme primary color in [ThemeData]
  /// - Progress indicators and loaders
  /// - Link colors and emphasis text
  /// - Selected states and checkmarks
  /// - Navigation bar highlights
  /// - Form input focus borders
  static Color primaryGreenColor = const Color(0xff2E6160);
}
