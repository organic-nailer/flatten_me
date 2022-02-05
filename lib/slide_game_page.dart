import 'dart:math';

import 'package:expanded_grid/expanded_grid.dart';
import 'package:flatten_me/color_selector.dart';
import 'package:flatten_me/stroke_depth_button.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:rainbow_color/rainbow_color.dart';

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
  var slideCells = List<List<CellData>>.generate(
      4, (row) => List<CellData>.generate(4, (col) => CellData(row * 4 + col)));
  int emptyCellRow = 0;
  int emptyCellColumn = 0;

  int steps = 0;

  /// degree
  int angle = 45;

  bool isGameOver = false;

  late Tween<Color?> surfaceColor;

  @override
  void initState() {
    super.initState();

    surfaceColor = widget.colorPreset.getTween();
  }

  void onClickTile(int row, int column) {
    if ((row - emptyCellRow).abs() + (column - emptyCellColumn).abs() == 1) {
      setState(() {
        slideCells[emptyCellRow][emptyCellColumn].value =
            slideCells[row][column].value;
        slideCells[row][column].value = 0;
        emptyCellRow = row;
        emptyCellColumn = column;
        steps++;
      });

      isGameOver = true;
      for (int i = 0; i < slideCells.length; i++) {
        for (int j = 0; j < slideCells[i].length; j++) {
          if (slideCells[i][j].value != (i * 4 + j + 1) % 16) {
            isGameOver = false;
          }
        }
      }

      if (isGameOver) {
        print("Game Over");
        setState(() {});
      }
    }
  }

  void reload() {
    setState(() {
      List<CellData> cells;
      while (true) {
        cells = List<CellData>.generate(16, (index) => CellData(index))
          ..shuffle();
        // 問題が解けることを確認
        final zeroIndex = cells.indexWhere((e) => e.value == 0);
        final cellsCopy = cells.map((e) => e.value).toList();
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
      slideCells = List<List<CellData>>.generate(
          4,
          (row) => List<CellData>.generate(4, (col) {
                if (cells[row * 4 + col].value == 0) {
                  emptyCellRow = row;
                  emptyCellColumn = col;
                }
                return cells[row * 4 + col];
              }));
      steps = 0;
    });
  }

  SurfaceOffset angle2Offset(int angle, maxOffset) {
    if (angle == 90) return SurfaceOffset(maxOffset, 0);
    if (angle == 270) return SurfaceOffset(-maxOffset, 0);
    double dx, dy;
    switch (angle ~/ 45) {
      case 0:
      case 7:
        dy = maxOffset;
        break;
      case 3:
      case 4:
        dy = -maxOffset;
        break;
      case 1:
      case 2:
        dy = maxOffset / tan(angle * pi / 180);
        break;
      case 5:
      case 6:
        dy = maxOffset / tan(-angle * pi / 180);
        break;
      default:
        dy = 0;
    }

    switch (angle ~/ 45) {
      case 1:
      case 2:
        dx = maxOffset;
        break;
      case 5:
      case 6:
        dx = -maxOffset;
        break;
      case 0:
      case 7:
        dx = maxOffset * tan(angle * pi / 180);
        break;
      case 3:
      case 4:
        dx = maxOffset * tan(-angle * pi / 180);
        break;
      default:
        dx = 0;
    }
    return SurfaceOffset(dx, dy);
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
            Switch(
                value: isGameOver,
                onChanged: (v) {
                  setState(() {
                    isGameOver = v;
                  });
                }),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Steps: ',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text("$steps", style: TextStyle(fontSize: 40)),
                  IconButton(
                      onPressed: () {
                        reload();
                      },
                      icon: Icon(Icons.refresh)),
                  Spacer(
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
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(builder: (context, constraints) {
                      final width = constraints.biggest.width;
                      final cellSize = width / 4;
                      return Padding(
                        padding: EdgeInsets.all(cellSize * 0.1),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ExpandedGrid(
                                row: 4,
                                column: 4,
                                children: slideCells
                                    .mapIndexed((rowIndex, row) =>
                                        row.mapIndexed((columnIndex, cell) =>
                                            ExpandedGridContent(
                                                columnIndex: columnIndex,
                                                rowIndex: rowIndex,
                                                child: StrokeDepthButton(
                                                  child: Center(
                                                      child: Text(
                                                    widget.isBlindMode ||
                                                            cell.value == 0
                                                        ? ""
                                                        : "${cell.value}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            cellSize * 0.3),
                                                  )),
                                                  value: cell.value == 0
                                                      ? 0
                                                      : (cell.value -
                                                              (rowIndex * 4 +
                                                                  columnIndex +
                                                                  1)) /
                                                          15.0,
                                                  maxSurfaceOffset:
                                                      angle2Offset(angle,
                                                          cellSize * 0.2),
                                                  padding: cellSize * 0.1,
                                                  onChanged: () {
                                                    onClickTile(
                                                        rowIndex, columnIndex);
                                                  },
                                                  surfaceColor: surfaceColor,
                                                ))))
                                    .expand((e) => e)
                                    .toList(),
                              ),
                            ),
                            Positioned.fill(
                              child: AnimatedOpacity(
                                opacity: isGameOver ? 1 : 0,
                                duration: const Duration(milliseconds: 500),
                                child: Visibility(
                                  visible: isGameOver,
                                  child: ColoredBox(
                                    color: widget.colorPreset.baseColor,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("RESULT",
                                              style: TextStyle(fontSize: 30)),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("${steps} steps",
                                                style: TextStyle(fontSize: 50)),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.refresh,
                                                      size: 40,
                                                    )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.share,
                                                      size: 40,
                                                    )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.home,
                                                      size: 40,
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
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

class CellData {
  int value;
  CellData(this.value);
}
