import 'package:flutter/material.dart';

import '../utils/user_credentials.dart';

class GlobalData {
  //Base URL
  String baseUrl = 'http://34.198.66.25:3000/api';

  //salt
  String salt = '\$2a\$10\$willowuserpasswordsalt12';

  //Encrypt enable
  bool encryptEnable=true;

  //AppName
  String AppName = "GoalSettingApp";

  //User Credentials
  // Session Token
  String _sessionToken = "";

  //Splash
  int splashTime = 2; //should be 4
  //Forgot password
  bool forgotPass = true;
  bool forgotPassEmail = true; // Add email attribute
  bool forgotPassMobile = false; // Add mobile attribute

  //Global cli print enable
  bool print_enabled = true;

  //OTP related
  int otpDigitCount = 4; // Number of OTP digits
  int otpCountdownTime = 120; // Countdown time for OTP
  bool isNumaricOTP=true; // KeyBoard type for OTP


  //Homepage realated
  //App drawer
  bool enableDrawer = false;
  int homePageViewTransTime = 200; //Between two pages

  // Bottom nav bar
  int BottomNavBarHeight = 60;

  // Constructor
  GlobalData() {
    _loadSessionToken(); // Load session token on object creation
  }

  // Load session token from SharedPreferences
  Future<void> _loadSessionToken() async {
    _sessionToken = await userCredentials.getSessionToken() ?? '';
  }

  // Getter for session token
  String get sessionToken => _sessionToken;

  // Methods
  Future<void> updateData() async {
    await _loadSessionToken();
  }

  void printData() {
    print('GlobalData:');
    print('  AppName: $AppName');
    print('  SessionToken: $_sessionToken');
    print('  SplashTime: $splashTime');
    print('  ForgotPass: $forgotPass');
    print('  ForgotPassEmail: $forgotPassEmail');
    print('  ForgotPassMobile: $forgotPassMobile');
    print('  PrintEnabled: $print_enabled');
    print('  BaseUrlRoute: $baseUrl');
    print('  OTPDigitCount: $otpDigitCount');
    print('  OTPCountdownTime: $otpCountdownTime');
    print('  IsNumericOTP: $isNumaricOTP');
  }
}

GlobalData globalData = GlobalData();

