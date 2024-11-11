import 'package:flutter/material.dart';

class Image_viewer extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;

  Image_viewer({required this.imagePath, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: fit,
    );
  }
}
