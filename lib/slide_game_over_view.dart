import 'package:flatten_me/start_page.dart';
import 'package:flutter/material.dart';

class SlideGameOverView extends StatefulWidget {
  final Color baseColor;
  final int steps;
  final double timeSec;
  final VoidCallback reload;
  const SlideGameOverView(
      {Key? key,
      required this.baseColor,
      required this.steps,
      required this.timeSec,
      required this.reload})
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
            const Text("RESULT", style: TextStyle(fontSize: 30)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Step:${widget.steps}",
                  style: const TextStyle(fontSize: 50)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Time:${widget.timeSec.toStringAsFixed(1)}sec",
                  style: const TextStyle(fontSize: 50)),
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
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share,
                        size: 40,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => const StartPage()));
                      },
                      icon: const Icon(
                        Icons.home,
                        size: 40,
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
