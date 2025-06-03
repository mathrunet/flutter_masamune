// Dart imports:

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_introduction/masamune_introduction.dart";

final List<MasamuneAdapter> masamuneAdapters = [
  const IntroductionMasamuneAdapter(
    items: LocalizedValue(
      [
        LocalizedLocaleValue(
          Locale("en", "US"),
          [
            IntroductionItem(
              title: Text("Title1"),
              body: Text("Body1"),
              image: Icon(Icons.abc, size: 128),
            ),
            IntroductionItem(
              title: Text("Title2"),
              body: Text("Body2"),
              image: Icon(Icons.abc, size: 128),
            ),
            IntroductionItem(
              title: Text("Title3"),
              body: Text("Body3"),
              image: Icon(Icons.abc, size: 128),
            )
          ],
        ),
      ],
    ),
    skipLabel: LocalizedValue(
      [
        LocalizedLocaleValue(Locale("en", "US"), "Skip"),
      ],
    ),
    doneLabel: LocalizedValue(
      [
        LocalizedLocaleValue(Locale("en", "US"), "Done"),
      ],
    ),
  ),
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      home: MasamuneIntroductionPage(
        routeQuery: MasamuneIntroductionPage.query(),
      ),
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}
