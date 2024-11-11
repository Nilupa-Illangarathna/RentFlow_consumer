import 'package:flutter/material.dart';

import '../../global/responsiveness.dart';

class WillowElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData? icon;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color? backgroundColor; // New property for custom background color

  WillowElevatedButton({
    required this.onPressed,
    required this.buttonText,
    this.icon,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.w500,
    this.color = Colors.white,
    this.backgroundColor, // Update to accept custom background color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Set custom background color if provided
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Colors.white,
              ),
            if (icon != null) SizedBox(width: 8),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
