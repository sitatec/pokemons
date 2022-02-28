import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

import '../../../domain/entities/pokemon.dart';
import 'simple_widgets.dart';

/// A Pokemon Card
///
/// A Card that show a sommary of a [Pokemon] (image, name, types and id).
class PokemonCard extends StatelessWidget {
  final Pokemon _pokemon;

  /// Construct a [PokemonCard] for the given [_pokemon].
  const PokemonCard(this._pokemon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      bodyPadding: const EdgeInsets.all(10),
      header: ImageDominantColor(
        Image.network(_pokemon.imageUrl),
        imagePadding: const EdgeInsets.all(8),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(_pokemon.name),
      ),
      subtitle: Text(_pokemon.formatedId),
      footer: Text(_pokemon.typesAsString),
    );
  }
}

/// A generic card that divide its content in two part the:
///
/// - The [header] (Ideal for showing an image) takes 58% of the height of the card.
/// - And the body which conatains the [title], [subtitle], and [footer].
///   It takes 42% of the height of the card.
class CustomCard extends StatelessWidget {
  final Widget header;
  final Widget title;
  final Widget subtitle;
  final Widget footer;

  /// Default to `MainAxisAlignment.start`
  final MainAxisAlignment bodyVerticalAlignment;

  /// Default to `[CrossAxisAlignment.start]
  final CrossAxisAlignment bodyHorizontalAlignment;

  /// Default to `EdgeInsets.zero`.
  final EdgeInsets bodyPadding;

  /// Default to `EdgeInsets.zero`.
  final EdgeInsets headerPadding;

  /// Create a [CustomCard].
  const CustomCard({
    required this.header,
    required this.title,
    required this.subtitle,
    required this.footer,
    this.bodyPadding = EdgeInsets.zero,
    this.headerPadding = EdgeInsets.zero,
    this.bodyHorizontalAlignment = CrossAxisAlignment.start,
    this.bodyVerticalAlignment = MainAxisAlignment.start,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 58,
            child: Container(
              width: double.infinity,
              padding: headerPadding,
              child: header,
            ),
          ),
          Expanded(
            flex: 42,
            child: Padding(
              padding: bodyPadding,
              child: Column(
                mainAxisAlignment: bodyVerticalAlignment,
                crossAxisAlignment: bodyHorizontalAlignment,
                children: [
                  _DefaultSmallTextStyle(subtitle),
                  DefaultTextStyle(
                    child: title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xDE000000),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  _DefaultSmallTextStyle(footer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultSmallTextStyle extends StatelessWidget {
  final Widget child;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  const _DefaultSmallTextStyle(
    this.child, {
    Key? key,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w400,
    this.textColor = grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
      ),
      child: child,
    );
  }
}
