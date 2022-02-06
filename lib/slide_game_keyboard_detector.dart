import 'package:flatten_me/key_input_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SlideGameKeyboardDetector extends StatelessWidget {
  final Widget child;
  final int emptyCellRow, emptyCellColumn;
  final Function(int, int) onClickTile;
  const SlideGameKeyboardDetector(
      {Key? key,
      required this.child,
      required this.onClickTile,
      required this.emptyCellRow,
      required this.emptyCellColumn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      actions: <Type, Action<Intent>>{
        KeyInputIntent:
            CallbackAction<KeyInputIntent>(onInvoke: (KeyInputIntent intent) {
          switch (intent.type) {
            case KeyInputType.arrowUp:
              onClickTile(emptyCellRow + 1, emptyCellColumn);
              break;
            case KeyInputType.arrowDown:
              onClickTile(emptyCellRow - 1, emptyCellColumn);
              break;
            case KeyInputType.arrowLeft:
              onClickTile(emptyCellRow, emptyCellColumn + 1);
              break;
            case KeyInputType.arrowRight:
              onClickTile(emptyCellRow, emptyCellColumn - 1);
              break;
          }
          return null;
        })
      },
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.arrowUp):
            const KeyInputIntent.arrowUp(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown):
            const KeyInputIntent.arrowDown(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft):
            const KeyInputIntent.arrowLeft(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight):
            const KeyInputIntent.arrowRight(),
        LogicalKeySet(LogicalKeyboardKey.keyA):
            const KeyInputIntent.arrowLeft(),
        LogicalKeySet(LogicalKeyboardKey.keyD):
            const KeyInputIntent.arrowRight(),
        LogicalKeySet(LogicalKeyboardKey.keyW): const KeyInputIntent.arrowUp(),
        LogicalKeySet(LogicalKeyboardKey.keyS):
            const KeyInputIntent.arrowDown(),
      },
      child: Focus(autofocus: true, child: child),
    );
  }
}
