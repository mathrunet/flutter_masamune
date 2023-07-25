// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_introduction/masamune_introduction.dart';

final List<MasamuneAdapter> masamuneAdapters = [
  IntroductionMasamuneAdapter(
    items: [
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
    skipLabel: "Skip",
    doneLabel: "Done",
  ),
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (adapters) => MasamuneApp(
      home: MasamuneIntroductionPage(
        routeQuery: MasamuneIntroductionPage.query(),
      ),
      title: "Flutter Demo",
      masamuneAdapters: adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}
