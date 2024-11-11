import 'package:flutter/material.dart';

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  final Curve curve;
  final Duration duration;

  CustomPageTransitionsBuilder({
    this.curve = Curves.easeInOut,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    if (route.settings.name == '/') {
      return child;
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
      ),
      child: child,
    );
  }
}
