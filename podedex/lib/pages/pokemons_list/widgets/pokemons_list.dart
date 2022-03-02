import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podedex/pages/core_widgets.dart';
import '../../../domain/data_sources/favorite_pokemons_cache_store.dart';
import '../../pokemon_details/bloc/pokemon_details_bloc.dart';
import '../../pokemon_details/pokemon_details_page.dart';
import '../../../domain/entities/pokemon.dart';
import '../bloc/pokemons_list_bloc.dart';
import '../bloc/pokemons_list_state.dart';
import 'cards.dart';

class PokemonsList extends StatefulWidget {
  final PokemonsListBloc _pokemonsListBloc;
  final PagingController<int, Pokemon> _pagingController;

  const PokemonsList(this._pokemonsListBloc, this._pagingController, {Key? key})
      : super(key: key);

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

  late final pagedChildBulder = PagedChildBuilderDelegate<Pokemon>(
    itemBuilder: (context, pokemon, index) => InkWell(
      child: PokemonCard(pokemon, fixedHeight: 300),
      onTap: () => _navigateToPokemonDetails(pokemon),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async => _pagingController.refresh(),
      child: screenWidth < 300
          ? PagedListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              pagingController: _pagingController,
              builderDelegate: pagedChildBulder)
          : PagedGridView(
              showNewPageErrorIndicatorAsGridChild: false,
              showNewPageProgressIndicatorAsGridChild: false,
              showNoMoreItemsIndicatorAsGridChild: false,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              pagingController: _pagingController,
              builderDelegate: pagedChildBulder,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: _getMaxCellWidth(screenWidth),
                childAspectRatio: 110 / 186,
              ),
            ),
    );
  }

  double _getMaxCellWidth(double screenWidth) {
    if (screenWidth > 1200) {
      return 350;
    }
    if (screenWidth > 768) {
      return 250;
    }
    return 200;
  }

  void _navigateToPokemonDetails(Pokemon pokemon) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return AdaptiveTextSizeScope(
          child: PokemonDetailsPage(
            pokemon,
            PokemonDetailsBloc(FavoritePokemonsCacheStore.instance, pokemon.id),
          ),
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
