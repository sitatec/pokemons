import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class PokemonStat extends StatelessWidget {
  final MapEntry<String, num> stat;
  const PokemonStat(this.stat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Quantity(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      label: Padding(
        padding: EdgeInsets.only(right: stat.key.toLowerCase() == "hp" ? 4 : 8),
        child: Text(
          stat.key,
          style: const TextStyle(
            color: grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      quantity: stat.value.toDouble(),
    );
  }
}

class Quantity extends StatelessWidget {
  final Widget label;
  final double quantity;
  final double maxQuantity;
  final double minQuantity;
  final Color backgroundColor;
  final EdgeInsets padding;

  const Quantity({
    required this.label,
    required this.quantity,
    this.maxQuantity = 150,
    this.minQuantity = 0,
    this.backgroundColor = Colors.white,
    this.padding = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  double get validQuatity {
    if (quantity > maxQuantity) {
      return maxQuantity;
    }
    if (quantity < minQuantity) {
      return minQuantity;
    }
    return quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      color: backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              label,
              Text(
                quantity.toInt().toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              thumbShape: SliderComponentShape.noThumb,
              overlayShape: SliderComponentShape.noOverlay,
              trackShape: RoundedTrackShape(),
            ),
            child: Slider(
              value: validQuatity,
              onChanged: (_) {},
              min: minQuantity,
              max: maxQuantity,
              inactiveColor: lightGrey,
              activeColor: _getActiveColor(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActiveColor() {
    if (quantity < maxQuantity / 3) {
      return lightRed;
    }
    if (quantity < maxQuantity * 2 / 3) {
      return lightYellow;
    }
    return Colors.green.withAlpha(200);
  }
}

class PokemonCharacteristic extends StatelessWidget {
  final String name;
  final num value;

  const PokemonCharacteristic({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value.toInt().toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class RoundedTrackShape extends RoundedRectSliderTrackShape {
  // Customized version of the code from [RoundedRectSliderTrackShape.paint] in `flutter/lib/src/material/slider_theme.dart
  // to make the active slider track rounded in both sides.
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting  can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        topRight:
            (textDirection == TextDirection.ltr) ? trackRadius : Radius.zero,
        bottomRight:
            (textDirection == TextDirection.ltr) ? trackRadius : Radius.zero,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
        topLeft:
            (textDirection == TextDirection.rtl) ? trackRadius : Radius.zero,
        bottomLeft:
            (textDirection == TextDirection.rtl) ? trackRadius : Radius.zero,
      ),
      rightTrackPaint,
    );
  }
}
