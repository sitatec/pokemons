import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

/// A widget that set the text size of all of its descendants depending on the
/// screen size (large screen => big text).
class AdaptiveTextSizeScope extends StatelessWidget {
  final Widget child;
  final Map<int, double> configurations;
  const AdaptiveTextSizeScope({
    required this.child,
    this.configurations = const {
      1200: 1.5,
      768: 1.22,
      0: 1.1 // 0 means default.
    },
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appMediaQuery = MediaQuery.of(context);
    final textScaleFactor = getAdaptativeTextScaleFactor(
      appMediaQuery.size.width,
      appMediaQuery.textScaleFactor,
    );

    return MediaQuery(
      data: appMediaQuery.copyWith(textScaleFactor: textScaleFactor),
      child: child,
    );
  }

  double getAdaptativeTextScaleFactor(
    double deviceScreenWidth,
    double defaultValue,
  ) {
    final configScreenWidths = configurations.keys.toList()..sort();
    for (var configScreenWidth in configScreenWidths.reversed) {
      if (configScreenWidth <= deviceScreenWidth) {
        return configurations[configScreenWidth]!;
      }
    }
    return defaultValue;
  }
}

// ------------------- ImageDominantColor --------------------//

/// A widget that set its background color to the dominant color of the given
/// [Image].
class ImageDominantColor extends StatefulWidget {
  // TOOD find better widget name.

  /// The image on which to pick the dominant color.
  final Image image;
  final EdgeInsets imagePadding;

  /// The alpha to apply to the [image]'s dominant color before set it as the
  /// background. Default to `100`.
  final int colorAlpha;

  final void Function(Color)? onDominantColorPicked;

  /// Construct a [ImageDominantColor].
  const ImageDominantColor(
    this.image, {
    this.imagePadding = EdgeInsets.zero,
    this.colorAlpha = 50,
    this.onDominantColorPicked,
    Key? key,
  }) : super(key: key);

  @override
  _ImageDominantColorState createState() => _ImageDominantColorState();
}

class _ImageDominantColorState extends State<ImageDominantColor> {
  Color imageDominantColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaletteGenerator>(
      future: PaletteGenerator.fromImageProvider(widget.image.image),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final dominantColor = snapshot.data?.dominantColor?.color;
          if (dominantColor != null) {
            imageDominantColor = dominantColor.withAlpha(widget.colorAlpha);
            widget.onDominantColorPicked?.call(imageDominantColor);
          }
        }
        return Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.zero,
          padding: widget.imagePadding,
          color: imageDominantColor,
          child: widget.image,
        );
      }),
    );
  }
}

// ------------------- Brand --------------------//

/// The brand of the App i.e: Logo and Name.
class Brand extends StatelessWidget {
  /// Construct the App [Brand].
  const Brand({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/adaptative_app_icon.png",
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8),
        const Text(
          "Pokedex",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}

// ------------------- RoundedTabIndicator --------------------//

/// A Tab Indicator with the top corners rounded.
class RoundedTabIndicator extends Decoration {
  final BoxPainter _painter;

  /// Construct a [RoundedTabIndicator].
  RoundedTabIndicator({
    required Color color,
    required double radius,
    required double indicatorHeight,
    BoxPainter? boxPainter,
  }) : _painter =
            boxPainter ?? _SemiCirclePainter(color, radius, indicatorHeight);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _SemiCirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;
  final double indicatorHeight;

  _SemiCirclePainter(Color color, this.radius, this.indicatorHeight)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(
      Canvas canvas, Offset offset, ImageConfiguration imageConfiguration) {
    final Offset circleOffset =
        Offset(offset.dx, imageConfiguration.size!.height - indicatorHeight);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        circleOffset & Size(imageConfiguration.size!.width, indicatorHeight),
        topRight: Radius.circular(radius),
        topLeft: Radius.circular(radius),
      ),
      _paint,
    );
  }
}
