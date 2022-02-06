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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${widget.steps}steps\n${elapsedTimeSec.toStringAsFixed(1)}sec",
            style: const TextStyle(fontSize: 40)),
        IconButton(onPressed: widget.reload, icon: const Icon(Icons.refresh)),
        const Spacer(
          flex: 1,
        ),
        SingleCircularSlider(
          72,
          (widget.angle / 5).floor(),
          width: 100,
          height: 100,
          onSelectionChange: (a, b, c) {
            widget.onAngleChanged(b * 5 % 360);
          },
          onSelectionEnd: (_, __, ___) {},
          child: Center(
            child: Transform.rotate(
              angle: widget.angle * pi / 180,
              child: Icon(
                Icons.arrow_upward_rounded,
                size: 40,
                color: Colors.red.shade200,
              ),
            ),
          ),
          selectionColor: Colors.transparent,
          sliderStrokeWidth: 8,
          handlerColor: Colors.red.shade200,
        )
      ],
    );
  }
}
