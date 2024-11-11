import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

import '../../global/api_caller.dart';
import '../../global/global_settings.dart';
import '../../utils/user_credentials.dart';
import '../../widgets/common/image_viewer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
    Timer(
      Duration(seconds: globalData.splashTime), // Adjust the duration of the splash screen as needed
          () => _checkSessionToken(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkSessionToken() async {
    String sessionToken = await userCredentials.getSessionToken() ?? '';

    if (sessionToken.isNotEmpty) {
      // Validate the session token
      bool isValidToken = await _validateSessionToken(sessionToken);

      print("Session token is : $sessionToken" );

      if (isValidToken) {
        // Navigate to home page if token is valid
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Navigate to login page if token is invalid
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } else {
      // Navigate to login page if no token found
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  Future<bool> _validateSessionToken(String sessionToken) async {
    final url = '${globalData.baseUrl}/retailer/get_history';

    try {
      Map<String, dynamic>? response = await apiCaller.callApi(
        sessionToken: sessionToken,
        route: '/retailer/get_history',
        body: {},
      );

      print("response is : ${response}");

      if (response?["is_success"] == true) {
        // Token is valid
        return true;
      } else {
        // Token is invalid or expired
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Container(
            //     height: MediaQuery.of(context).size.height,
            //     width: MediaQuery.of(context).size.width,
            //   child: CustomImage(
            //     imagePath: "assets/images/auth/auth_background.png", // Replace 'your_image.png' with your image path
            //     fit: BoxFit.fitHeight, // You can change this to BoxFit.fitHeight or BoxFit.cover
            //   ),
            // ),
            Center(
              child:
              Container(
                height: 60 * 1.1,
                width: 220 * 1.1,
                child: Image_viewer(
                  imagePath: "assets/images/auth/Logo.png", // Replace 'your_image.png' with your image path
                  fit: BoxFit.fitHeight, // You can change this to BoxFit.fitHeight or BoxFit.cover
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
