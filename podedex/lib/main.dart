import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        fontFamily: GoogleFonts.notoSans().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFE8E8E8),
        primaryColor: const Color(0xFF3558CD),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF161A33),
            ),
      ),
      home: Container(),
    );
  }
}
