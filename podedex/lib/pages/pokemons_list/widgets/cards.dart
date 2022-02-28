import 'package:flutter/material.dart';
import 'package:podedex/constants/colors.dart';

import '../../../domain/entities/pokemon.dart';
import 'simple_widgets.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon _pokemon;
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

class CustomCard extends StatelessWidget {
  final Widget header;
  final Widget title;
  final Widget subtitle;
  final Widget footer;
  final double height;
  final EdgeInsets bodyPadding;
  final EdgeInsets headerPadding;
  final MainAxisAlignment bodyVerticalAlignment;
  final CrossAxisAlignment bodyHorizontalAlignment;

  const CustomCard({
    required this.header,
    required this.title,
    required this.subtitle,
    required this.footer,
    this.height = 186,
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
                  _wrappeInDefaultTextStyle(subtitle),
                  _wrappeInDefaultTextStyle(
                      title, 15, FontWeight.w600, const Color(0xDE000000)),
                  const Expanded(child: SizedBox()),
                  _wrappeInDefaultTextStyle(footer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrappeInDefaultTextStyle(
    Widget child, [
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    Color textColor = grey,
  ]) =>
      DefaultTextStyle(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
        child: child,
      );
}
