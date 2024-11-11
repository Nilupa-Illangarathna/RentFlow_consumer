import 'package:flutter/material.dart';
import 'utils/theme.dart';

class PageViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: PageView(
        children: [
          Page(title: 'Page 1'),
          Page(title: 'Page 2'),
          Page(title: 'Page 3'),
          Page(title: 'Page 4'),
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String title;

  Page({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          color: AppTheme.themeData.primaryColor,
        ),
      ),
    );
  }
}
