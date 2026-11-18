import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFB9788D);
  static const Color primarySoft = Color(0xFFF1DCE2);
  static const Color background = Color(0xFFFFF8F5);
  static const Color surface = Color(0xFFFFFEFC);
  static const Color success = Color(0xFFB9D8CD);
  static const Color lavender = Color(0xFFE8DFF2);
  static const Color text = Color(0xFF49343D);
  static const Color muted = Color(0xFF88747A);
  static const Color accent = Color(0xFFB99A76);
  static const Color wine = Color(0xFF72515E);
}

class AppTheme {
  static ThemeData light({
    double textScaleFactor = 1.0,
    bool isHighContrast = false,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: isHighContrast
          ? Colors.white
          : AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.surface,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: AppColors.surface,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.wine.withValues(alpha: 0.09),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.primarySoft, width: 0.8),
        ),
      ),
    );

    final textColor = isHighContrast ? Colors.black : AppColors.text;

    final textTheme = GoogleFonts.nunitoSansTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 34 * textScaleFactor,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 29 * textScaleFactor,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleLarge: GoogleFonts.nunitoSans(
        fontSize: 23 * textScaleFactor,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      titleMedium: GoogleFonts.nunitoSans(
        fontSize: 18 * textScaleFactor,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        fontSize: 16 * textScaleFactor,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 14 * textScaleFactor,
        color: isHighContrast ? Colors.black : AppColors.muted,
      ),
      labelLarge: GoogleFonts.nunitoSans(
        fontSize: 15 * textScaleFactor,
        fontWeight: FontWeight.w800,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isHighContrast ? Colors.white : AppColors.background,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24 * textScaleFactor,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.wine,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          elevation: 3,
          shadowColor: AppColors.wine.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w800,
            fontSize: 16 * textScaleFactor,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w800,
            fontSize: 15 * textScaleFactor,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isHighContrast ? Colors.white : AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primarySoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primarySoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      dividerColor: AppColors.primarySoft,
      iconTheme: IconThemeData(
        color: isHighContrast ? Colors.black : AppColors.wine,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.wine,
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primarySoft,
        elevation: 5,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w700,
            fontSize: 12 * textScaleFactor,
          ),
        ),
      ),
    );
  }
}
