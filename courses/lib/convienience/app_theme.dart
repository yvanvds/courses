import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get() {
    return ThemeData.light().copyWith(
        colorScheme: colors,
        textTheme: text,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle:
              TextStyle(color: colorDarkest.withOpacity(0.2), fontSize: 30),
          floatingLabelStyle: TextStyle(color: colorLightest, fontSize: 28),
          fillColor: colorLightest.withOpacity(0.3),
          filled: true,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorLightest,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorLightest,
              width: 1.5,
            ),
          ),
          errorStyle: TextStyle(color: colorLightest),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorWarning,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorWarning,
              width: 1.5,
            ),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return colorDark;
            } else {
              return colorLight;
            }
          }),
        ));
  }

  static Color colorDarkest = const Color(0xFF43285D);
  static Color colorDark = const Color(0xFF8B1465);
  static Color colorAccent = const Color(0xFFEAEB21);
  static Color colorLight = const Color(0xFFCE168E);
  static Color colorLightest = Colors.white;
  static Color colorWarning = Colors.red;

  static ColorScheme colors = const ColorScheme.light().copyWith(
    primary: colorDark,
    primaryContainer: colorLight,
    secondary: colorAccent,
  );
  static TextTheme text = Typography().black.copyWith(
        bodyText1: GoogleFonts.lora(
          fontSize: 18,
          color: colorLightest,
          fontWeight: FontWeight.w300,
        ),
        bodyText2: GoogleFonts.lora(
          fontSize: 12,
          color: colorLightest,
          fontWeight: FontWeight.w300,
        ),
        headline1: GoogleFonts.ubuntu(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: colorLightest,
        ),
        headline2: GoogleFonts.ubuntu(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: colorLightest,
        ),
        headline3: GoogleFonts.ubuntu(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: colorLightest,
        ),
        subtitle1: GoogleFonts.ubuntu(
          fontSize: 24,
          fontWeight: FontWeight.w300,
          color: colorLightest,
        ),
        subtitle2: GoogleFonts.ubuntu(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: colorLightest,
        ),
      );
}
