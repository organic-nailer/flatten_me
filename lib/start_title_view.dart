import 'package:flutter/material.dart';

class StartTitleView extends StatelessWidget {
  const StartTitleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBig = MediaQuery.of(context).size.width >= 700 &&
        MediaQuery.of(context).size.height >= 700;
    return Center(
        child: Text(
      "Flatten me!",
      textAlign: TextAlign.center,
      style: isBig
          ? Theme.of(context).textTheme.headline1
          : Theme.of(context).textTheme.headline2,
    ));
  }
}
