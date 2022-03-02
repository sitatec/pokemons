import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podedex/pages/core_widgets.dart';

void main() {
  testWidgets("The App Brand should show the App name", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Brand()));
    expect(find.text("Pokedex"), findsOneWidget);
  });

  testWidgets(
      "It should adapte the adapte the text size based on the screen size",
      (tester) async {
    const fakeScreenSize = Size(800, 1000);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: fakeScreenSize),
          child: AdaptiveTextSizeScope(
            child: Builder(builder: (context) {
              return Text(
                "TEXT",
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              );
            }),
            configurations: const {
              1200: 1.5, // At least 1200 screen width
              768: 1.3,
              0: 1.1 // 0 means default.
            },
          ),
        ),
      ),
    );
    final text = tester.firstWidget<Text>(find.text("TEXT"));
    expect(text.textScaleFactor, 1.3);
  });
}
