import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds
  static const Color backgroundColor = Color(0xF5F5F5FF); // Pastel cream
  static const Color cardBackgroundColor = Color(0xFFFFFFFF); // Clean white for contrast
  static const Color searchBarBackground = Color(0xFFFFFFFF); // Pastel lavender — contrasts softly
  static const Color bottomNavBackground = Color(0xFF3F38A8); // Icy pastel blue

  // Primary & Secondary
  static const Color primaryAccentColor = Color(0xFF6C63FF); // Funky pastel purple
  static const Color secondaryAccentColor = Color(0xFFE08D30); // Peachy pastel orange

  // Text
  static const Color primaryTextColor = Color(0xFF2E2E2E); // Darker shade for contrast
  static const Color secondaryTextColor = Color(0xFF5E5E5E); // Slightly softer for subtext

  static const Color searchBarTextColor = Color(0xFF4B4453); // Deep purple-grey for main text
  static const Color searchBarHintColor = Color(0xFF6D5D7A); // Slightly faded for hints/placeholders

  // Navigation Icons
  static const Color activeNavIconColor = Color(0xFFFF6F91); // Playful coral-pink
  static const Color inactiveNavIconColor = Color(0xFFB2B2B2); // Muted gray to keep focus on active

  static const Color appTitleColor = primaryAccentColor;

  // Dark Theme Colors

  // Backgrounds
  static const Color backgroundColorDark = Color(0xFF121212); // True dark background
  static const Color cardBackgroundColorDark = Color(0xFF1E1E1E); // Slightly lighter for cards
  static const Color searchBarBackgroundDark = Color(0xFF1C1C2E); // Dark lavender tone
  static const Color bottomNavBackgroundDark = Color(0xFF2C2962); // Muted version of icy pastel blue

  // Primary & Secondary
  static const Color primaryAccentColorDark = Color(0xFF928CFF); // Softened pastel purple on dark
  static const Color secondaryAccentColorDark = Color(0xFFF0A14B); // Brighter peachy tone for contrast

  // Text
  static const Color primaryTextColorDark = Color(0xFFEAEAEA); // Bright near-white
  static const Color secondaryTextColorDark = Color(0xFFB0B0B0); // Softer gray for subtext

  static const Color searchBarTextColorDark = Color(0xFFD6CFE4); // Light purple-gray for dark mode
  static const Color searchBarHintColorDark = Color(0xFF998FA7); // Dimmed lavender hint text

  // Navigation Icons
  static const Color activeNavIconColorDark = Color(0xFFFF8FA9); // Slightly more vibrant coral-pink
  static const Color inactiveNavIconColorDark = Color(0xFF7A7A7A); // Soft gray for inactive icons

  static const Color appTitleColorDark = primaryAccentColorDark;
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF5F5F5), // backgroundColor
  // scaffoldBackgroundColor: Color(0xffe0e0e0),
  cardColor: Color(0xFFFFFFFF), // cardBackgroundColor
  dividerColor: Color(0xFFE0E0E0),
  appBarTheme: AppBarTheme(
    // backgroundColor: Color(0xFF3F38A8), // searchBarBackgroundDark
    backgroundColor: Color(0xFF5F3DC4), // searchBarBackgroundDark
    iconTheme: IconThemeData(color: Color(0xFFFF6B81)), // primaryTextColorDark
    // titleTextStyle: GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFFF6F91)),
    titleTextStyle: GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFFF6B81)),
    centerTitle: true,
    elevation: 2,
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 2,
    // height: 64.0,
    // backgroundColor: Color(0xFFFFFFFF),
    backgroundColor: Colors.transparent,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        // Selected label style
        return GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF6B81));
      }
      // Unselected label style
      return GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFB2B2B2));
    }),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        // Selected icon style
        return IconThemeData(color: const Color(0xFFFFFFFF));
      }
      // Unselected icon style
      return IconThemeData(color: const Color(0xFFB2B2B2));
    }),
    indicatorColor: Color(0xFFFF6B81),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF2E2E2E)), // primaryTextColor
    bodyMedium: TextStyle(color: Color(0xFF5E5E5E)), // secondaryTextColor
    titleLarge: TextStyle(color: Color(0xFF6C63FF)), // appTitleColor
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Color(0xFF6D5D7A)), // searchBarHintColor
  ),
  iconTheme: IconThemeData(color: Color(0xFFFF6B81)), // primaryAccentColor
  colorScheme: ColorScheme.light(
    // primary: Color(0xFF3F38A8), // primaryAccentColor
    primary: Color(0xFF5F3DC4), // primaryAccentColor
    secondary: Color(0xFFFF6B81),
    surface: Color(0xFFFFFFFF),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Color(0xFF2E2E2E),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF3F38A8).withValues(alpha: 0.2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    ),
  ),
  cardTheme: CardThemeData(
    color: Color(0xFF958DFF), // cardBackgroundColor
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212), // backgroundColorDark
  cardColor: Color(0xFF1E1E1E), // cardBackgroundColorDark
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1C1C2E), // searchBarBackgroundDark
    iconTheme: IconThemeData(color: Color(0xFF883C4E)), // primaryTextColorDark
    titleTextStyle: GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF883C4E)),
    centerTitle: true,
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 2,
    height: 64.0,
    backgroundColor: Color(0xFF121212),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        // Selected label style
        return GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF883C4E));
      }
      // Unselected label style
      return GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFB2B2B2));
    }),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        // Selected icon style
        return IconThemeData(color: const Color(0xFFFFFFFF));
      }
      // Unselected icon style
      return IconThemeData(color: const Color(0xFFB2B2B2));
    }),
    indicatorColor: Color(0xFF883C4E),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF9D9D9D)), // primaryTextColorDark
    bodyMedium: TextStyle(color: Color(0xFF707070)), // secondaryTextColorDark
    titleLarge: TextStyle(color: Color(0xFF1C1C2E)), // appTitleColorDark
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Color(0xFF998FA7)), // searchBarHintColorDark
  ),
  iconTheme: IconThemeData(color: Color(0xFF1C1C2E)), // primaryAccentColorDark
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF1C1C2E), // primaryAccentColorDark
    secondary: Color(0xFF883C4E),
    surface: Color(0xFF1E1E1E),
    onPrimary: Color(0xFFB0B0B0),
    onSecondary: Color(0xFFB0B0B0),
    onSurface: Color(0xFFB0B0B0),
  ),
  cardTheme: CardThemeData(
    color: Color(0xFF1E1E1E), // cardBackgroundColorDark
    elevation: 4,
  ),
);
