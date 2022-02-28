import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../domain/entities/pokemon.dart';
import '../bloc/pokemons_list_bloc.dart';
import '../bloc/pokemons_list_state.dart';
import 'cards.dart';

class PokemonsList extends StatefulWidget {
  final PokemonsListBloc _pokemonsListBloc;
  const PokemonsList(this._pokemonsListBloc, {Key? key}) : super(key: key);

  @override
  _PokemonsListState createState() => _PokemonsListState();
}

class _PokemonsListState extends State<PokemonsList> {
  final _pagingController = PagingController<int, Pokemon>(firstPageKey: 0);
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
    _pagingController.dispose();
    _listStateSubscription?.cancel();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView(
      showNewPageErrorIndicatorAsGridChild: false,
      showNewPageProgressIndicatorAsGridChild: false,
      showNoMoreItemsIndicatorAsGridChild: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Pokemon>(
        itemBuilder: (context, pokemon, index) => PokemonCard(pokemon),
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 110 / 186,
      ),
    );
  }
}

extension on PokemonsListState {
  PagingState<int, Pokemon> toPagingState() => PagingState(
        nextPageKey: currentPageNumber + 1,
        itemList: pokemonsList,
        error: error,
      );
}
