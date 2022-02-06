import 'package:flutter/material.dart';

class StartTitleView extends StatelessWidget {
  const StartTitleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
        child: Text(
      "Flatten me!",
      style: width >= 700
          ? Theme.of(context).textTheme.headline1
          : Theme.of(context).textTheme.headline2,
    ));
  }
}
