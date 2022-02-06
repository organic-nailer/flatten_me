import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';

class ColorSelector extends StatefulWidget {
  final List<ColorPreset> presets;
  final int value;
  final ValueChanged<int>? onChanged;
  const ColorSelector(
      {Key? key, required this.presets, required this.value, this.onChanged})
      : super(key: key);

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  final controller = CarouselController();

  @override
  void didUpdateWidget(covariant ColorSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      controller.animateToPage(widget.value,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.presets[widget.value].name,
              style: Theme.of(context).textTheme.headline5),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return CarouselSlider.builder(
              options: CarouselOptions(
                  aspectRatio: 3 / 4,
                  viewportFraction: constraints.biggest.height /
                      constraints.biggest.width *
                      3 /
                      4,
                  height: 200,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, _) {
                    if (index != widget.value) {
                      widget.onChanged?.call(index);
                    }
                  }),
              carouselController: controller,
              itemCount: widget.presets.length,
              itemBuilder: (context, index, current) {
                return Transform.scale(
                    scale: index == widget.value ? 1 : 0.8,
                    child: ColorCard(
                      preset: widget.presets[index],
                      onTap: () {
                        widget.onChanged?.call(index);
                      },
                    ));
              },
            );
          }),
        ),
      ],
    );
  }
}

class ColorCard extends StatelessWidget {
  final ColorPreset preset;
  final VoidCallback? onTap;
  const ColorCard({Key? key, required this.preset, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 3 / 4,
        child: LayoutBuilder(builder: (context, constraints) {
          final height = constraints.biggest.height;
          final width = constraints.biggest.width;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width * 0.05),
              color: Colors.white12,
            ),
            child: InkWell(
              onTap: () {
                onTap?.call();
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: height / 4,
                    width: width * 0.6,
                    decoration: BoxDecoration(
                        color: preset.highColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.05))),
                  ),
                  Container(
                    height: height / 3,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        color: preset.baseColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.05))),
                  ),
                  Container(
                    height: height / 4,
                    width: width * 0.6,
                    decoration: BoxDecoration(
                        color: preset.lowColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.05))),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

class ColorPreset {
  final Color baseColor, highColor, lowColor;
  final String name;
  const ColorPreset(
    this.baseColor,
    this.highColor,
    this.lowColor,
    this.name,
  );

  Tween<Color> getTween() {
    return RainbowColorTween([
      highColor,
      baseColor,
      lowColor,
    ]);
  }
}
