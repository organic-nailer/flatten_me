import 'package:flatten_me/color_selector.dart';
import 'package:flatten_me/slide_game_page.dart';
import 'package:flatten_me/stroke_button.dart';
import 'package:flatten_me/util.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

final colorPresets = [
  ColorPreset(Colors.green.shade800, Colors.yellow, Colors.blue, "Greenery"),
  ColorPreset(Colors.lightBlue.shade700, Colors.blue.shade800, Colors.brown,
      "Dashlike"),
  ColorPreset(Colors.orange.shade800, Colors.red, Colors.yellow, "Enthusiasm"),
  ColorPreset(
      Colors.grey.shade600, Colors.grey.shade200, Colors.black, "Monochrome"),
];

class _StartPageState extends State<StartPage> {
  List<bool> buttonStates = [false, false, false];
  int selectedColorIndex = 0;

  void onClickButton(int index) {
    setState(() {
      buttonStates[index] = !buttonStates[index];
    });
    if (buttonStates[index]) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        switch (index) {
          case 0:
            // TODO: Implement
            break;
          case 1:
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => SlideGamePage(
                    colorPreset: colorPresets[selectedColorIndex])));
            break;
          case 2:
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => SlideGamePage(
                      colorPreset: colorPresets[selectedColorIndex],
                      isBlindMode: true,
                    )));
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPresets[selectedColorIndex].baseColor,
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Center(
                    child: Text(
              "Flatten me!",
              style: Theme.of(context).textTheme.headline1,
            ))),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildButton(text: "How to Play", index: 0),
                buildButton(text: "Normal Mode", index: 1),
                buildButton(
                    text: "Blind Mode",
                    icon: const Icon(Icons.visibility_off),
                    index: 2)
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: ColorSelector(
                  presets: colorPresets,
                  value: selectedColorIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedColorIndex = value;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text("© 2022"),
                TextButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory),
                    child: const Text(
                      "fastriver_org",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    )),
                const Text("|"),
                TextButton(
                    onPressed: () {
                      showLicensePage(context: context);
                    },
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory),
                    child: const Text(
                      "License",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton({required String text, Widget? icon, required int index}) {
    return SizedBox(
      width: 300,
      height: 90,
      child: StrokeButton(
          value: buttonStates[index],
          onChanged: (value) => onClickButton(index),
          offsetForProjection: 10,
          surfaceColor: colorPresets[selectedColorIndex].getTween(),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) icon,
              const SizedBox(width: 10),
              Text(text, style: const TextStyle(fontSize: 25))
            ],
          ))),
    );
  }
}
