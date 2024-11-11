import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../global/api_caller.dart';
import '../../../../global/global_settings.dart';
import '../../../../global/responsiveness.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/auth/otp_input_with_countdown.dart';
import '../../../../widgets/common/elevated_button.dart';
import '../../../../widgets/common/image_viewer.dart';
import '../../../utils/user_credentials.dart';

class EmailOTPCheck extends StatefulWidget {
  final String method; // 'email'
  final String contact; // Email address
  final isModal;
  final String to; // Email address

  const EmailOTPCheck({required this.method, required this.contact,  required this.isModal, required this.to});


  @override
  _EmailOTPCheckState createState() => _EmailOTPCheckState();
}

class _EmailOTPCheckState extends State<EmailOTPCheck> {
  late String enteredOTP;
  String errorMessage = '';


  Future<void> sentOtp() async {
    setState(() {
      errorMessage="";
    });

    final url = '${globalData.baseUrl}/auth/resend_otp';

    Map<String, dynamic> body = {
      "email": widget.contact,
    };


    Map<String, dynamic>? response = await apiCaller.callApi(
      sessionToken: "",
      route: '/auth/resend_otp',
      body: body,
    );

    if (response?['is_success'] != true) {
      setState(() {
        errorMessage = 'OTP resent failed. Please try again.';
      });
    }
  }


  Future<void> verifyOTP() async {
    setState(() {
      errorMessage="";
    });

    final url = '${globalData.baseUrl}/auth/verify_otp';

    Map<String, dynamic> body = {
      "email": widget.contact,
      "otp": enteredOTP
    };

    Map<String, dynamic>? response = await apiCaller.callApi(
      sessionToken: "",
      route: '/auth/verify_otp',
      body: body,
    );

    if (response?['is_success'] == true && response?['role'] == 1) {

      // Save session token in SharedPreferences
      await userCredentials.saveSessionToken(response?['session_token']);

      // Update GlobalData with the latest credentials
      await globalData.updateData();

      // Print updated credentials
      globalData.printData();

      // Navigate to home page
      widget.to=="login"?
      Navigator.pushReplacementNamed(context, '/auth'):
      Navigator.pushReplacementNamed(context, '/home');

    } else {
      setState(() {
        errorMessage = response?['error'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(0.0),
        child:       Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image_viewer(
                imagePath: "assets/images/auth/auth_background.png",
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        if (!widget.isModal)
                          Padding(
                            padding: EdgeInsets.all(29.0),
                            child: IconButton(
                              icon: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                      ],
                    ),
                    WillowPadding(
                      padding: 24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Enter the OTP',
                                style: TextStyle(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          WillowVerticalGap(height: 15,),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'We have sent an email with the OTP to your email account',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          WillowVerticalGap(height: 15,),
                          Container(
                            height: 105,
                            width: 254,
                            child: OtpInputWithCountdown(
                              onTimerFinished: () {
                                // Handle timer finished event
                                setState(() {
                                  errorMessage="";
                                });
                              },
                              onResendPressed: (otp) {
                                errorMessage="";
                                sentOtp();
                              },
                              onOTPChanged: (otp) {
                                enteredOTP = otp;
                              },
                            ),
                          ),
                          if (errorMessage.isNotEmpty) ...[
                            Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.0,
                              ),
                            ),
                            WillowVerticalGap(height: 15,),
                          ],
                          WillowElevatedButton(
                            onPressed: verifyOTP,
                            buttonText: 'Submit',
                          ),
                          WillowVerticalGap(height: 15,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )


    ;
  }
}
