import 'package:flutter/material.dart';

class KeyInputIntent extends Intent {
  final KeyInputType type;
  const KeyInputIntent({required this.type});
  const KeyInputIntent.arrowUp() : type = KeyInputType.arrowUp;
  const KeyInputIntent.arrowDown() : type = KeyInputType.arrowDown;
  const KeyInputIntent.arrowLeft() : type = KeyInputType.arrowLeft;
  const KeyInputIntent.arrowRight() : type = KeyInputType.arrowRight;
}

enum KeyInputType { arrowUp, arrowDown, arrowLeft, arrowRight }
