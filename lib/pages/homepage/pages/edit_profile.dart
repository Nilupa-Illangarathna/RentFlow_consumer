import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../global/api_caller.dart';
import '../../../global/global_settings.dart';
import '../../../global/regex.dart';
import '../../../global/responsiveness.dart';
import '../../../main.dart';
import '../../../security/encryption.dart';
import '../../../utils/error_handling.dart';
import '../../../utils/user_credentials.dart';
import '../../../widgets/common/elevated_button.dart';
import '../../../widgets/common/loading_screen.dart';

class EditProfile extends StatefulWidget {
  final String? profileImageUrl;

  EditProfile({
    Key? key,
    this.profileImageUrl,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _passwordVisible = false;
  bool isLogout = false;
  bool _isLoading = true;
  String? _contactNumber;
  String? _name;
  String? _email;

  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  Map<String, String> errorMessages = {};

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      // Make API call to fetch profile data
      final url = '${globalData.baseUrl}/consumer/get_profile';

      // Construct request body
      Map<String, dynamic> requestBody = {"consumer_id": 10000000000000000};

      Map<String, dynamic>? response = await apiCaller.callApi(
        sessionToken: globalData.sessionToken,
        route: '/consumer/get_profile',
        body: requestBody,
      );

      print("response is : ${response}");
      if (response?["is_success"] == true) {
        setState(() {
          _contactNumber = response?['contact_no'];
          _name = response?['name'];
          _email = response?['email'];
          _isLoading = false;
          // Update the controllers
          contactNumberController.text = _contactNumber ?? '';
          nameController.text = _name ?? '';
        });
      } else {
        setState(() {
          _contactNumber = "";
          _name = "";
          _email = "";
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unable to load the existing contact"),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        _contactNumber = "";
        _name = "";
        _email = "";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: LoadingScreen(),
      )
          : SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 24, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFADF2C6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 40.24,
                                width: 45.75,
                                child: ClipOval(
                                  child: widget.profileImageUrl != null
                                      ? Image.network(
                                      widget.profileImageUrl!)
                                      : Image.asset(
                                    'assets/images/profile/profile.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        WillowVerticalGap(height: 10),
                        // User Name
                        Text(
                          _name ?? '', // Use _name and provide a fallback value if it's null
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        WillowVerticalGap(height: 5),
                        // User Email
                        Text(
                          _email ?? '', // Use _email and provide a fallback value if it's null
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        WillowVerticalGap(height: 57),
                        // 'Edit Profile' Label
                        Row(
                          children: [
                            Text(
                              'Change account info',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        WillowVerticalGap(height: 10),
                        Container(
                          height: errorMessages['name'] != null &&
                              nameController.text != ""
                              ? 96
                              : errorMessages['name'] != null
                              ? 78
                              : 56,
                          child: TextFormField(
                            controller: nameController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person_outline),
                              errorText: errorMessages['name'],
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        WillowVerticalGap(height: 10),
                        Container(
                          height: errorMessages['mobile'] != null &&
                              contactNumberController.text != ""
                              ? 96
                              : errorMessages['mobile'] != null
                              ? 78
                              : 56,
                          child: TextFormField(
                            controller: contactNumberController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Contact Number',
                              prefixIcon: Icon(Icons.phone_outlined),
                              errorText: errorMessages['mobile'],
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        WillowVerticalGap(height: 10),
                        Container(
                          height: errorMessages['password'] != null &&
                              passwordController.text != ""
                              ? 96
                              : errorMessages['password'] != null
                              ? 78
                              : 54,
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
                        WillowVerticalGap(
                          height: 10,
                        ),
                        Container(
                          height: errorMessages['confirmPassword'] != null
                              ? 78
                              : 56,
                          child: TextFormField(
                            controller: passwordConfirmController,
                            obscureText: !_passwordVisible,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon:
                              Icon(Icons.vpn_key), // Custom key icon
                              errorText: errorMessages['confirmPassword'],
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
                        WillowVerticalGap(height: 10),
                        if (!isLogout)
                          WillowElevatedButton(
                            onPressed: _onSavePressed,
                            buttonText: 'Save',
                            icon: Icons.save,
                          ),
                      ],
                    ),
                  ),
                  if (!isLogout)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: (globalData.BottomNavBarHeight + 15),
                            right: 24,
                            left: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            WillowElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isLogout = true;
                                });
                              },
                              buttonText: 'Logout',
                              icon: Icons.logout,
                              backgroundColor: Color(0xFF404942),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: (globalData.BottomNavBarHeight + 15),
                          right: 24,
                          left: 24),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isLogout)
                              Container(
                                height: 154,
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    bottomLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                    bottomRight: Radius.circular(28),
                                  ),
                                  color: Color(0xFFADF2C6),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Are you sure you wanna logout?",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF49454F),
                                      ),
                                    ),
                                    WillowVerticalGap(height: 24),
                                    Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isLogout = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Dismiss',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color:
                                                    Color(0xFF286A48),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            WillowElevatedButton(
                                              onPressed: () {
                                                setState(() async {
                                                  isLogout = false;
                                                  // Save session token in SharedPreferences
                                                  await userCredentials
                                                      .saveSessionToken(
                                                      "");

                                                  // Update GlobalData with the latest credentials
                                                  await globalData
                                                      .updateData();

                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    '/auth', // Route name for the authentication page
                                                        (route) =>
                                                    false, // Remove all the other pages
                                                  );
                                                });
                                              },
                                              buttonText: 'Logout',
                                              backgroundColor:
                                              Color(0xFFFF6961),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle form submission
  void _handleSubmit() async {
    if (_validateInputFields()) {
      // Extract data from form fields
      String contactNumber = contactNumberController.text.trim();
      String name = nameController.text.trim();
      String password = passwordController.text.trim();

      // TODO: Hashing
      String hashedPassword = generateHash(password);
      print("Hashed password: $hashedPassword");

      String newPassword = hashedPassword;

      // Construct request body
      Map<String, dynamic> requestBody = {
        if(name.isNotEmpty) "name": name,
        if(contactNumber.isNotEmpty) "contact_no": contactNumber,
        if(password.isNotEmpty) "newPassword": newPassword,
      };

      Map<String, dynamic>? response = await apiCaller.callApi(
        sessionToken: globalData.sessionToken,
        route: '/consumer/update_profile',
        body: requestBody,
      );

      print("response is : ${response}");
      if (response?["is_success"]) {
        String message = response?['message'];
        // Show snackbar based on response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        String message = response?['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _validateInputFields() {
    bool isValid = true;
    errorMessages.clear();

    if (contactNumberController.text.isNotEmpty &&
        !Regex.mobileRegExp.hasMatch(contactNumberController.text)) {
      errorMessages['mobile'] =
      ErrorHandling.signupErrors['mobile']['invalid']!;
      isValid = false;
    }

    // Name validation
    if (nameController.text.isEmpty) {
      errorMessages['name'] = 'Name cannot be empty';
      isValid = false;
    }

    // Password validation
    if (passwordController.text.isNotEmpty && !Regex.passwordRegExp.hasMatch(passwordController.text)) {
      errorMessages['password'] =
      ErrorHandling.signupErrors['password']['invalid']!;
      isValid = false;
    }

    if (passwordController.text.isNotEmpty && passwordConfirmController.text.isEmpty ||
        passwordController.text.isNotEmpty && (passwordController.text !=passwordConfirmController.text)) {
      errorMessages['confirmPassword'] = 'Passwords do not match!';
      isValid = false;
    }

    // // Confirm Password validation
    // if (passwordController.text != passwordConfirmController.text &&
    //     passwordConfirmController.text != "" &&
    //     passwordController.text != "") {
    //   errorMessages['confirmPassword'] = 'Passwords do not match!';
    //   isValid = false;
    // }
    //
    // if (contactNumberController.text.isEmpty &&
    //     passwordController.text.isEmpty &&
    //     passwordConfirmController.text.isEmpty) {
    //   isValid = false;
    // }
    setState(() {});
    return isValid;
  }

  void _onSavePressed() {
    if (_validateInputFields()) {
      print('Name: ${nameController.text}');
      print('Contact Number: ${contactNumberController.text}');
      print('Password: ${passwordController.text}');
      print('Confirm Password: ${passwordConfirmController.text}');
      _handleSubmit();
    }
  }

  // Function to print all data in input fields
  void printAllData() {
    print('Name: ${nameController.text}');
    print('Contact Number: ${contactNumberController.text}');
    print('Password: ${passwordController.text}');
    print('Confirm Password: ${passwordConfirmController.text}');
  }
}


