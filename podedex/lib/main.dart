import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/colors.dart';
import 'pages/pokemons_list/pokemons_list_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      theme: ThemeData(
        fontFamily: GoogleFonts.notoSans().fontFamily,
        scaffoldBackgroundColor: lightGrey,
        primaryColor: lightBlue,
        colorScheme: appTheme.colorScheme.copyWith(
          onSurface: darkBlue,
          onSurfaceVariant: grey,
        ),
        appBarTheme: appTheme.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          foregroundColor: darkBlue,
        ),
      ),
      home: const PokemonsListPage(),
    );
  }
}
