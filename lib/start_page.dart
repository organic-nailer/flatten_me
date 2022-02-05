import 'package:flatten_me/slide_game_page.dart';
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
                                baseColor: Colors.green.shade700,
                                lowColor: Colors.blue,
                                highColor: Colors.yellow)));
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
          ],
        ),
      ),
    );
  }
}
