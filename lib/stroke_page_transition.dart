import 'package:flutter/material.dart';

void navigateWithStrokeTransition(BuildContext context, Widget newPage) {
  Navigator.push(
      context,
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return newPage;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation
                  .drive(CurveTween(curve: Curves.easeInOutCirc))
                  .drive(Tween(begin: 0.0, end: 1.0)),
              child: SlideTransition(
                  position: animation
                      .drive(CurveTween(curve: Curves.easeInOutCirc))
                      .drive(Tween(
                          begin: const Offset(-1.0, 1.0), end: Offset.zero)),
                  child: child),
            );
          }));
}
