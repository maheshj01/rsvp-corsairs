import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsvp/utils/settings.dart';

class CorsairsTheme {
  static final CorsairsTheme _singleton = CorsairsTheme._internal();
  CorsairsTheme._internal();
  static const Color primaryBlue = Color(0xff013764);
  static const Color primaryYellow = Color(0xffFEC14E);

  static Color primaryGrey = Colors.grey;
  static Color primaryColor = primaryBlue;
  static Color? background = const Color(0XFFF8F8F8);
  static Color secondaryColor = primaryColor.withOpacity(0.6);

  //  kids colors
  static Color primaryGreen = const Color(0xff00A86B);
  static Color primaryRed = const Color(0xffE60000);
  static Color primaryPurple = const Color(0xff7F00FF);
  static Color primaryOrange = const Color(0xffFF6600);
  static Color primaryPink = const Color(0xffFF00CC);
  static Color primaryTeal = const Color(0xff00CCCC);
  static Color primaryBrown = const Color(0xff663300);
  static Color primaryBlack = const Color(0xff000000);
  static Color primaryWhite = const Color(0xffFFFFFF);

  /// notification states color
  static Color approvedColor = const Color(0xffD6F1E4);
  static Color rejectedColor = const Color(0xffFFD2C8);
  static Color pendingColor = const Color(0xffE2EBF9);
  static Color cancelColor = const Color(0xffF2F2F2);

  static Color color1 = const Color(0xff1D976C);
  static Color color2 = const Color(0xff93F9B9);
  static LinearGradient primaryGradient = LinearGradient(
      colors: [color1.withOpacity(0.1), color2.withOpacity(0.2)]);
  static LinearGradient secondaryGradient = LinearGradient(
      colors: [primaryBlue.withOpacity(0.1), primaryColor.withOpacity(0.2)]);
  static TextStyle listSubtitleStyle = const TextStyle(fontSize: 12);

  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;
  static const Color navigationBarColor = Color(0xffF2F4F7);
  bool _isDark = false;

  static bool get isDark => _singleton._isDark;

  static set isDark(bool value) {
    _singleton._isDark = value;
  }

  static ColorScheme get colorScheme =>
      Settings.getTheme == ThemeMode.light ? lightColorScheme : darkColorScheme;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      _themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = _themeData(darkColorScheme, _darkFocusColor);

  static BoxShadow primaryShadow = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 10,
    offset: const Offset(0, 5),
  );

  static BoxShadow secondaryShadow = BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 10,
    offset: const Offset(0, 5),
  );
  static BoxShadow notificationCardShadow = BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4.0,
      spreadRadius: 0,
      offset: const Offset(0, 4));

  static ThemeData _themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      textTheme: googleFontsTextTheme,
      // Matches manifest.json colors and background color.
      primaryColor: const Color(0xFF030303),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        titleTextStyle: googleFontsTextTheme.headlineMedium,
        elevation: 2.2,
        iconTheme: const IconThemeData(color: primaryYellow),
      ),
      iconTheme: const IconThemeData(color: primaryYellow),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      bottomAppBarColor: colorScheme.primary,
      focusColor: focusColor,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle:
            googleFontsTextTheme.titleMedium!.apply(color: _darkFillColor),
      ),
    );
  }

  static ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: const Color.fromRGBO(76, 150, 72, 1.0),
    primaryContainer: const Color(0xFF117378),
    secondary: const Color(0xFFEFF3F3),
    secondaryContainer: const Color(0xFFFAFBFB),
    background: background!,
    surface: const Color(0XFFFFFFFF),
    onBackground: Colors.black,
    error: Colors.red,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: const Color(0xFF322942),
    onSurface: const Color.fromRGBO(76, 150, 72, 1.0),
  );

  static ColorScheme darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF8383),
    primaryContainer: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryContainer: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: Colors.red,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
  );

  static TextTheme googleFontsTextTheme =
      GoogleFonts.quicksandTextTheme(TextTheme(
    displayLarge: GoogleFonts.quicksand(
        fontSize: 72.0,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500),
    displayMedium: GoogleFonts.quicksand(
        fontSize: 48.0,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500),
    displaySmall: GoogleFonts.quicksand(
        fontSize: 36.0,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500),
    headlineMedium: GoogleFonts.quicksand(
        fontSize: 22,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w400),
    headlineSmall: GoogleFonts.quicksand(
        fontSize: 16.0, color: isDark ? Colors.white : Colors.black),
    titleLarge: GoogleFonts.quicksand(
        fontSize: 12.0,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w300),
    bodySmall: GoogleFonts.quicksand(color: Colors.grey, fontSize: 12),
    titleMedium: GoogleFonts.quicksand(
        fontSize: 20,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w300),
    titleSmall: GoogleFonts.quicksand(
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w300),
  ));
}
