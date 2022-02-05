import 'dart:math';

import 'package:expanded_grid/expanded_grid.dart';
import 'package:collection/collection.dart';
import 'package:flatten_me/stroke_depth_button.dart';
import 'package:flutter/material.dart';

class SlideGameTable extends StatefulWidget {
  final bool isBlindMode;
  final Tween<Color?> surfaceColor;
  final int angle;
  final Function(int, int) onClickCell;
  final List<List<int>> slideCells;
  const SlideGameTable(
      {Key? key,
      required this.isBlindMode,
      required this.surfaceColor,
      required this.angle,
      required this.onClickCell,
      required this.slideCells})
      : super(key: key);

  @override
  _SlideGameTableState createState() => _SlideGameTableState();
}

class _SlideGameTableState extends State<SlideGameTable> {
  @override
  void didUpdateWidget(covariant SlideGameTable oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cellSize = constraints.maxWidth / 4;
      return ExpandedGrid(
        row: 4,
        column: 4,
        children: widget.slideCells
            .mapIndexed((rowIndex, row) =>
                row.mapIndexed((columnIndex, cell) => ExpandedGridContent(
                    columnIndex: columnIndex,
                    rowIndex: rowIndex,
                    child: StrokeDepthButton(
                      child: Center(
                          child: Text(
                        widget.isBlindMode || cell == 0 ? "" : "$cell",
                        style: TextStyle(
                            color: Colors.white, fontSize: cellSize * 0.3),
                      )),
                      value: cell == 0
                          ? 0
                          : (cell - (rowIndex * 4 + columnIndex + 1)) / 15.0,
                      maxSurfaceOffset:
                          _angle2Offset(widget.angle, cellSize * 0.2),
                      padding: cellSize * 0.1,
                      onChanged: () {
                        widget.onClickCell(rowIndex, columnIndex);
                      },
                      surfaceColor: widget.surfaceColor,
                    ))))
            .expand((e) => e)
            .toList(),
      );
    });
  }
}

SurfaceOffset _angle2Offset(int angle, maxOffset) {
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
