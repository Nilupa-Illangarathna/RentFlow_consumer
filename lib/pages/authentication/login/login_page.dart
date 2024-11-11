// Import statements
import 'package:flutter/material.dart';
import '../../../global/api_caller.dart';
import '../../../global/global_settings.dart';
import '../../../global/regex.dart';
import '../../../global/responsiveness.dart';
import '../../../security/encryption.dart';
import '../../../utils/error_handling.dart';
import '../../../utils/user_credentials.dart';
import '../../../widgets/common/elevated_button.dart';
import '../../../widgets/common/image_viewer.dart';
import '../forgot_password/forgot_password_page.dart';
import 'email_otp_check.dart';

// LoginPage class
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

// _LoginPageState class
class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  String _passwordError = '';

  Map<String, String> errorMessages = {}; // Error messages
  String loginError = "";

  // Function to handle auth
  Future<void> handleLogin() async {
    setState(() {
      loginError = "";
    });


    // TODO: Hashing
    String password = passwordController.text.trim(); // Example password
    String hashedPassword = generateHash(password);
    print("Hashed password: $hashedPassword");


    String email = emailController.text.trim();
    print(email + " " + hashedPassword);

    // Validate input fields
    if (!_validateInputFields(password, email)) {
      return;
    }

    // Create a map containing the user's credentials
    Map<String, dynamic> body = {
      'email': email,
      'password': hashedPassword,
    };

    try {
      // Make the API call using the ApiCaller object
      Map<String, dynamic>? response = await apiCaller.callApi(
          sessionToken:"", route: '/auth/login', body: body
      );

      print("response is : ${response}");


      if (response?['is_success'] && response?['role']==0) {
        // Login successful
        print('Login successful. Retailer User data: ${response?['message']}');

        // Save session token in SharedPreferences
        await userCredentials.saveSessionToken(response?['session_token']);

        // Update GlobalData with the latest credentials
        await globalData.updateData();

        // Print updated credentials
        globalData.printData();

        // Navigate to home page
        Navigator.pushReplacementNamed(context, '/home');
      } else if(response?['is_success'] && response?['role']!=0){
        setState(() {
          loginError = "Invalid User Role";
        });
      }
      else {
        if (response?['error']=="Please Verify Your email."){

          Map<String, dynamic> body = {
            'email': email,
          };

          Map<String, dynamic>? response = await apiCaller.callApi(
              sessionToken:"", route: '/auth/resend_otp', body: body
          );

          if (response?['is_success']) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmailOTPCheck(
                isModal: false,
                method: "email",
                contact: email,
                to: 'home',
              )),
            );
          }



        }

        // Login failed
        print('Login Unsuccessful. User data: ${response?['user']}');
        setState(() {
          loginError =
          response?['error'];
        });
      }
    } catch (e) {
      // Handle errors
      print('Error occurred: $e');
      setState(() {
        errorMessages['general'] =
        ErrorHandling.loginErrors['general']['serverError']!;
      });
    }
  }


  // Function to validate input fields
  bool _validateInputFields(String password, String email) {
    bool isValid = true;
    errorMessages.clear();

    // Email validation
    if (email.isEmpty) {
      errorMessages['email'] = ErrorHandling.signupErrors['email']['required']!;
      isValid = false;
    } else if (!Regex.emailRegExp.hasMatch(email)) {
      errorMessages['email'] = ErrorHandling.signupErrors['email']['invalid']!;
      isValid = false;
    }

    // // Password validation
    // if (passwordController.text.isEmpty) {
    //   errorMessages['password'] =
    //       ErrorHandling.signupErrors['password']['required']!;
    //   isValid = false;
    // }

    setState(() {});
    return isValid;
  }

  // Function to handle "Forgot Password" button tap
  void handleForgotPassword() {
    if (globalData.forgotPass) {
      // Show the Forgot Password model bottom sheet
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordPageCaller(isModal: false),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent going back
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image_viewer(
                  imagePath:
                  "assets/images/auth/auth_background.png", // Replace 'your_image.png' with your image path
                  fit: BoxFit
                      .cover, // You can change this to BoxFit.fitHeight or BoxFit.cover
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        // top: 85,
                          right: 70,
                          left: 70,
                          bottom: 85
                      ),
                      child: Image_viewer(
                        imagePath:
                        "assets/images/auth/Logo.png", // Replace 'your_image.png' with your image path
                        fit: BoxFit
                            .fitWidth, // You can change this to BoxFit.fitHeight or BoxFit.cover
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24), // padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // WillowVerticalGap(
                          //   height: 15,
                          // ),
                          SizedBox(height: 15),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w400,
                              // color: Colors.indigo,
                            ),
                          ),
                          // WillowVerticalGap(
                          //   height: 15,
                          // ),
                          SizedBox(height: 15),
                          Container(
                            height: errorMessages['email'] != null
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
                            height: errorMessages['password'] != null &&
                                passwordController.text.isNotEmpty
                                ? 74
                                : (errorMessages['password'] != null
                                ? 78
                                : 56),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: !_passwordVisible,
                              autofocus: false,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon:
                                Icon(Icons.vpn_key), // Custom key icon
                                errorText: errorMessages['password'],
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                          if (loginError != "")
                            SizedBox(height: 8),
                          if (loginError != "")
                            Text(loginError,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.withOpacity(0.7),
                                )),

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: handleForgotPassword,
                                  child: Text(
                                    'Forgot your Password?',
                                    // style: AppTheme.forgotPasswordTextStyle, // Apply custom text style
                                  ),
                                ),
                              ],
                            ),
                          ),

                          WillowElevatedButton(
                            onPressed: handleLogin,
                            buttonText: 'Login',
                          ),
                          WillowVerticalGap(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Don’t have an account? ',
                                style: Theme.of(context).textTheme.button!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                child: Text(
                                  'Register',
                                  style: Theme.of(context).textTheme.button!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // WillowPadding(
                    //   padding: 24,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // WillowVerticalGap(
                    //       //   height: 15,
                    //       // ),
                    //       SizedBox(height: 15),
                    //       Text(
                    //         'Login',
                    //         style: TextStyle(
                    //           fontSize: 32.0 * HR,
                    //           fontWeight: FontWeight.w400,
                    //           // color: Colors.indigo,
                    //         ),
                    //       ),
                    //       // WillowVerticalGap(
                    //       //   height: 15,
                    //       // ),
                    //       SizedBox(height: 15),
                    //       Container(
                    //         height: errorMessages['email'] != null
                    //             ? 78 * HR
                    //             : 56 * HR,
                    //         child: TextFormField(
                    //           controller: emailController,
                    //           autofocus: false,
                    //           decoration: InputDecoration(
                    //             labelText: 'Email',
                    //             prefixIcon: Icon(Icons.email), // Custom key icon
                    //             errorText: errorMessages['email'],
                    //           ),
                    //           keyboardType: TextInputType.emailAddress,
                    //         ),
                    //       ),
                    //       if(errorMessages['email'] == null)
                    //       //   WillowVerticalGap(
                    //       //   height: 15,
                    //       // ),
                    //         SizedBox(height: 15),
                    //       Container(
                    //         height: errorMessages['password'] != null &&
                    //                 passwordController.text.isNotEmpty
                    //             ? 74 * HR
                    //             : (errorMessages['password'] != null
                    //                 ? 68 * HR
                    //                 : 48 * HR),
                    //         child: TextFormField(
                    //           controller: passwordController,
                    //           obscureText: !_passwordVisible,
                    //           autofocus: false,
                    //           decoration: InputDecoration(
                    //             labelText: 'Password',
                    //             prefixIcon:
                    //                 Icon(Icons.vpn_key), // Custom key icon
                    //             errorText: errorMessages['password'],
                    //             suffixIcon: IconButton(
                    //               icon: Icon(_passwordVisible
                    //                   ? Icons.visibility
                    //                   : Icons.visibility_off),
                    //               onPressed: () {
                    //                 setState(() {
                    //                   _passwordVisible = !_passwordVisible;
                    //                 });
                    //               },
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //
                    //       if (loginError != "")
                    //         SizedBox(height: 8),
                    //       if (loginError != "")
                    //         Text(loginError,
                    //             style: TextStyle(
                    //               fontSize: 12,
                    //               color: Colors.red.withOpacity(0.7),
                    //             )),
                    //
                    //       Container(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: [
                    //             TextButton(
                    //               onPressed: handleForgotPassword,
                    //               child: Text(
                    //                 'Forgot your Password?',
                    //                 // style: AppTheme.forgotPasswordTextStyle, // Apply custom text style
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //
                    //       WillowElevatedButton(
                    //         onPressed: handleLogin,
                    //         buttonText: 'Login',
                    //       ),
                    //       // WillowVerticalGap(height: 15,),
                    //       // Row(
                    //       //   mainAxisAlignment: MainAxisAlignment.end,
                    //       //   children: [
                    //       //     Text(
                    //       //       'Don’t have an account? ',
                    //       //       style: Theme.of(context).textTheme.button!.copyWith(
                    //       //         color: Colors.black,
                    //       //         fontWeight: FontWeight.w400,
                    //       //       ),
                    //       //     ),
                    //       //     GestureDetector(
                    //       //       onTap: () {
                    //       //         Navigator.pushNamed(context, '/signup');
                    //       //       },
                    //       //       child: Text(
                    //       //         'Register',
                    //       //         style: Theme.of(context).textTheme.button!.copyWith(
                    //       //           color: Theme.of(context).primaryColor,
                    //       //           fontWeight: FontWeight.w400,
                    //       //         ),
                    //       //       ),
                    //       //     ),
                    //       //   ],
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                    // WillowVerticalGap(
                    //   height: 15,
                    // ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
