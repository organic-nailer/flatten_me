import 'dart:math';

import 'package:flutter/material.dart';

class StrokeDepthButton extends StatefulWidget {
  final double radius;
  final Duration duration;
  final SurfaceOffset maxSurfaceOffset;
  final double padding;
  final Widget child;
  final Tween<Color?> surfaceColor;
  final Color? surfaceOverrideColor;
  final MaterialColor sideColor;
  final Curve curve;

  /// Button depth. only -1.0 ~ 1.0 is valid.
  final double value;
  final VoidCallback? onChanged;

  const StrokeDepthButton(
      {Key? key,
      this.value = 1.0,
      this.onChanged,
      this.radius = 15,
      this.duration = const Duration(seconds: 1),
      this.maxSurfaceOffset = const SurfaceOffset(10, 10),
      this.padding = 10,
      required this.child,
      required this.surfaceColor,
      this.surfaceOverrideColor,
      this.sideColor = Colors.grey,
      this.curve = Curves.easeInOut})
      : super(key: key);

  @override
  State<StrokeDepthButton> createState() => StrokeDepthButtonState();
}

class StrokeDepthButtonState extends State<StrokeDepthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double depthForController() => (-0.5 * widget.value + 0.5).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    // 凹: 1.0 <-> 凸: 0.0
    _controller = AnimationController(
        vsync: this, duration: widget.duration, value: depthForController());
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void didUpdateWidget(covariant StrokeDepthButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.animateTo(depthForController(),
          duration: widget.duration, curve: widget.curve);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged?.call();
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final rectWidth = constraints.biggest.width;
        final rectHeight = constraints.biggest.height;
        final buttonWidth = rectWidth - widget.padding * 2;
        final buttonHeight = rectHeight - widget.padding * 2;
        final overhang = max(
            0.0,
            max(widget.maxSurfaceOffset.dx.abs(),
                    widget.maxSurfaceOffset.dy.abs()) -
                widget.padding);
        final theta = widget.maxSurfaceOffset.nTheta();
        return ClipPath(
          // 凹んだときはみ出さないようにするClip
          clipper: _SingleCornerClipper(
              theta, widget.padding, widget.radius, overhang),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 背景部分
              // というか凹凸時の壁のベース
              Positioned(
                top: widget.padding,
                left: widget.padding,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius),
                  child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final isDenting = _animation.value >= 0.5;
                        return DecoratedBox(
                          decoration: createSideDecoration(
                              isDenting, theta, buttonHeight, buttonWidth),
                          child: SizedBox(
                            width: buttonWidth,
                            height: buttonHeight,
                          ),
                        );
                      }),
                ),
              ),
              // 背景の斜め部分
              // 背景だけでカバーできない部分をこれで
              Positioned(
                top: -overhang,
                left: -overhang,
                child: CustomPaint(
                  painter: SideHelpPainter(
                      widget.padding + overhang,
                      widget.maxSurfaceOffset,
                      widget.radius,
                      widget.sideColor,
                      _animation),
                  child: SizedBox(
                    width: rectWidth + 2 * overhang,
                    height: rectHeight + 2 * overhang,
                  ),
                ),
              ),
              // 前景部分
              PositionedTransition(
                rect: _animation.drive(RelativeRectTween(
                  begin: RelativeRect.fromSize(
                      Rect.fromLTWH(
                          widget.padding + widget.maxSurfaceOffset.dx,
                          widget.padding - widget.maxSurfaceOffset.dy,
                          buttonWidth,
                          buttonHeight),
                      constraints.biggest),
                  end: RelativeRect.fromSize(
                      Rect.fromLTWH(
                          widget.padding - widget.maxSurfaceOffset.dx,
                          widget.padding + widget.maxSurfaceOffset.dy,
                          buttonWidth,
                          buttonHeight),
                      constraints.biggest),
                )),
                child: AnimatedBuilder(
                    animation: _animation,
                    child: widget.child,
                    builder: (context, child) {
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: widget.surfaceOverrideColor ??
                                widget.surfaceColor.transform(_animation.value),
                            borderRadius: BorderRadius.all(
                                Radius.circular(widget.radius))),
                        width: buttonWidth,
                        height: buttonHeight,
                        child: child,
                      );
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }

  BoxDecoration createSideDecoration(
      bool isDenting, double theta, double height, double width) {
    final nTheta = theta - (theta / 2 / pi).floor() * 2 * pi;
    final colors = <Color>[widget.sideColor, widget.sideColor.shade700];
    final diagonalLength = 2 * height * sin(pi / 2 - nTheta).abs();
    final List<double> stops = [
      0.5 - widget.radius * sin(pi / 2 - nTheta).abs() / diagonalLength,
      0.5 + widget.radius * cos(pi / 2 - nTheta).abs() / diagonalLength,
    ];
    final Alignment beginAlignment, endAlignment;
    if (nTheta <= pi / 2) {
      if (isDenting) {
        beginAlignment = alignmentNonNeg(1, 1);
        endAlignment = alignmentNonNeg(
            (width - height * sin(2 * nTheta)) / width, -cos(2 * nTheta));
      } else {
        beginAlignment = alignmentNonNeg(0, 0);
        endAlignment = alignmentNonNeg(
            height / width * sin(2 * nTheta), 1 + cos(2 * nTheta));
      }
    } else if (nTheta <= pi) {
      if (isDenting) {
        beginAlignment = alignmentNonNeg(0, 1);
        endAlignment = alignmentNonNeg(
            -height / width * sin(2 * nTheta), -cos(2 * nTheta));
      } else {
        beginAlignment = alignmentNonNeg(1, 0);
        endAlignment = alignmentNonNeg(
            (width + height * sin(2 * nTheta)) / width, 1 + cos(2 * nTheta));
      }
    } else if (nTheta <= pi * 3 / 2) {
      if (isDenting) {
        beginAlignment = alignmentNonNeg(0, 0);
        endAlignment = alignmentNonNeg(
            height / width * sin(2 * nTheta), 1 + 1 * cos(2 * nTheta));
      } else {
        beginAlignment = alignmentNonNeg(1, 1);
        endAlignment = alignmentNonNeg(
            (width - height * sin(2 * nTheta)) / width, -cos(2 * nTheta));
      }
    } else {
      if (isDenting) {
        beginAlignment = alignmentNonNeg(1, 0);
        endAlignment = alignmentNonNeg(
            (width + height * sin(2 * nTheta)) / width,
            1 + 1 * cos(2 * nTheta));
      } else {
        beginAlignment = alignmentNonNeg(0, 1);
        endAlignment = alignmentNonNeg(
            -height / width * sin(2 * nTheta), -cos(2 * nTheta));
      }
    }
    // final stops = [
    //   0.5 - widget.radius / 2 / min(height, width),
    //   0.5 + widget.radius / 2 / min(height, width),
    // ];
    // if (isDenting) {
    //   gradient = LinearGradient(
    //       begin: Alignment(max((0.5 - height / width) * 2, -1), -1),
    //       end: Alignment(1, min((width / height - 0.5) * 2, 1)),
    //       colors: colors,
    //       stops: stops);
    // } else {
    //   gradient = LinearGradient(
    //       begin: Alignment(-1, max((0.5 - width / height) * 2, -1)),
    //       end: Alignment(min((height / width - 0.5) * 2, 1), 1),
    //       colors: colors,
    //       stops: stops);
    // }
    return BoxDecoration(
        gradient: LinearGradient(
      begin: beginAlignment,
      end: endAlignment,
      colors: colors,
      stops: stops,
    ));
  }
}

/// 斜めの部分
class SideHelpPainter extends CustomPainter {
  final double padding;
  final SurfaceOffset maxSurfaceOffset;
  final double rectRadius;
  final MaterialColor color;
  final Animation<double> listenable;

  SideHelpPainter(this.padding, this.maxSurfaceOffset, this.rectRadius,
      this.color, this.listenable)
      : super(repaint: listenable);
  @override
  void paint(Canvas canvas, Size size) {
    // 凹の場合は描画しない
    if (listenable.value >= 0.5) return;

    final nTheta = maxSurfaceOffset.nTheta();
    final SurfaceOffset offset;
    if (nTheta <= pi / 2) {
      offset = SurfaceOffset(maxSurfaceOffset.dx, maxSurfaceOffset.dy);
    } else if (nTheta <= pi) {
      offset = SurfaceOffset(-maxSurfaceOffset.dx, maxSurfaceOffset.dy);
    } else if (nTheta <= pi * 3 / 2) {
      offset = SurfaceOffset(maxSurfaceOffset.dx, maxSurfaceOffset.dy);
    } else {
      offset = SurfaceOffset(-maxSurfaceOffset.dx, maxSurfaceOffset.dy);
    }
    final rOffsetX = (1 - sin(offset.nTheta()).abs()) * rectRadius;
    final rOffsetY = (1 - cos(offset.nTheta()).abs()) * rectRadius;
    // 平: 1.0 <-> 凸: 0.0
    final currentPosition = listenable.value * 2;
    var colors = [color, color.shade700];
    if (nTheta > pi / 2 && nTheta <= pi * 3 / 2) {
      colors = colors.reversed.toList();
    }
    final paint = Paint()
      ..shader = LinearGradient(colors: colors, stops: const [0.49, 0.51])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    // 左 -> 上 -> 右 -> 下
    final path = Path()
      ..moveTo(padding + rOffsetX, padding + rOffsetY)
      ..lineTo(padding + rOffsetX + offset.dx * (1 - currentPosition),
          padding + rOffsetY - offset.dy * (1 - currentPosition))
      ..lineTo(
          size.width - padding - rOffsetX + offset.dx * (1 - currentPosition),
          size.height - padding - rOffsetY - offset.dy * (1 - currentPosition))
      ..lineTo(
          size.width - padding - rOffsetX, size.height - padding - rOffsetY)
      ..close();
    if ((nTheta > pi / 2 && nTheta <= pi) || (nTheta > pi * 3 / 2)) {
      final mat = Matrix4.translationValues(size.width / 2, 0, 0) *
          Matrix4.rotationY(pi) *
          Matrix4.translationValues(-size.width / 2, 0, 0);
      canvas.drawPath(path.transform(mat.storage), paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 指定した角の部分を切り取る
class _SingleCornerClipper extends CustomClipper<Path> {
  final double theta;

  /// The offset of the corner
  final double offset;

  /// The radius of the corner
  final double radius;

  /// 角の反対側ではみ出す可能性のある幅
  ///
  /// 指定しないとボタンが凸のとき不意にClipされる可能性がある
  final double safeMargin;
  const _SingleCornerClipper(
      this.theta, this.offset, this.radius, this.safeMargin);

  @override
  Path getClip(Size size) {
    // 0~2pi
    final nTheta = theta - (theta / 2 / pi).floor() * 2 * pi;
    final rect = Rect.fromLTRB(
        nTheta <= pi / 2 || nTheta > pi * 3 / 2
            ? offset + (1 - sin(nTheta).abs()) * radius
            : -safeMargin,
        nTheta > pi ? offset + (1 - cos(nTheta).abs()) * radius : -safeMargin,
        nTheta > pi / 2 && nTheta <= pi * 3 / 2
            ? size.width - offset - (1 - sin(nTheta).abs()) * radius
            : size.width + safeMargin,
        nTheta <= pi
            ? size.height - offset - (1 - cos(nTheta).abs()) * radius
            : size.height + safeMargin);
    return Path()
      ..addRRect(RRect.fromLTRBR(offset, offset, size.width - offset,
          size.height - offset, Radius.circular(radius)))
      ..addRect(rect);
    // return Path()
    //   ..addRRect(RRect.fromRectAndCorners(
    //     Rect.fromLTWH(
    //         corner == _Corner.topLeft || corner == _Corner.bottomLeft
    //             ? offset
    //             : -safeMargin,
    //         corner == _Corner.topLeft || corner == _Corner.topRight
    //             ? offset
    //             : -safeMargin,
    //         size.width - offset + safeMargin,
    //         size.height - offset + safeMargin),
    //     bottomLeft: corner == _Corner.bottomLeft
    //         ? Radius.circular(radius)
    //         : Radius.zero,
    //     topLeft:
    //         corner == _Corner.topLeft ? Radius.circular(radius) : Radius.zero,
    //     bottomRight: corner == _Corner.bottomRight
    //         ? Radius.circular(radius)
    //         : Radius.zero,
    //     topRight:
    //         corner == _Corner.topRight ? Radius.circular(radius) : Radius.zero,
    //   ));
  }

  @override
  bool shouldReclip(covariant _SingleCornerClipper oldClipper) => true;
}

class SurfaceOffset extends Offset {
  const SurfaceOffset(double dx, double dy) : super(dx, dy);
  double theta() {
    if (dx == 0) {
      return dy >= 0 ? pi / 2 : -pi / 2;
    }
    if (dx > 0) {
      return atan(dy / dx);
    }
    return atan(dy / dx) + pi;
  }

  double nTheta() {
    final t = theta();
    return t - (t / 2 / pi).floor() * 2 * pi;
  }
}

/// x=0: 左, x=1: 右, y=0: 上, y=1: 下
Alignment alignmentNonNeg(double x, double y) {
  return Alignment((x - 0.5) * 2, (y - 0.5) * 2);
}
