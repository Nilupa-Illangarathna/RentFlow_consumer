import 'package:flutter/material.dart';
import '../../../../global/api_caller.dart';
import '../../../../global/global_settings.dart';
import '../../../../global/responsiveness.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../../../global/regex.dart';
import '../../../../utils/error_handling.dart';
import '../../../../widgets/common/elevated_button.dart';
import '../../../../widgets/common/image_viewer.dart';

class ForgotPasswordPage extends StatefulWidget {
  final Function(int) onNextStep;
  final Function(String, String, Function) onSaveMethodAndContact; // Updated callback to include the _sendOTP function
  final isModal;

  const ForgotPasswordPage({required this.onNextStep, required this.onSaveMethodAndContact, required this.isModal});


  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late bool isEmailSelected;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  String emailError = '';
  String mobileError = '';

  @override
  void initState() {
    super.initState();
    isEmailSelected =
        globalData.forgotPassEmail; // Set default based on global data
  }

  void _submitData() {
    setState(() {
      emailError = '';
      mobileError = '';

      // Validate email or mobile based on selection
      if (isEmailSelected) {
        if (emailController.text.isEmpty) {
          emailError = ErrorHandling.sentOtp['otpsend']['email'];
        } else if (!Regex.emailRegExp.hasMatch(emailController.text)) {
          emailError = ErrorHandling.sentOtp['otpsend']['email'];
        }
      } else {
        if (mobileController.text.isEmpty) {
          mobileError = ErrorHandling.sentOtp['otpsend']['mobile'];
        } else if (!Regex.mobileRegExp.hasMatch(mobileController.text)) {
          mobileError = ErrorHandling.sentOtp['otpsend']['mobile'];
        }
      }

      // Move to the next step if there are no errors
      if (isEmailSelected && emailError.isEmpty ||
          !isEmailSelected && mobileError.isEmpty) {
        _sendOTP();
      }
    });
  }

  void _sendOTP() async {
    String method = 'email';
    String contact = emailController.text.trim();

    // Save method and contact using callback function
    widget.onSaveMethodAndContact(method, contact, _sendOTP);

    // // Call the API to send OTP with additional parameters
    // final response = await apiCaller.callApi(
    //     sessionToken:"",
    //     route: 'send_otp',
    //     body: {
    //       'method': method,
    //       'contact': contact,
    //       'isNumericOTP': globalData.isNumaricOTP,
    //       'otpDigitCount': globalData.otpDigitCount,
    //       'otpCountdownTime': globalData.otpCountdownTime,
    //     }
    // );

    final url = '${globalData.baseUrl}/auth/reset_password';

    // Create a map containing the user's credentials
    Map<String, dynamic> body = {
      'email': contact
    };

    Map<String, dynamic>? response = await apiCaller.callApi(
      sessionToken: "",
      route: '/auth/reset_password',
      body: body,
    );

    if (response?['is_success'] == true) {
      // OTP sent successfully
      print('OTP sent successfully.');
      // Move to the next step (OTP input view)
      widget.onNextStep(2);
    } else {
      // Failed to send OTP
      print('Failed to send OTP. Please try again.');
      // Handle the failure scenario (show error message, retry option, etc.)
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image_viewer(
              imagePath: "assets/images/auth/auth_background.png", // Replace 'your_image.png' with your image path
              fit: BoxFit.cover, // You can change this to BoxFit.fitHeight or BoxFit.cover
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if(!widget.isModal) Padding(
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
                  child: Container(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Enter your email',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.w400,
                                // color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),

                        WillowVerticalGap(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Enter the email that you have registered with to the app',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  // color: Colors.indigo,
                                ),
                              ),
                            ),
                          ],
                        ),

                        WillowVerticalGap(height: 15,),
                        if (isEmailSelected)
                          Container(
                            height: emailError.isNotEmpty ? 78: 56,
                            child: Center(
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  errorText: emailError.isNotEmpty ? ErrorHandling.sentOtp['otpsend']['email'] : null
                                ),
                                // style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        if (!isEmailSelected)
                          Container(
                            height: 100,
                            child: Column(
                              children: [
                                TextField(
                                  controller: mobileController,
                                  decoration: InputDecoration(
                                    labelText: 'Mobile',
                                    errorText: mobileError.isNotEmpty ? mobileError : null,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        WillowVerticalGap(height: 15,),
                        WillowElevatedButton(
                          onPressed: _submitData,
                          buttonText: 'Send the OTP',
                        ),
                        WillowVerticalGap(height: 15,),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
