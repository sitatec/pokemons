import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../domain/data_sources/favorite_pokemons_cache_store.dart';
import '../../domain/data_sources/pokemons_remote_data_source.dart';
import '../../domain/entities/pokemon.dart';
import '../core_widgets.dart';
import 'bloc/pokemons_list_bloc.dart';
import 'widgets/pokemons_list.dart';
import '../../domain/data_sources/pokemon_repository.dart';

class PokemonsListPage extends StatefulWidget {
  const PokemonsListPage({Key? key}) : super(key: key);

  @override
  State<PokemonsListPage> createState() => _PokemonsListPageState();
}

class _PokemonsListPageState extends State<PokemonsListPage> {
  final pokemonRepository = PokemonRepository(
    PokemonsRemoteDataSource(),
    FavoritePokemonsCacheStore.instance,
  );

  late final _pokemonsListBloc = PokemonsListBloc(pokemonRepository);

  late final _favoritePokemonsListBloc = PokemonsListBloc(
    pokemonRepository,
    FavoritePokemonsCacheStore.instance,
  );

  final _pokemonsListPagingController = PagingController<int, Pokemon>(
    firstPageKey: 0,
  );

  final _favoritePokemonsPagingController = PagingController<int, Pokemon>(
    firstPageKey: 0,
  );

  @override
  void dispose() {
    _pokemonsListBloc.dispose();
    _favoritePokemonsListBloc.dispose();
    _pokemonsListPagingController.dispose();
    _favoritePokemonsPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _AppBar(),
        ),
        body: Column(
          children: [
            const _TabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  PokemonsList(
                    _pokemonsListBloc,
                    _pokemonsListPagingController,
                  ),
                  PokemonsList(
                    _favoritePokemonsListBloc,
                    _favoritePokemonsPagingController,
                  ),
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
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: appTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: appTheme.appBarTheme.backgroundColor,
      child: TabBar(
        isScrollable: screenWidth < 300,
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

class _FavoriteTab extends StatefulWidget {
  const _FavoriteTab({
    Key? key,
  }) : super(key: key);

  @override
  State<_FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<_FavoriteTab> {
  int favoritePokemonsCount = 0;
  final favoritePokemonsStore = FavoritePokemonsCacheStore.instance;

  @override
  void initState() {
    super.initState();
    _fetchfavoritePokemonsCount();
    favoritePokemonsStore.addListener(_fetchfavoritePokemonsCount);
  }

  void _fetchfavoritePokemonsCount() {
    favoritePokemonsStore.favoritePokemonsCount.then((value) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() => favoritePokemonsCount = value);
      });
    });
  }

  @override
  void dispose() {
    favoritePokemonsStore.dispose();
    super.dispose();
  }

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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Text(
                  favoritePokemonsCount.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              minRadius: 10,
            )
          ],
        ),
      ),
    );
  }
}
