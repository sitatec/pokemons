import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:podedex/pages/pokemons_list/bloc/pokemons_list_bloc.dart';
import 'package:podedex/pages/pokemons_list/widgets/pokemons_list.dart';

import '../../data_sources_adapters/dio_adapter.dart';
import '../../data_sources_adapters/pokeapi_adapter.dart';
import '../../data_sources_adapters/sqflite_adapter.dart';
import '../../domain/data_sources/pokemon_repository.dart';
import 'widgets/simple_widgets.dart';

class PokemonsListPage extends StatelessWidget {
  PokemonsListPage({Key? key}) : super(key: key);
  final _pokemonsListBloc = PokemonsListBloc(
      PokemonRepository(PokeapiAdapter(DioAdapter()), SqfliteAdapter(null)));

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: appTheme.appBarTheme.backgroundColor,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: appTheme.scaffoldBackgroundColor,
          ),
          title: const Brand(),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              color: Colors.white,
              child: TabBar(
                  labelColor: appTheme.colorScheme.onSurface,
                  unselectedLabelColor: appTheme.colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w400),
                  indicator: RoundedTabIndicator(
                    color: appTheme.primaryColor,
                    radius: 4,
                    indicatorHeight: 4,
                  ),
                  tabs: [
                    const SizedBox(
                        height: 50, child: Tab(child: Text("All Pokemons"))),
                    Tab(
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
                                child:
                                    Text("1", style: TextStyle(fontSize: 12)),
                              ),
                              minRadius: 9,
                            )
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
            Expanded(
                child: TabBarView(children: [
              PokemonsList(_pokemonsListBloc),
              Icon(Icons.directions_car)
            ])),
          ],
        ),
      ),
    );
  }
}
