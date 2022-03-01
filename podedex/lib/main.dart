import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/colors.dart';
import 'pages/pokemons_list/pokemons_list_page.dart';

void main() {
  // TODO check network and internet availability on request failure.
  // TODO implement memory efficient version of the [infinite_scroll_pagination] package's implementation.
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
      home: Builder(builder: (context) {
        final appMediaQuery = MediaQuery.of(context);
        final textScaleFactor = _getTextScaleFactor(appMediaQuery.size.width);
        return MediaQuery(
            data: appMediaQuery.copyWith(textScaleFactor: textScaleFactor),
            child: const PokemonsListPage());
      }),
    );
  }

  double _getTextScaleFactor(double screenWidth) {
    if (screenWidth > 1200) {
      return 1.5;
    }
    if (screenWidth > 768) {
      return 1.22;
    }
    return 1.1;
  }
}
