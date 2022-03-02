import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/colors.dart';
import '../core_widgets.dart';
import 'bloc/pokemon_details_bloc.dart';
import 'bloc/pokemon_details_sate.dart';
import 'widgets.dart';
import '../../domain/entities/pokemon.dart';

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon _pokemon;
  final PokemonDetailsBloc _bloc;
  const PokemonDetailsPage(this._pokemon, this._bloc, {Key? key})
      : super(key: key);

  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  late final pokemon = widget._pokemon;
  late final bloc = widget._bloc;
  Color headerBackgroundColor = Colors.transparent;
  late final pokemonStats = pokemon.statsAsMap().entries;
  bool isFavorite = false;
  StreamSubscription? stateStreamSubscription;

  late final scaleFactor = MediaQuery.of(context).textScaleFactor;

  late final isNotFavoriteButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
    padding: EdgeInsets.all(16 * scaleFactor),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    elevation: 10,
  );

  late final isFavoriteButtonStyle = TextButton.styleFrom(
    backgroundColor: const Color(0xFFD5DEFF),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
    padding: EdgeInsets.all(16 * scaleFactor),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    elevation: 10,
  );

  @override
  void initState() {
    super.initState();
    stateStreamSubscription = bloc.stateStream.listen(updateState);
  }

  void updateState(PokemonDetailsState newState) {
    setState(() => isFavorite = newState.isFavorite);
    if (newState.error != null) {
      _showSnakBar(newState.error!.message);
    }
  }

  void _showSnakBar(String messge) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messge)));
  }

  void _updateHeaderBackgroundColor(Color newColor) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() => headerBackgroundColor = newColor);
    });
  }

  @override
  void dispose() {
    stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: headerBackgroundColor.withOpacity(1),
            expandedHeight:
                216 + _PokemonCharacteristics.height + kToolbarHeight,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                color: Colors.white,
                height: 216 + _PokemonCharacteristics.height + kToolbarHeight,
                child: Stack(
                  children: [
                    Positioned(
                      right: -55,
                      bottom: 62,
                      child: SvgPicture.asset(
                        "assets/images/pokemon_icon.svg",
                        color: headerBackgroundColor.withAlpha(80),
                        width: 175,
                      ),
                    ),
                    ImageDominantColor(
                      Image.network(
                        pokemon.imageUrl,
                        alignment: Alignment.bottomRight,
                        cacheHeight: 150,
                        cacheWidth: 150,
                        width: 150,
                        height: 150,
                      ),
                      imagePadding:
                          const EdgeInsets.only(right: 5, bottom: 68.5),
                      onDominantColorPicked: _updateHeaderBackgroundColor,
                    ),
                    _PokemonInfo(pokemon: pokemon),
                    _PokemonCharacteristics(pokemon: pokemon),
                  ],
                ),
              ),
            ),
            leading: const BackButton(color: darkBlue),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: const Text(
                "Base Stats",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PokemonStat(pokemonStats.elementAt(index)),
              childCount: pokemonStats.length,
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: AnimatedSize(
          // TODO fix: animation.
          duration: const Duration(milliseconds: 300),
          child: TextButton(
            onPressed: bloc.toggleFavoriteSate,
            child: Text(
                isFavorite ? "Remove from favourites" : "Mark as favourite"),
            style:
                isFavorite ? isFavoriteButtonStyle : isNotFavoriteButtonStyle,
          ),
        ),
      ),
    );
  }
}

class _PokemonInfo extends StatelessWidget {
  static const _smallTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

  final Pokemon pokemon;
  const _PokemonInfo({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16, bottom: 92, top: kToolbarHeight * 1.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pokemon.name,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          Text(pokemon.typesAsString, style: _smallTextStyle),
          const Expanded(child: SizedBox()),
          Text(pokemon.formatedId, style: _smallTextStyle),
        ],
      ),
    );
  }
}

class _PokemonCharacteristics extends StatelessWidget {
  static const height = 78.0;
  final Pokemon pokemon;

  const _PokemonCharacteristics({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.only(left: 16),
        color: Colors.white,
        height: height,
        child: Row(
          children: [
            PokemonCharacteristic(
              name: "Height",
              value: pokemon.height,
            ),
            const SizedBox(width: 48),
            PokemonCharacteristic(
              name: "Weight",
              value: pokemon.weight,
            ),
            const SizedBox(width: 48),
            PokemonCharacteristic(
              name: "BMI",
              value: pokemon.bmi,
            ),
          ],
        ),
      ),
    );
  }
}

extension on Pokemon {
  Map<String, num> statsAsMap() => {
        "Hp": hp,
        "Attack": attack,
        "Defense": defense,
        "Special Attack": specialAttack,
        "Special Defense": specialDefense,
        "Speed": speed,
        "Avg. Power": avgPower,
      };
}
