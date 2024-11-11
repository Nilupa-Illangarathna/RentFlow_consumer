// Import statements
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import '../../../global/api_caller.dart';
import '../../../global/global_settings.dart';
import '../../../global/regex.dart';
import '../../../global/responsiveness.dart';
import '../../../utils/error_handling.dart';
import '../../../utils/theme.dart';
import '../../../utils/user_credentials.dart';
import '../../../widgets/common/elevated_button.dart';
import '../../../widgets/common/image_viewer.dart';
import '../login/email_otp_check.dart';


// SignUpPage class
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

// _SignUpPageState class
class _SignUpPageState extends State<SignUpPage> {
  bool _passwordVisible = false;

  // Text editing controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  // Error messages
  Map<String, String> errorMessages = {};

// Function to handle signup
  Future<void> handleSignup() async {
    // Extract data from text controllers
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String contactNumber = contactNumberController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = passwordConfirmController.text.trim();


    // Validate input fields
    if (!_validateInputFields()) {
      return;
    }

    // TODO: API call to signup
    try {


      Map<String, dynamic>? response = await apiCaller.callApi(
        sessionToken: "",
        route: '/auth/register',
        body: {
          'name': name,
          'email': email,
          'contact_no': contactNumber,
          'password': password,
        },
      );

      // Check response status code
      if (!response?['is_success']) {
        // print('Signup successful. User data: $response');
        //
        // // Save credentials on local storage
        // // Save session token in SharedPreferences
        // await userCredentials.saveSessionToken("response?['session_token']");
        //
        // await globalData.updateData(); // Await the updateData call
        //
        // // Print updated data
        // globalData.printData();
        //
        // // Navigate to home page
        // Navigator.pushReplacementNamed(context, '/auth');


        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmailOTPCheck(
            isModal: false,
            method: "email",
            contact: email,
            to:"login"
          )),
        );


      } else {
        setState(() {
          // Show error message
          errorMessages['general'] = 'Signup failed. Please try again.';
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        // Show error message
        errorMessages['general'] = 'An error occurred. Please try again later.';
      });
    }
  }


// Function to validate input fields
  bool _validateInputFields() {
    bool isValid = true;
    errorMessages.clear();

    // Name validation
    if (nameController.text.isEmpty) {
      errorMessages['name'] = ErrorHandling.signupErrors['name']['required']!;
      isValid = false;
    }

    // Email validation
    if (emailController.text.isEmpty) {
      errorMessages['email'] = ErrorHandling.signupErrors['email']['required']!;
      isValid = false;
    } else if (!Regex.emailRegExp.hasMatch(emailController.text)) {
      errorMessages['email'] = ErrorHandling.signupErrors['email']['invalid']!;
      isValid = false;
    }

    // Contact validation
    if (contactNumberController.text.isEmpty) {
      errorMessages['mobile'] = ErrorHandling.signupErrors['mobile']['required']!;
      isValid = false;
    } else if (!Regex.mobileRegExp.hasMatch(contactNumberController.text)) {
      errorMessages['mobile'] = ErrorHandling.signupErrors['mobile']['invalid']!;
      isValid = false;
    }

    // Password validation
    if (passwordController.text.isEmpty) {
      errorMessages['password'] = ErrorHandling.signupErrors['password']['required']!;
      isValid = false;
    } else if (!Regex.passwordRegExp.hasMatch(passwordController.text)) {
      errorMessages['password'] = ErrorHandling.signupErrors['password']['invalid']!;
      isValid = false;
    }

    // Confirm Password validation (only if password is valid)
    if (Regex.passwordRegExp.hasMatch(passwordController.text) && passwordConfirmController.text.isEmpty) {
      errorMessages['confirmPassword'] = ErrorHandling.signupErrors['confirmPassword']['required']!;
      isValid = false;
    } else if (Regex.passwordRegExp.hasMatch(passwordController.text) && passwordController.text != passwordConfirmController.text) {
      errorMessages['confirmPassword'] = 'Passwords do not match.';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height, // Set the minimum height here
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [


                  WillowPadding(
                    padding:24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height:
                            errorMessages['name'] != null ||
                            errorMessages['email'] != null ||
                            errorMessages['mobile'] != null ||
                            errorMessages['password'] != null ?  30 : 67.5),
                        Center(
                          child: Container(
                            width: 220,
                            // padding: EdgeInsets.only(top: 85 * HR, right: 70 * WR, left: 70 *WR, bottom: 85 * HR),
                            child: Image_viewer(
                              imagePath: "assets/images/auth/Logo.png", // Replace 'your_image.png' with your image path
                              fit: BoxFit.fitWidth, // You can change this to BoxFit.fitHeight or BoxFit.cover
                            ),
                          ),
                        ),
                        SizedBox(height: 34.5),
                        Row(
                          children: [
                            Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.w400,
                                // color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                        WillowVerticalGap(height: 15,),
                        // Name
                        Container(
                          height: errorMessages['name'] != null? 78 : 56,
                          child: TextFormField(
                            controller: nameController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person), // Custom key icon
                              errorText: errorMessages['name'],
                            ),
                          ),
                        ),
                        if(errorMessages['name'] != null) WillowVerticalGap(
                          height: 10,
                        )else WillowVerticalGap(
                          height: 16,
                        ),
                        Container(
                          height: errorMessages['email']!= null && emailController.text.isNotEmpty
                              ? 96 : errorMessages['email'] != null
                              ? 78
                              : 56,
                          child: TextFormField(
                            controller: emailController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email), // Custom key icon
                              errorText: errorMessages['email'],
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        if(errorMessages['email'] != null) WillowVerticalGap(
                          height: 10,
                        )else WillowVerticalGap(
                          height: 16,
                        ),
                        Container(
                          height: errorMessages['mobile']!= null && emailController.text.isNotEmpty
                              ? 96 : errorMessages['mobile'] != null
                              ? 78
                              : 56,
                          child: TextFormField(
                            controller: contactNumberController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Contact Number',
                              prefixIcon: Icon(Icons.phone_outlined), // Custom key icon
                              errorText: errorMessages['mobile'],
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        if(errorMessages['mobile'] != null) WillowVerticalGap(
                          height: 10,
                        )else WillowVerticalGap(
                          height: 16,
                        ),
                        Container(
                          height: errorMessages['password'] != null && passwordController.text!=""? 96 : errorMessages['password'] != null? 78 : 54,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: !_passwordVisible,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.vpn_key), // Custom key icon
                              errorText: errorMessages['password'],
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        if(errorMessages['password'] != null) WillowVerticalGap(
                          height: 10,
                        )else WillowVerticalGap(
                          height: 16,
                        ),
                        Container(
                          height: errorMessages['confirmPassword'] != null? 78 : 56,
                          child: TextFormField(
                            controller: passwordConfirmController,
                            obscureText: !_passwordVisible,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.vpn_key), // Custom key icon
                              errorText: errorMessages['confirmPassword'],
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        if(errorMessages['confirmPassword'] != null) WillowVerticalGap(
                          height: 10,
                        )else WillowVerticalGap(
                          height: 16,
                        ),

                        // Error messages
                        if (errorMessages.containsKey('general'))
                          Container(
                            constraints: BoxConstraints(
                                minHeight: 20.0), // Adjust the minHeight as needed
                            child: Text(
                              errorMessages['general']!,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        if (errorMessages.containsKey('general'))
                          WillowVerticalGap(
                            height: 16,
                          ),

                        WillowElevatedButton(
                          onPressed: handleSignup,
                          buttonText: 'Send the OTP',
                        ),
                        // WillowVerticalGap(),
                        // Already have an account

                        WillowVerticalGap(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: Theme.of(context).textTheme.button!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Login',
                                style: Theme.of(context).textTheme.button!.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
