import 'package:flatten_me/color_selector.dart';
import 'package:flatten_me/slide_game_page.dart';
import 'package:flatten_me/start_copyright_view.dart';
import 'package:flatten_me/start_title_view.dart';
import 'package:flatten_me/stroke_button.dart';
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
            const Expanded(child: StartTitleView()),
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
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
            const StartCopyrightView(),
          ],
        ),
      ),
    );
  }

  Widget buildButton({required String text, Widget? icon, required int index}) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width >= 700 ? 300 : 200,
      height: width >= 700 ? 90 : 60,
      child: StrokeButton(
          value: buttonStates[index],
          onChanged: (value) => onClickButton(index),
          offsetForProjection: width >= 700 ? 10 : 8,
          radius: width >= 700 ? 15 : 10,
          surfaceColor: colorPresets[selectedColorIndex].getTween(),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) icon,
              const SizedBox(width: 10),
              Text(text, style: TextStyle(fontSize: width >= 700 ? 25 : 20))
            ],
          ))),
    );
  }
}
