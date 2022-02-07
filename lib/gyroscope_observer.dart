import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeObserver {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  StreamSubscription<GyroscopeEvent>? _gyroscopeEvents;
  Stopwatch stopwatch = Stopwatch();
  double _lastTime = 0.0;

  void listen(Function onChange) {
    if (_gyroscopeEvents != null) {
      _gyroscopeEvents?.cancel();
      stopwatch.reset();
      _lastTime = 0.0;
    }
    stopwatch.start();

    _gyroscopeEvents = gyroscopeEvents.listen((GyroscopeEvent event) {
      final interval = stopwatch.elapsedMilliseconds / 1000 - _lastTime;
      x += event.x * interval;
      y += event.y * interval;
      z += event.z * interval;
      onChange();
      _lastTime = stopwatch.elapsedMilliseconds / 1000;
    });
  }

  void resetPosition() {
    x = 0.0;
    y = 0.0;
    z = 0.0;
  }

  void dispose() {
    _gyroscopeEvents?.cancel();
    stopwatch.stop();
    _lastTime = 0.0;
  }

  @override
  String toString() {
    return 'GyroscopeObserver{x: $x, y: $y, z: $z}';
  }
}
