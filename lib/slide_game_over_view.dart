import 'package:flatten_me/start_page.dart';
import 'package:flatten_me/util.dart';
import 'package:flutter/material.dart';

class SlideGameOverView extends StatefulWidget {
  final Color baseColor;
  final int steps;
  final double timeSec;
  final VoidCallback reload;
  final bool isBlind;
  const SlideGameOverView(
      {Key? key,
      required this.baseColor,
      required this.steps,
      required this.timeSec,
      required this.reload,
      required this.isBlind})
      : super(key: key);

  @override
  _SlideGameOverViewState createState() => _SlideGameOverViewState();
}

class _SlideGameOverViewState extends State<SlideGameOverView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.baseColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("RESULT" + (widget.isBlind ? "(Blind)" : ""),
                style: const TextStyle(fontSize: 30, color: Colors.white)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Step:${widget.steps}",
                  style: const TextStyle(fontSize: 50, color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Time:${widget.timeSec.toStringAsFixed(1)}sec",
                  style: const TextStyle(fontSize: 50, color: Colors.white)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: widget.reload,
                      icon: const Icon(
                        Icons.refresh,
                        size: 40,
                        color: Colors.white,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        openUrl("https://twitter.com/intent/tweet?text="
                            "--%20${widget.isBlind ? "Blind" : "Normal"}%20Mode%20--%0A"
                            "Steps%3A%20${widget.steps}%0A"
                            "Time%3A%20${widget.timeSec.toStringAsFixed(1)}s%0A%0A"
                            "Flatten%20me!%20%40%20%23FlutterPuzzleHack%20%7C%20"
                            "https%3A%2F%2Fflatten-me.fastriver.dev%2F%23%2F");
                      },
                      icon: const Icon(
                        Icons.share,
                        size: 40,
                        color: Colors.white,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.home,
                        size: 40,
                        color: Colors.white,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
