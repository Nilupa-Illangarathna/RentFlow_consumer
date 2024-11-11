import 'package:flutter/material.dart';

import '../../../../global/responsiveness.dart';
import '../../../../widgets/common/elevated_button.dart';
import '../../../../widgets/common/image_viewer.dart';

class PasswordResetCompletePage extends StatelessWidget {
  final Function() onClose;

  const PasswordResetCompletePage({required this.onClose});

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
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WillowPadding(
                  padding: 24,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Password Reset Complete',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400,
                                // color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                        WillowVerticalGap(height: 15,),

                        WillowElevatedButton(
                          onPressed: onClose,
                          buttonText: 'Close',
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
