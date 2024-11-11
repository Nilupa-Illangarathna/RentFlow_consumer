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

class ForgotPasswordOTPPage extends StatefulWidget {
  final Function(int) onNextStep;
  final String method; // 'email' or 'mobile'
  final String contact; // Email address or mobile number
  final Function sendOTP; // Function to send OTP
  final isModal;
  final Function(String) onRecieveResetToken; // Updated callback to include the _sendOTP function


  const ForgotPasswordOTPPage({required this.onNextStep, required this.method, required this.contact, required this.sendOTP, required this.onRecieveResetToken,  required this.isModal});

  @override
  _ForgotPasswordOTPPageState createState() => _ForgotPasswordOTPPageState();
}

class _ForgotPasswordOTPPageState extends State<ForgotPasswordOTPPage> {
  late String enteredOTP;
  String errorMessage = '';

  Future<void> verifyOTP() async {


    setState(() {
      errorMessage="";
    });

    final url = '${globalData.baseUrl}/auth/reset_password_otp';

    Map<String, dynamic> body = {
      "email": widget.contact,
      "otp": enteredOTP
    };

    print("widget.contact is ${widget.contact}");
    print("enteredOTP is ${enteredOTP}");

    Map<String, dynamic>? response = await apiCaller.callApi(
      sessionToken: "",
      route: '/auth/reset_password_otp',
      body: body,
    );

    if (response?['is_success'] == true) {
      print('OTP sent successfully.');
      widget.onRecieveResetToken(response?['password_reset_token']);
      widget.onNextStep(3);
    } else {
      setState(() {
        errorMessage = 'OTP verification failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                          Text(
                            'We have sent an email with the OTP to your email account',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
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
                            widget.sendOTP();
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
    );
  }
}
