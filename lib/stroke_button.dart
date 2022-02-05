import 'dart:math';

import 'package:flutter/material.dart';

class StrokeButton extends StatefulWidget {
  final double radius;
  final Duration duration;
  final double offsetForProjection;
  final Widget child;
  final Tween<Color?> surfaceColor;
  final MaterialColor sideColor;
  final Curve curve;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const StrokeButton(
      {Key? key,
      this.value = false,
      this.onChanged,
      this.radius = 15,
      this.duration = const Duration(seconds: 1),
      this.offsetForProjection = 10,
      required this.child,
      required this.surfaceColor,
      this.sideColor = Colors.grey,
      this.curve = Curves.easeInOut})
      : super(key: key);

  @override
  State<StrokeButton> createState() => StrokeButtonState();
}

class StrokeButtonState extends State<StrokeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
        value: widget.value ? 1.0 : 0.0);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    // _controller.addListener(() {
    //   print(_controller.value);
    // });
  }

  @override
  void didUpdateWidget(covariant StrokeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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
        widget.onChanged?.call(!widget.value);
        // setState(() {
        //   isDented = !isDented;
        //   if (isDented) {
        //     _controller.forward();
        //   } else {
        //     _controller.reverse();
        //   }
        // });
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final rectWidth = constraints.biggest.width;
        final rectHeight = constraints.biggest.height;
        final buttonWidth = rectWidth - widget.offsetForProjection * 2;
        final buttonHeight = rectHeight - widget.offsetForProjection * 2;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: widget.offsetForProjection,
              left: widget.offsetForProjection,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.radius),
                child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final isDenting = _animation.value >= 0.5;
                      return DecoratedBox(
                        decoration: createSideDecoration(
                            isDenting, buttonHeight, buttonWidth),
                        child: SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                        ),
                      );
                    }),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: SideHelpPainter(widget.offsetForProjection,
                    widget.radius, widget.sideColor, _animation),
                child: SizedBox(
                  width: rectWidth,
                  height: rectHeight,
                ),
              ),
            ),
            PositionedTransition(
              rect: _animation.drive(RelativeRectTween(
                begin: RelativeRect.fromSize(
                    Rect.fromLTWH(widget.offsetForProjection * 2, 0,
                        buttonWidth, buttonHeight),
                    constraints.biggest),
                end: RelativeRect.fromSize(
                    Rect.fromLTWH(0, widget.offsetForProjection * 2,
                        buttonWidth, buttonHeight),
                    constraints.biggest),
              )),
              child: ClipPath(
                clipper: SideClipper(
                    widget.offsetForProjection, widget.radius, _animation),
                child: AnimatedBuilder(
                    animation: _animation,
                    child: widget.child,
                    builder: (context, child) {
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color:
                                widget.surfaceColor.transform(_animation.value),
                            borderRadius: BorderRadius.all(
                                Radius.circular(widget.radius))),
                        width: buttonWidth,
                        height: buttonHeight,
                        child: child,
                      );
                    }),
              ),
            ),
          ],
        );
      }),
    );
  }

  BoxDecoration createSideDecoration(
      bool isDenting, double height, double width) {
    final colors = <Color>[widget.sideColor, widget.sideColor.shade700];
    final stops = [
      0.5 - widget.radius / 2 / min(height, width),
      0.5 + widget.radius / 2 / min(height, width),
    ];
    final LinearGradient gradient;
    if (isDenting) {
      gradient = LinearGradient(
          begin: Alignment(max((0.5 - height / width) * 2, -1), -1),
          end: Alignment(1, min((width / height - 0.5) * 2, 1)),
          colors: colors,
          stops: stops);
    } else {
      gradient = LinearGradient(
          begin: Alignment(-1, max((0.5 - width / height) * 2, -1)),
          end: Alignment(min((height / width - 0.5) * 2, 1), 1),
          colors: colors,
          stops: stops);
    }
    return BoxDecoration(gradient: gradient);
  }
}

class SideHelpPainter extends CustomPainter {
  final double offsetForProjection;
  final double rectRadius;
  final MaterialColor color;
  final Animation<double> listenable;
  double rOffset = 0;
  SideHelpPainter(
      this.offsetForProjection, this.rectRadius, this.color, this.listenable)
      : super(repaint: listenable) {
    rOffset = (1 - 1 / sqrt(2)) * rectRadius;
  }
  @override
  void paint(Canvas canvas, Size size) {
    if (listenable.value >= 0.5) return;
    final currentPosition = listenable.value * 2;
    final paint = Paint()
      ..shader = LinearGradient(
              colors: [color, color.shade700], stops: const [0.49, 0.51])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final path = Path()
      ..moveTo(offsetForProjection + rOffset, offsetForProjection + rOffset)
      ..lineTo(offsetForProjection * (2 - currentPosition) + rOffset,
          rOffset + offsetForProjection * currentPosition)
      ..lineTo(size.width - offsetForProjection * currentPosition - rOffset,
          size.height - offsetForProjection * (2 - currentPosition) - rOffset)
      ..lineTo(size.width - offsetForProjection - rOffset,
          size.height - offsetForProjection - rOffset)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SideClipper extends CustomClipper<Path> {
  final double offsetForProjection;
  final double rectRadius;
  final Animation<double> listenable;
  double rOffset = 0;
  SideClipper(this.offsetForProjection, this.rectRadius, this.listenable)
      : super(reclip: listenable) {
    rOffset = (1 - 1 / sqrt(2)) * rectRadius;
  }
  @override
  Path getClip(Size size) {
    if (listenable.value <= 0.5) {
      return Path()
        ..addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(rectRadius)));
    }
    final dentingWidth = (listenable.value - 0.5) * 2 * offsetForProjection;
    return Path()
      ..addRRect(RRect.fromRectAndCorners(
          Rect.fromLTWH(dentingWidth, -dentingWidth, size.width, size.height),
          bottomLeft: Radius.circular(rectRadius),
          topLeft: Radius.circular(rectRadius),
          bottomRight: Radius.circular(rectRadius)));
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
