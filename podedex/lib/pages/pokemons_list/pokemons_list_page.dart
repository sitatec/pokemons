import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/data_sources/favorite_pokemons_cache_store.dart';
import '../../domain/data_sources/pokemons_remote_data_source.dart';
import 'bloc/pokemons_list_bloc.dart';
import 'widgets/pokemons_list.dart';
import '../../domain/data_sources/pokemon_repository.dart';
import 'widgets/simple_widgets.dart';

class PokemonsListPage extends StatelessWidget {
  PokemonsListPage({Key? key}) : super(key: key);
  final _pokemonsListBloc = PokemonsListBloc(PokemonRepository(
    PokemonsRemoteDataSource(),
    FavoritePokemonsCacheStore.instance,
  ));

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appTheme.appBarTheme.toolbarHeight!),
          child: const _AppBar(),
        ),
        body: Column(
          children: [
            const _TabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  PokemonsList(_pokemonsListBloc),
                  const Icon(Icons.directions_car)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: appTheme.appBarTheme.backgroundColor,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: appTheme.scaffoldBackgroundColor,
      ),
      title: const Brand(),
      centerTitle: true,
      elevation: 0,
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: appTheme.appBarTheme.backgroundColor,
      child: TabBar(
        labelColor: appTheme.colorScheme.onSurface,
        unselectedLabelColor: appTheme.colorScheme.onSurfaceVariant,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        indicator: RoundedTabIndicator(
          color: appTheme.primaryColor,
          radius: 4,
          indicatorHeight: 4,
        ),
        tabs: const [
          SizedBox(height: 50, child: Tab(child: Text("All Pokemons"))),
          _FavoriteTab()
        ],
      ),
    );
  }
}

class _FavoriteTab extends StatelessWidget {
  const _FavoriteTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Tab(
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Favourites"),
            const SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: appTheme.primaryColor,
              child: const Padding(
                padding: EdgeInsets.only(bottom: 1),
                child: Text("1", style: TextStyle(fontSize: 12)),
              ),
              minRadius: 9,
            )
          ],
        ),
      ),
    );
  }
}
