import 'package:flatten_me/color_selector.dart';
import 'package:flatten_me/slide_game_page.dart';
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
  ColorPreset(Colors.grey, Colors.grey.shade200, Colors.black, "Monotony"),
];

class _StartPageState extends State<StartPage> {
  int selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPresets[selectedColorIndex].baseColor,
      body: Center(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Center(
                    child: Text(
                  "Flatten me!",
                  style: Theme.of(context).textTheme.headline1,
                ))),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text("How to play",
                          style: TextStyle(fontSize: 20))),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => SlideGamePage(
                                  colorPreset: colorPresets[selectedColorIndex],
                                )));
                      },
                      child:
                          const Text("Start", style: TextStyle(fontSize: 20))),
                  TextButton(
                      onPressed: () {
                        showLicensePage(context: context);
                      },
                      child: const Text("License",
                          style: TextStyle(fontSize: 20))),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ColorSelector(
                    presets: colorPresets,
                    value: selectedColorIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedColorIndex = value;
                      });
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
