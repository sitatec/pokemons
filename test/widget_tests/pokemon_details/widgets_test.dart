import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podedex/constants/colors.dart';
import 'package:podedex/pages/pokemon_details/widgets.dart';

void main() {
  testWidgets("PokemonStat should display the given stat", (tester) async {
    const stat = MapEntry("Attack", 45);
    await tester.pumpWidget(
      const MaterialApp(home: Material(child: PokemonStat(stat))),
    );
    expect(find.text(stat.key), findsOneWidget);
    expect(find.text(stat.value.toString()), findsOneWidget);
    expect(tester.firstWidget<Slider>(find.byType(Slider)).value, stat.value);
  });

  testWidgets("The Active color of the PokemonStat should be red",
      (tester) async {
    const stat = MapEntry("Attack", 45);
    await tester.pumpWidget(
      const MaterialApp(home: Material(child: PokemonStat(stat))),
    );

    expect(
      tester.firstWidget<Slider>(find.byType(Slider)).activeColor,
      lightRed,
    );
  });

  testWidgets("The Active color of the PokemonStat should be yellow",
      (tester) async {
    const stat = MapEntry("Attack", 70);
    await tester.pumpWidget(
      const MaterialApp(home: Material(child: PokemonStat(stat))),
    );

    expect(
      tester.firstWidget<Slider>(find.byType(Slider)).activeColor,
      lightYellow,
    );
  });

  testWidgets("The Active color of the PokemonStat should be green",
      (tester) async {
    const stat = MapEntry("Attack", 130);
    await tester.pumpWidget(
      const MaterialApp(home: Material(child: PokemonStat(stat))),
    );

    expect(
      tester.firstWidget<Slider>(find.byType(Slider)).activeColor,
      Colors.green.withAlpha(200),
    );
  });

  testWidgets("PokemonCharacteristic should display the given Characteristic",
      (tester) async {
    const name = "Height";
    const value = 7;
    await tester.pumpWidget(
      const MaterialApp(home: PokemonCharacteristic(name: name, value: value)),
    );
    expect(find.text(name), findsOneWidget);
    expect(find.text(value.toString()), findsOneWidget);
  });
}
