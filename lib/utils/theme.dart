import 'package:flutter/material.dart';
import '../global/responsiveness.dart';
import '../transitions/page_transition_rgt_to_lft.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: Color(0xFF1A6B51),
    scaffoldBackgroundColor: Colors.white,

    appBarTheme: AppBarTheme(
      color: Color(0xFF1A6B51),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1A6B51)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
    inputDecorationTheme: inputDecorationTheme,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF1A6B51)),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Set padding to zero
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionsBuilder(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 600),
        ),
        TargetPlatform.iOS: CustomPageTransitionsBuilder(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 600),
        ),
      },
    ),
    textTheme: TextTheme( // Define text theme for the entire app
      bodyText1: TextStyle( // Default text style
        fontFamily: 'Roboto', // Set the font family to Roboto
        fontWeight: FontWeight.w400, // Set the font weight to 400
        color: Colors.black, // Set the default text color to black
      ),
    ),
  );

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
    filled: true,
    fillColor: Colors.white,
  );

  static final TextStyle forgotPasswordTextStyle = TextStyle(
    fontSize: 16.0,
    color: Color(0xFF1A6B51),
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  static final TextStyle headerTextStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A6B51),
  );

  static final TextStyle buttonTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final double inkWellHorizontalPadding = 80.0;
  static final double inkWellHorizontalPaddingBothOptions = 60.0;

  static double calculateInkWellHorizontalPadding(bool hasBothOptions) {
    return hasBothOptions ? inkWellHorizontalPaddingBothOptions : inkWellHorizontalPadding;
  }

  static final BorderRadius inkWellBorderRadius = BorderRadius.circular(10.0);

  static final double otpInputHeight = 56.0 ;
  static final double otpInputWidthFactor = 0.25;
  static final double otpInputBorderRadius = 4.0;
  static final double otpInputSpacing = 16.0;
  static final double otpCountdownHeight = 22.0;
  static final double otpCountdownFontSize = 14.0;
  static final FontWeight otpCountdownFontWeight = FontWeight.w400;

  static final double forgotPasswordPageHeaderFontSize = 20.0;
  static final FontWeight forgotPasswordPageHeaderFontWeight = FontWeight.bold;
  static final Color forgotPasswordPageHeaderColor = Colors.black87;

  static final double forgotPasswordPageSubheaderFontSize = 16.0;
  static final Color forgotPasswordPageSubheaderColor = Colors.black87;
}
