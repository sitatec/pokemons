# podedex
Build for mobile, tablet and Desktop screens. Also support web.

[demo.webm](https://user-images.githubusercontent.com/62622509/232266966-4c7395e3-1abc-4f1f-927e-c91a567879b6.webm)


https://user-images.githubusercontent.com/62622509/232266935-eb7a0ef9-afbf-4c16-8830-21cb257c3ffc.mov

## Build
Run `flutter pub get`.

The app depends on the [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) to generate splash screens for each platform, and [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) to create app icons. So you should run the following command lines before building the app:

- `flutter pub run flutter_launcher_icons:main`
- `flutter pub run flutter_native_splash:create`

Then you can run the app using your favorite IDE or by executing this command line:

`flutter run lib/main.dart` (assuming you are at the root of the project).

## Dependencies

Beside the two packages I have mentioned above, I use the following:

- [google_fonts](https://pub.dev/packages/flutter_launcher_icons)
- [dio](https://pub.dev/packages/dio) to fetch data from the API.
- [dio_smart_retry](https://pub.dev/packages/dio_smart_retry) which is An plugin of `dio` to retry requests on failure.
- [sqflite](https://pub.dev/packages/sqflite) to cache the favorites pokemon IDs (I could use shared preferences but it doesn't support pagination).
- [palette_generator](https://pub.dev/packages/palette_generator) to get the dominant color from an image and use it as the pokemon's background color.
- [infinite_scroll_pagination](https://pub.dev/packages/infinite_scroll_pagination) to perform lazy loading. And
- [flutter_svg](https://pub.dev/packages/flutter_svg).

## References 

- The `RoundedTabIndicator` in `lib\pages\core_widgets.dart`
was __inspired__ by these two samples:
  - A medium [post](https://medium.com/swlh/flutter-custom-tab-indicator-for-tabbar-d72bbc6c9d0c)
  - And a StackOverflow [answer](https://stackoverflow.com/a/60207984/11672037)
- The `RoundedTrackShape` in `lib\pages\pokemon_details\widgets.dart` is a customized version of this [class](https://github.com/flutter/flutter/blob/e85ba6eeae679e776792f8cacd10ebdd7707eecb/packages/flutter/lib/src/material/slider_theme.dart#L1624) from the official flutter repository on Github.
