import 'package:flutter/material.dart';
import 'package:flatten_me/ext_color.dart';

const bodyTextStyle =
    TextStyle(fontSize: 20, color: Colors.black87, letterSpacing: -0.7);

const titleTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Colors.black54,
);

void showHowToPlay(BuildContext context, Color baseColor) {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('How to play',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              backgroundColor:
                  Colors.white.stackOnTop(baseColor.withOpacity(0.5)),
              children: <Widget>[
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 400, maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "\"Flatten me!\" is a kind of \"15 puzzle\". "
                          "The goal of this puzzle is not only to place cells in numerical order "
                          "but also to flatten height of cells.",
                          style: bodyTextStyle,
                        ),
                        const Text(
                          "As shown in the figure below, "
                          "the height of cells in the correct position is 0, "
                          "but cells on the upper left than the correct position are being protruded. "
                          "Also  on the bottom right ones are being dented.",
                          style: bodyTextStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: Image.asset(
                                "assets/howto1.png",
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "By pressing the cell adjacent to a blank cell, "
                          "the cell can be moved to the position of the blank cell.",
                          style: bodyTextStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: Image.asset(
                                "assets/howto2.png",
                                height: 200,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "On the start screen, you can select the mode and how to play, "
                          "and you can change the theme color at the bottom. "
                          "Click / tap the theme you want to apply and the theme will be applied to the whole.",
                          style: bodyTextStyle,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Blind Mode",
                            style: titleTextStyle,
                          ),
                        ),
                        const Text(
                          "In this mode, the numbers are hidden, "
                          "so you need to play with only the height information.",
                          style: bodyTextStyle,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Sight Angle",
                            style: titleTextStyle,
                          ),
                        ),
                        const Text(
                          "You can change the sight angle with the circular slider on the top left. "
                          "If you are using a smartphone, "
                          "you can enable the gyro sensor from the icon on the top right.",
                          style: bodyTextStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ]));
}
