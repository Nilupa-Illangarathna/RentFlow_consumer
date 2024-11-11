import 'package:flutter/material.dart';
import '../../../../global/api_caller.dart';
import '../../../../global/global_settings.dart';
import '../../../../global/regex.dart';
import '../../../../global/responsiveness.dart';
import '../../../../security/encryption.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/error_handling.dart';
import '../../../../widgets/common/elevated_button.dart';
import '../../../../widgets/common/image_viewer.dart';

class ResetPasswordPage extends StatefulWidget {
  final Function(int) onNextStep;
  final String method;
  final String contact;
  final isModal;
  final String reset_token;

  const ResetPasswordPage({required this.onNextStep, required this.method, required this.contact, required this.isModal, required this.reset_token});


  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _passwordError = '';
  String _confirmPasswordError = '';

  void _resetPassword() {
    setState(() {
      // Reset errors
      _passwordError = '';
      _confirmPasswordError = '';

      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = ErrorHandling.resetPasswordErrors['password']['required'];
      } else if (!Regex.passwordRegExp.hasMatch(_passwordController.text)) {
        _passwordError = ErrorHandling.resetPasswordErrors['password']['invalid'];
      }

      // Validate confirm password
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = ErrorHandling.resetPasswordErrors['confirmPassword']['required'];
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match.';
      }

      // If no errors, proceed to reset password
      if (_passwordError.isEmpty && _confirmPasswordError.isEmpty) {
        // Add your logic here to reset the password
        print('Password reset successful!');
        print('New Password: ${_passwordController.text}'); // Print new password on CLI
        _callResetPasswordApi(_passwordController.text.trim());
        widget.onNextStep(4);
        // TODO: Call API to reset password
      }
    });
  }

  // TODO: API CALL Function to call the reset password API
  Future<void> _callResetPasswordApi(String newPassword) async {

    // final Map<String, dynamic> requestBody = {
    //   'method': widget.method,
    //   'contact': widget.contact,
    //   'password': newPassword,
    // };
    //
    // apiCaller.callApi(sessionToken:"", route: 'reset_password', body: requestBody).then((response) {
    //   if (response != null && response['success']) {
    //     print('Password reset successful!');
    //     widget.onNextStep(4); // Move to next step
    //   } else {
    //     print('Failed to reset password.');
    //     // Handle error or display appropriate message to the user
    //   }
    // });


    final url = '${globalData.baseUrl}/auth/update_password';

    // TODO: Hashing
    String password = newPassword; // Example password
    String hashedPassword = generateHash(password);
    print("Hashed password: $hashedPassword");

    // Create a map containing the user's credentials
    Map<String, dynamic> body = {
      "new_password": hashedPassword,
    };

    Map<String, dynamic>? response = await apiCaller.callApi(
      sessionToken: widget.reset_token,
      route: '/auth/update_password',
      body: body,
    );

    print("he he");

    if (response?['is_success'] == true) {
      // OTP sent successfully
      print('OTP sent successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?['message']),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      print('Password reset successful!');
      widget.onNextStep(4); // Move to next step
    } else {
      // Failed to send OTP
      print('Failed to reset password.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?['message']),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        ),
      );
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Reset your password',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w400,
                              // color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      WillowVerticalGap(height: 15,),
                      Material( // Wrap TextFormField with Material widget
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: Icon(Icons.vpn_key),
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            errorText: _passwordError.isNotEmpty ? _passwordError : null,
                          ),
                        ),
                      ),
                      WillowVerticalGap(height: 15,),
                      Material( // Wrap TextFormField with Material widget
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_confirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password',
                            prefixIcon: Icon(Icons.vpn_key),
                            suffixIcon: IconButton(
                              icon: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible = !_confirmPasswordVisible;
                                });
                              },
                            ),
                            errorText: _confirmPasswordError.isNotEmpty ? _confirmPasswordError : null,
                          ),
                        ),
                      ),
                      WillowVerticalGap(height: 15,),
                      WillowElevatedButton(
                        onPressed: _resetPassword,
                        buttonText: 'Reset Password',
                      ),
                      WillowVerticalGap(height: 15,),
                    ],
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
