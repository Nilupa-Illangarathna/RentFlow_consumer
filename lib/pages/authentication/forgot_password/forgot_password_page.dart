import 'package:flutter/material.dart';
import 'forgot_password_page.dart';
import 'forgot_password_routes/PasswordResetCompletePage.dart';
import 'forgot_password_routes/otp_verification.dart';
import 'forgot_password_routes/reset_password.dart';
import 'forgot_password_routes/send_otp.dart';

class ForgotPasswordPageCaller extends StatelessWidget {
  final bool isModal;

  const ForgotPasswordPageCaller({Key? key, required this.isModal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isModal ? _buildModalBottomSheet(context) : _buildPage();
  }

   _buildModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ForgotPasswordModelBottomSheet(isModal: isModal,),
    );
  }

  Widget _buildPage() {
    return Scaffold(
      body: ForgotPasswordModelBottomSheet(isModal:isModal),
    );
  }
}

class ForgotPasswordModelBottomSheet extends StatefulWidget {
  bool isModal;

  ForgotPasswordModelBottomSheet({required  this.isModal});

  @override
  _ForgotPasswordModelBottomSheetState createState() => _ForgotPasswordModelBottomSheetState();
}

class _ForgotPasswordModelBottomSheetState extends State<ForgotPasswordModelBottomSheet> {
  late int step;
  late String method;
  late String contact;
  late Function _sendOTP;
  late String reset_token;


  @override
  void initState() {
    super.initState();
    step = 1;
  }

  void moveToNextStep(int nextStep) {
    setState(() {
      step = nextStep;
    });
  }

  void moveToHomepage(int nextStep) {
    // Navigate to home page
    Navigator.pushReplacementNamed(context, '/auth');
  }

  void saveMethodAndContact(String selectedMethod, String enteredContact, Function sendOTP) {
    setState(() {
      method = selectedMethod;
      contact = enteredContact;
      _sendOTP = sendOTP;
    });
  }

  void onRecieveResetToken(String Token) {
    setState(() {
      reset_token = Token;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (step) {
      case 1:
        currentPage = ForgotPasswordPage(
          isModal: widget.isModal,
          onNextStep: moveToNextStep,
          onSaveMethodAndContact: saveMethodAndContact,
        );
        break;
      case 2:
        currentPage = ForgotPasswordOTPPage(
          isModal: widget.isModal,
          onNextStep: moveToNextStep,
          method: method,
          contact: contact,
          sendOTP: _sendOTP,
          onRecieveResetToken: onRecieveResetToken,
        );
        break;
      case 3:
        currentPage = ResetPasswordPage(
          isModal: widget.isModal,
          onNextStep: moveToHomepage,
          method: method,
          contact: contact,
          reset_token:reset_token
        );
        break;
      case 4:
        currentPage = PasswordResetCompletePage(
          onClose: () {
            Navigator.pop(context);
          },
        );
        break;
      default:
        currentPage = Container();
    }

    return Material(
      child: Container(
        padding: EdgeInsets.all(0.0),
        child: currentPage,
      ),
    );
  }
}
