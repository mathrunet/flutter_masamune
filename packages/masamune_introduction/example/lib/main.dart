// Dart imports:

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_introduction/masamune_introduction.dart";

/// List of Masamune adapters for the application.
///
/// This includes the IntroductionMasamuneAdapter with localized introduction items,
/// skip and done button labels for the app tutorial.
///
/// アプリケーション用のMasamuneアダプターのリスト。
///
/// アプリチュートリアル用のローカライズされた導入項目、スキップおよび完了ボタンラベルを含む
/// IntroductionMasamuneAdapterが含まれています。
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
            ),
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

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with introduction/tutorial functionality.
/// The app displays an introduction sequence with multiple pages that users can
/// navigate through or skip.
///
/// アプリケーションのエントリーポイント。
///
/// 導入/チュートリアル機能を含むMasamuneアプリを初期化し実行します。
/// このアプリはユーザーがナビゲートまたはスキップできる複数のページからなる
/// 導入シーケンスを表示します。
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
