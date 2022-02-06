import 'package:flutter/material.dart';

class StartCopyrightView extends StatelessWidget {
  const StartCopyrightView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Text("© 2022"),
        TextButton(
            onPressed: () {},
            style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
            child: const Text(
              "fastriver_org",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            )),
        const Text("|"),
        TextButton(
            onPressed: () {
              showLicensePage(context: context);
            },
            style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
            child: const Text(
              "License",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
