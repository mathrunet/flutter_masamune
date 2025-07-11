// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_localization/katana_localization.dart";

part "main.localize.dart";

/// Global localization instance.
///
/// グローバルローカライゼーションインスタンス。
final l = AppLocalize();

/// Application localization class with Google Spreadsheet support.
///
/// Google Spreadsheet対応のアプリケーションローカライゼーションクラス。
@GoogleSpreadSheetLocalize(
  [
    "https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808"
  ],
  version: 1,
)
class AppLocalize extends _$AppLocalize {}

void main() {
  runApp(const MyApp());
}

/// Main application widget for localization demo.
///
/// ローカライゼーション デモ用のメインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizeScope(
      localize: l,
      builder: (context, localize) {
        return MaterialApp(
          locale: localize.locale,
          localizationsDelegates: localize.delegates(),
          supportedLocales: localize.supportedLocales(),
          localeResolutionCallback: localize.localeResolutionCallback(),
          home: MainPage(),
          title: "Flutter Demo",
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        );
      },
    );
  }
}

/// Main page widget to demonstrate localization functionality.
///
/// ローカライゼーション機能を実演するメインページWidget。
// ignore: use_key_in_widget_constructors
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l().appTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l.locale.toLanguageTag()),
          ),
          ListTile(
            title: Text(l().ok),
          ),
          ListTile(
            title: Text(l().cancel),
          ),
          ListTile(
            title: Text(
              l().$(l().$(l().process).of.$(l().data)).hasBeenCompleted,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.change_circle),
        onPressed: () {
          l.setCurrentLocale(
            l.supportedLocales().firstWhere((element) => element != l.locale),
          );
        },
      ),
    );
  }
}
