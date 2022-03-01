import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../domain/data_sources/favorite_pokemons_cache_store.dart';
import '../../pokemon_details/bloc/pokemon_details_bloc.dart';
import '../../pokemon_details/pokemon_details_page.dart';
import '../../../domain/entities/pokemon.dart';
import '../bloc/pokemons_list_bloc.dart';
import '../bloc/pokemons_list_state.dart';
import 'cards.dart';

class PokemonsList extends StatefulWidget {
  final PokemonsListBloc _pokemonsListBloc;
  final _pagingController = PagingController<int, Pokemon>(
    firstPageKey: 0,
  );
  PokemonsList(this._pokemonsListBloc, {Key? key}) : super(key: key) {
    _pokemonsListBloc.addOndisposeListener(_pagingController.dispose);
  }

  @override
  _PokemonsListState createState() => _PokemonsListState();
}

class _PokemonsListState extends State<PokemonsList> {
  late final PagingController<int, Pokemon> _pagingController =
      widget._pagingController;
  StreamSubscription? _listStateSubscription;
  late final _bloc = widget._pokemonsListBloc;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_bloc.nextPageRequestsSink.add);
    _listStateSubscription = _bloc.pokemonsListStatesStream.listen(updateState);
  }

  void updateState(PokemonsListState pokemonsListState) {
    if (pokemonsListState.currentPageNumber != -1) {
      _pagingController.value = pokemonsListState.toPagingState();
    }
  }

  @override
  void dispose() {
    _listStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return PagedGridView(
      showNewPageErrorIndicatorAsGridChild: false,
      showNewPageProgressIndicatorAsGridChild: false,
      showNoMoreItemsIndicatorAsGridChild: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Pokemon>(
        itemBuilder: (context, pokemon, index) => InkWell(
          child: PokemonCard(pokemon),
          onTap: () => _navigateToPokemonDetails(pokemon),
        ),
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: screenWidth > 1200
            ? 350
            : screenWidth > 768
                ? 250
                : 150,
        childAspectRatio: 110 / 186,
      ),
    );
  }

  void _navigateToPokemonDetails(Pokemon pokemon) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return PokemonDetailsPage(
          pokemon,
          PokemonDetailsBloc(FavoritePokemonsCacheStore.instance, pokemon.id),
        );
      }),
    );
  }
}

extension on PokemonsListState {
  PagingState<int, Pokemon> toPagingState() => PagingState(
        nextPageKey: lastPageLoaded ? null : currentPageNumber + 1,
        itemList: pokemonsList,
        error: error,
      );
}
