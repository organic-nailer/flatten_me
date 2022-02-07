import 'dart:async';
import 'dart:math';

import 'package:flatten_me/how_to_dialog.dart';
import 'package:flatten_me/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

class SlideGameMenu extends StatefulWidget {
  final int steps;
  final VoidCallback reload;
  final ValueChanged<int> onAngleChanged;
  final int angle;
  final Stopwatch stopwatch;
  final bool isGyroscopeEnabled, isGyroscopeAvailable;
  final ValueChanged<bool> onGyroscopeChanged;
  final Color baseColor;
  const SlideGameMenu(
      {Key? key,
      required this.steps,
      required this.reload,
      required this.onAngleChanged,
      required this.stopwatch,
      required this.isGyroscopeAvailable,
      required this.isGyroscopeEnabled,
      required this.onGyroscopeChanged,
      required this.baseColor,
      required this.angle})
      : super(key: key);

  @override
  _SlideGameMenuState createState() => _SlideGameMenuState();
}

class _SlideGameMenuState extends State<SlideGameMenu> {
  double elapsedTimeSec = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (widget.stopwatch.isRunning) {
        safeSetState(() {
          elapsedTimeSec = widget.stopwatch.elapsedMilliseconds / 1000;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void safeSetState(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isBig = width >= 600;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(isBig ? 16.0 : 4.0),
              child: IconButton(
                tooltip: "Back to Home",
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
                iconSize: isBig ? 32 : 24,
                color: Colors.white,
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Padding(
              padding: EdgeInsets.all(isBig ? 8.0 : 4.0),
              child: IconButton(
                tooltip: "Reload",
                onPressed: widget.reload,
                icon: const Icon(Icons.refresh),
                iconSize: isBig ? 48 : 24,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isBig ? 8.0 : 4.0),
              child: IconButton(
                tooltip: "How to Play",
                onPressed: () {
                  showHowToPlay(context, widget.baseColor);
                },
                icon: const Icon(Icons.help_outline_rounded),
                iconSize: isBig ? 48 : 24,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isBig ? 8.0 : 4.0),
              child: IconButton(
                tooltip: "Use Gyroscope",
                onPressed: widget.isGyroscopeAvailable
                    ? () {
                        widget.onGyroscopeChanged(!widget.isGyroscopeEnabled);
                      }
                    : null,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    widget.isGyroscopeEnabled
                        ? Icons.sensors
                        : Icons.sensors_off,
                    key: ValueKey(widget.isGyroscopeEnabled),
                  ),
                ),
                iconSize: isBig ? 48 : 24,
                color:
                    widget.isGyroscopeAvailable ? Colors.white : Colors.black45,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SingleCircularSlider(
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                    selectionColor: Colors.transparent,
                    sliderStrokeWidth: 8,
                    handlerColor: Colors.white,
                  ),
                ),
                Text("Sight Angle",
                    style: TextStyle(
                        fontSize: isBig ? 15 : 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
                "${widget.steps} steps\n${elapsedTimeSec.toStringAsFixed(1)} sec  \u200b",
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontSize: isBig ? 40 : 30, color: Colors.white)),
            SizedBox(width: isBig ? 20 : 10),
          ],
        ),
      ],
    );
  }
}
