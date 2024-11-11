import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// class CustomMQ {
//     static double designDisplayHeight = 640; // iPhone 13 mini height size
//     static double designDisplayWidth = 360; // iPhone 13 mini width size
//
//     static double get mediaQueryHeight => MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.height;
//     static double get mediaQueryWidth => MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width;
//
//     static double get HR => mediaQueryHeight / designDisplayHeight;
//     static double get WR => mediaQueryWidth / designDisplayWidth;
//
//     static double LBHR (int componentHeight){ // For Layoutbuilder widget to makesure the compojnents are fit to the screen
//         return (MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.height * componentHeight/designDisplayHeight);
//     }
//     static double LBWR (int componentWidth){
//         return (MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width * componentWidth/designDisplayHeight);
//     }
// }
//
//
// //responsiveness
// CustomMQ customMQ = CustomMQ();
// final HR = CustomMQ.HR;
// final WR = CustomMQ.WR;





// Vertical gap
class WillowVerticalGap extends StatelessWidget {
    int height = 15; //TODO edit this

    WillowVerticalGap({required this.height});

    @override
    Widget build(BuildContext context) {
        return SizedBox(height: height * 1.0);
    }
}

// padding
class WillowPadding extends StatelessWidget {
    int padding; //TODO edit this
    Widget child;

    WillowPadding({required this.child, required this.padding});

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 1.0), // padding
            child: child
        );
    }
}


