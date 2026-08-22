import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color(
    0xFF4A7432,
  ); // Dark olive green for text/icons
  static const Color accentGreen = Color(
    0xFF8AC53E,
  ); // Vibrant green for buttons/banner
  static const Color backgroundColor = Color(0xFFF2EAE1); // Warm beige canvas

  // Shadow Colors (Neumorphic)
  static const Color shadowLight = Color(0xFFFFFFFF); // Pure white highlight
  static const Color shadowDark = Color(0xFFD3C5B5); // Warm brownish-beige shadow for depth
  static const Color shadowInsetDark = Color(0xFFC4B6A6); // For engraved look

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color textHint = Colors.black38;

  // Accents & Badges
  static const Color notificationBadge = Color(0xFFE53935);
  static const Color pricePink = Color(0xFFE95959);
  static const Color rosePink = Color(0xFFE84C6F);

  // Promo Banner Gradient
  static const Color promoGradientStart = Color(
    0xFF9CCC65,
  ); // Lighter vibrant green
  static const Color promoGradientEnd = Color(
    0xFF7CB342,
  ); // Deeper vibrant green

  // Default Padding & Margins
  static const EdgeInsets defaultScreenPadding = EdgeInsets.all(16.0);

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryGreen,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation:
        0, // Using neumorphic shadows on containers instead of native elevation usually
  );

  static final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryGreen,
    side: const BorderSide(color: primaryGreen, width: 2),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  // App Theme Data (For MaterialApp)
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Inter', // Assuming Inter or you can change this
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryGreen,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 14, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 12, color: textSecondary),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryGreen,
        surface: backgroundColor,
        secondary: accentGreen,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: backgroundColor,
        selectedIconTheme: const IconThemeData(color: Colors.white),
        unselectedIconTheme: const IconThemeData(color: textSecondary),
        selectedLabelTextStyle: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: const TextStyle(color: textSecondary),
        indicatorColor: primaryGreen,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: backgroundColor,
        indicatorColor: primaryGreen,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white);
          }
          return const IconThemeData(color: textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 12);
          }
          return const TextStyle(color: textSecondary, fontSize: 12);
        }),
      ),
    );
  }
}
