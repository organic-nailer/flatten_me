import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

class SlideGameMenu extends StatefulWidget {
  final int steps;
  final VoidCallback reload;
  final ValueChanged<int> onAngleChanged;
  final int angle;
  final Stopwatch stopwatch;
  const SlideGameMenu(
      {Key? key,
      required this.steps,
      required this.reload,
      required this.onAngleChanged,
      required this.stopwatch,
      required this.angle})
      : super(key: key);

  @override
  _SlideGameMenuState createState() => _SlideGameMenuState();
}

class _SlideGameMenuState extends State<SlideGameMenu> {
  double elapsedTimeSec = 0;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (widget.stopwatch.isRunning) {
        setState(() {
          elapsedTimeSec = widget.stopwatch.elapsedMilliseconds / 1000;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isBig = width >= 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleCircularSlider(
              72,
              (widget.angle / 5).floor(),
              width: isBig ? 100 : 80,
              height: isBig ? 100 : 80,
              onSelectionChange: (a, b, c) {
                widget.onAngleChanged(b * 5 % 360);
              },
              onSelectionEnd: (_, __, ___) {},
              child: Center(
                child: Transform.rotate(
                  angle: widget.angle * pi / 180,
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: isBig ? 40 : 20,
                    color: Colors.red.shade200,
                  ),
                ),
              ),
              selectionColor: Colors.transparent,
              sliderStrokeWidth: 8,
              handlerColor: Colors.red.shade200,
            ),
            Text("Sight Angle",
                style: TextStyle(
                    fontSize: isBig ? 15 : 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade200)),
          ],
        ),
        const SizedBox(
          width: 16,
        ),
        Text("${widget.steps}steps\n${elapsedTimeSec.toStringAsFixed(1)}sec",
            style: TextStyle(fontSize: isBig ? 40 : 30)),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(isBig ? 8.0 : 4.0),
                child: IconButton(
                  onPressed: widget.reload,
                  icon: const Icon(Icons.refresh),
                  iconSize: isBig ? 48 : 24,
                  color: Colors.red.shade200,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isBig ? 8.0 : 4.0),
                child: IconButton(
                  onPressed: widget.reload,
                  icon: const Icon(Icons.help_outline_rounded),
                  iconSize: isBig ? 48 : 24,
                  color: Colors.red.shade200,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
