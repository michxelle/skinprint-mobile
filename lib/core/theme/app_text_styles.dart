import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Cormorant Garamond
  static TextStyle brand({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      color: color,
    );
  }

  static TextStyle displayLarge({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: 42,
      height: 1.05,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle displayMedium({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: 32,
      height: 1.1,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle productTitle({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: 30,
      height: 1.1,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle sectionTitle({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  // DM Sans
  static TextStyle bodyLarge({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.dmSans(
      fontSize: 16,
      height: 1.55,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle bodyMedium({
    Color color = AppColors.textSecondary,
  }) {
    return GoogleFonts.dmSans(
      fontSize: 14,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle label({
    Color color = AppColors.textSecondary,
  }) {
    return GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      color: color,
    );
  }

  static TextStyle button({
    Color color = AppColors.onPrimary,
  }) {
    return GoogleFonts.dmSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle appBarTitle({
    Color color = AppColors.onPrimary,
  }) {
    return GoogleFonts.dmSans(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle caption({
    Color color = AppColors.textSecondary,
  }) {
    return GoogleFonts.dmSans(
      fontSize: 12,
      height: 1.45,
      color: color,
    );
  }
}