import 'package:flatter/slide_game_page.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Flatten me!"),
            Row(
              children: [
                TextButton(onPressed: () {}, child: Text("How to play")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => SlideGamePage(
                              baseColor: Colors.green.shade700,
                              lowColor: Colors.blue,
                              highColor: Colors.yellow)));
                    },
                    child: Text("Start")),
                TextButton(onPressed: () {}, child: Text("License")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
