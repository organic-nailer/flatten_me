import 'dart:math';

import 'package:flatten_me/color_selector.dart';
import 'package:flatten_me/slide_game_over_view.dart';
import 'package:flatten_me/slide_game_table.dart';
import 'package:flatten_me/stroke_depth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

class SlideGamePage extends StatefulWidget {
  final ColorPreset colorPreset;
  final bool isBlindMode;
  const SlideGamePage(
      {Key? key, required this.colorPreset, this.isBlindMode = false})
      : super(key: key);

  @override
  _SlideGamePageState createState() => _SlideGamePageState();
}

class _SlideGamePageState extends State<SlideGamePage> {
  var slideCells = List<List<int>>.generate(
      4, (row) => List<int>.generate(4, (col) => row * 4 + col));
  int emptyCellRow = 0;
  int emptyCellColumn = 0;

  int steps = 0;

  /// degree
  int angle = 45;

  void onClickTile(int row, int column) {
    if ((row - emptyCellRow).abs() + (column - emptyCellColumn).abs() == 1) {
      setState(() {
        slideCells[emptyCellRow][emptyCellColumn] = slideCells[row][column];
        slideCells[row][column] = 0;
        emptyCellRow = row;
        emptyCellColumn = column;
        steps++;
      });

      bool isGameOver = true;
      for (int i = 0; i < slideCells.length; i++) {
        for (int j = 0; j < slideCells[i].length; j++) {
          if (slideCells[i][j] != (i * 4 + j + 1) % 16) {
            isGameOver = false;
          }
        }
      }

      if (isGameOver) {
        onGameOver();
      }
    }
  }

  void reload() {
    setState(() {
      List<int> cells;
      while (true) {
        cells = List<int>.generate(16, (index) => index)..shuffle();
        // 問題が解けることを確認
        final zeroIndex = cells.indexWhere((e) => e == 0);
        final cellsCopy = cells.toList();
        int swapCount = 0;
        for (int i = 0; i < cellsCopy.length; i++) {
          if (cellsCopy[i] != (i + 1) % 16) {
            final target = cellsCopy.indexWhere((e) => e == (i + 1) % 16);
            cellsCopy[target] = cellsCopy[i];
            cellsCopy[i] = (i + 1) % 16;
            swapCount++;
          }
        }

        if (swapCount % 2 ==
            (((zeroIndex ~/ 4) - 3).abs() + ((zeroIndex % 4) - 3).abs()) % 2) {
          break;
        }
      }
      slideCells = List<List<int>>.generate(
          4,
          (row) => List<int>.generate(4, (col) {
                if (cells[row * 4 + col] == 0) {
                  emptyCellRow = row;
                  emptyCellColumn = col;
                }
                return cells[row * 4 + col];
              }));
      steps = 0;
      showGameOver = false;
    });
  }

  bool lowerCells = false;
  bool showGameOver = false;

  /// ゲーム終了時のアニメーション
  void onGameOver() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      lowerCells = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() {
      showGameOver = true;
      lowerCells = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.colorPreset.baseColor,
      body: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  onGameOver();
                },
                child: const Text("gameover")),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Steps: ',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text("$steps", style: const TextStyle(fontSize: 40)),
                  IconButton(
                      onPressed: () {
                        reload();
                      },
                      icon: const Icon(Icons.refresh)),
                  const Spacer(
                    flex: 1,
                  ),
                  SingleCircularSlider(
                    72,
                    (angle / 5).floor(),
                    width: 100,
                    height: 100,
                    onSelectionChange: (a, b, c) {
                      setState(() {
                        angle = b * 5 % 360;
                      });
                    },
                    onSelectionEnd: (_, __, ___) {},
                    child: Center(
                      child: Transform.rotate(
                        angle: angle * pi / 180,
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
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(builder: (context, constraints) {
                      final width = constraints.biggest.width;
                      final cellSize = width / 4;
                      return StrokeDepthButton(
                        surfaceColor: ColorTween(
                            begin: widget.colorPreset.baseColor,
                            end: widget.colorPreset.baseColor),
                        value: lowerCells ? -0.9 : 0.0,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOutSine,
                        maxSurfaceOffset: SurfaceOffset(width, width),
                        child: Padding(
                          padding: EdgeInsets.all(cellSize * 0.1),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: SlideGameTable(
                                      isBlindMode: widget.isBlindMode,
                                      surfaceColor:
                                          widget.colorPreset.getTween(),
                                      angle: angle,
                                      onClickCell: onClickTile,
                                      slideCells: slideCells)),
                              Positioned.fill(
                                child: Visibility(
                                    visible: showGameOver,
                                    child: SlideGameOverView(
                                        baseColor: widget.colorPreset.baseColor,
                                        steps: steps,
                                        reload: reload)),
                              )
                            ],
                          ),
                        ),
                      );
                    })),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
