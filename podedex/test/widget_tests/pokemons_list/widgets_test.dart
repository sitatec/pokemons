import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podedex/domain/data_sources/utils/data_converters.dart';
import 'package:podedex/pages/pokemons_list/widgets/cards.dart';
import 'package:podedex/pages/pokemons_list/widgets/simple_widgets.dart';

import '../../unit_tests/domain/data_sources/fakes/fake_data.dart';

void main() {
  testWidgets(
    "PokemonCard should display the given pokemon's info, i.e name, types...",
    (widgetTester) async {
      final pokemon = pokemonfromJson(newFakePokemonJson);
      await mockNetworkImagesFor(() async {
        return widgetTester.pumpWidget(MaterialApp(home: PokemonCard(pokemon)));
      });

      await widgetTester.pumpAndSettle(const Duration(seconds: 20));

      expect(find.text(pokemon.name), findsOneWidget);
      expect(find.text(pokemon.formatedId), findsOneWidget);
      expect(find.text(pokemon.typesAsString), findsOneWidget);
    },
  );

  testWidgets("The App Brand should show the App name", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Brand()));
    expect(find.text("Pokedex"), findsOneWidget);
  });
}
