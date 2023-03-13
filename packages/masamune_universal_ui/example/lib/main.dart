// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_universal_ui/masamune_universal_ui.dart';

final List<MasamuneAdapter> masamuneAdapters = [
  const UniversalMasamuneAdapter()
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (adapters) => MasamuneApp(
      home: const UniversalUIPage(),
      title: "Flutter Demo",
      masamuneAdapters: adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

class UniversalUIPage extends StatelessWidget {
  const UniversalUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalScaffold(
      appBar: const UniversalAppBar(
        title: Text("App Demo"),
      ),
      body: UniversalListView(children: [
        for (var i = 0; i < 10; i++)
          ListTile(
            title: Text("Title $i"),
            subtitle: Text("Subtitle $i"),
          ),
      ]),
    );
  }
}
