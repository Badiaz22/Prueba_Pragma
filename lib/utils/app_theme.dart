import 'package:flutter/material.dart';
import 'package:catbreeds/utils/colors.dart';

/// Centralized theme configuration for the Catbreeds application.
///
/// Provides a consistent, customizable theme following Material Design 3 principles.
/// Includes:
/// - Light theme configuration with green primary color
/// - Comprehensive text theme with 12 predefined styles
/// - Styled widgets (buttons, inputs, chips) with consistent theming
/// - Responsive design support with proper color schemes
///
/// **Usage:**
/// ```dart
/// MaterialApp(
///   title: 'Catbreeds',
///   theme: AppTheme.light(),
///   home: const HomeScreen(),
/// )
/// ```
///
/// The theme uses [AppColors.primaryGreenColor] as the primary accent color
/// throughout the application for consistency with the app's visual identity.
class AppTheme {
  /// Creates a light theme configuration for the application.
  ///
  /// Returns a [ThemeData] configured for light mode with:
  /// - Material 3 design system enabled
  /// - Green primary color from [AppColors]
  /// - Custom text theme with 12 predefined styles
  /// - Themed widgets (buttons, input fields, chips)
  /// - AppBar styling with white background
  /// - Error color set to red for validation feedback
  ///
  /// This method should be used in the [MaterialApp.theme] property
  /// to ensure consistent styling across the entire application.
  ///
  /// **Example:**
  /// ```dart
  /// ThemeData appTheme = AppTheme.light();
  /// ```
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGreenColor,
      scaffoldBackgroundColor: AppColors.whiteBackgroundColor,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryGreenColor,
        secondary: AppColors.primaryGreenColor,
        surface: AppColors.whiteBackgroundColor,
        error: Colors.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.whiteBackgroundColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _titleLarge,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      textTheme: const TextTheme(
        displayLarge: _displayLarge,
        displayMedium: _displayMedium,
        displaySmall: _displaySmall,
        headlineMedium: _headlineMedium,
        headlineSmall: _headlineSmall,
        titleLarge: _titleLarge,
        titleMedium: _titleMedium,
        titleSmall: _titleSmall,
        bodyLarge: _bodyLarge,
        bodyMedium: _bodyMedium,
        bodySmall: _bodySmall,
        labelLarge: _labelLarge,
        labelMedium: _labelMedium,
        labelSmall: _labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreenColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreenColor,
          side: BorderSide(color: AppColors.primaryGreenColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _labelLarge.copyWith(color: AppColors.primaryGreenColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGreenColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: _labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.primaryGreenColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.greyBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryGreenColor,
            width: 2,
          ),
        ),
        hintStyle: _bodyMedium.copyWith(color: Colors.black54),
        labelStyle: _bodyMedium.copyWith(color: Colors.black87),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.greyBackgroundColor,
        labelStyle: _bodySmall.copyWith(color: Colors.black87),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryGreenColor,
      ),
    );
  }

  // ============================================================
  // TEXT STYLES - Display, Headline, Title, Body, Label
  // ============================================================

  /// Display Styles - Used for the largest, most prominent text
  ///
  /// Display styles are intended for the largest text on the screen,
  /// typically used in headers or landing page headlines.
  /// This file defines three display sizes: large (57pt), medium (45pt), small (36pt).

  /// Display Large: 57px, bold weight for maximum prominence.
  static const TextStyle _displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle _displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle _displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  /// Headline Styles - Secondary prominent text
  ///
  /// Headline styles are used for secondary-level headings and prominent text.
  /// They bridge the gap between display styles (very large) and title styles (smaller).
  /// This file defines two headline sizes: medium (28pt), small (24pt).

  /// Headline Medium: 28px, bold weight for secondary headers.
  static const TextStyle _headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle _headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  /// Title Styles - Section headers and widget titles
  ///
  /// Title styles are used for section headers, widget titles, and other
  /// prominent-but-not-primary text. Used more frequently than display/headline styles
  /// throughout the interface. This file defines three title sizes:
  /// large (22pt), medium (16pt), small (14pt), all with semibold weight.

  /// Title Large: 22px, semibold weight for primary section titles.
  static const TextStyle _titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle _titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle _titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  /// Body Styles - Main content text
  ///
  /// Body styles are the most frequently used text styles for paragraph text,
  /// descriptions, and general content throughout the application.
  /// This file defines three body sizes:
  /// large (16px), medium (14px), small (12px), all with normal weight.
  /// Small body text uses a lighter color (black54) for secondary content.

  /// Body Large: 16px, normal weight for primary body text.
  static const TextStyle _bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle _bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle _bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );

  /// Label Styles - Button text and small interactive elements
  ///
  /// Label styles are used for button text, tags, chips, and other
  /// labels on interactive elements. They typically use semibold weight
  /// for better visibility in interactive contexts.
  /// This file defines three label sizes:
  /// large (14px), medium (12px), small (11px), with semibold weight.
  /// Small label text uses a lighter color (black54) for secondary labels.

  /// Label Large: 14px, semibold weight for primary button/label text.
  static const TextStyle _labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle _labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle _labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colors.black54,
  );
}
