import 'package:flutter/material.dart';

class GraftiTheme {
  // Brand Color Palette - Dark Blue & White
  static const Color primaryPink = Color(0xFF0F2C59);      // Deep Dark Blue (Primary Accent)
  static const Color secondaryPastelPink = Color(0xFFEEF4F8); // Very light cool gray (Highlight background)
  static const Color steelBlue = Color(0xFF1D5D9B);        // Steel Blue (Interactive buttons/secondary highlights)
  static const Color softLilac = Color(0xFFE2E8F0);        // Light slate (Borders/dividers)
  static const Color darkPlum = Color(0xFF0F2C59);         // Deep Dark Blue (Primary headings)
  static const Color plumDarkText = Color(0xFF0F2C59);     // Deep Dark Blue (Body text for cohesive palette branding)
  static const Color mutedText = Color(0xFF5A6B82);        // Muted Slate Blue (Secondary text)
  static const Color surfaceBackground = Color(0xFFFFFFFF); // Pure White Scaffold Background
  static const Color cardFill = Color(0xFFFFFFFF);         // Pure White card containers
  static const Color successGreen = Color(0xFF38A169);     // Emerald Green (Checkout actions & payments success)

  // Card Box Shadow
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF0F2C59).withOpacity(0.04), // Very subtle navy shadow
      spreadRadius: 0,
      blurRadius: 16,
      offset: const Offset(0, 4),
    )
  ];

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: surfaceBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        primary: primaryPink,
        secondary: steelBlue,
        background: surfaceBackground,
        surface: cardFill,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.bold,
          color: darkPlum,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: darkPlum,
        ),
        bodyLarge: TextStyle(
          color: plumDarkText,
        ),
        bodyMedium: TextStyle(
          color: mutedText,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardFill,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: const BorderSide(color: softLilac, width: 1.0), // Thin border
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
