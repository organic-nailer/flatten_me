import 'package:flutter/material.dart';

extension ColorExt on Color {
  Color stackOnTop(Color other) {
    return Color.fromARGB(
        255,
        (other.opacity * other.red + (1 - other.opacity) * opacity * red)
            .floor(),
        (other.opacity * other.green + (1 - other.opacity) * opacity * green)
            .floor(),
        (other.opacity * other.blue + (1 - other.opacity) * opacity * blue)
            .floor());
  }
}
