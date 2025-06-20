# チュートリアル

`チュートリアル`は下記のように利用する。

## 概要

`チュートリアル`はアプリ起動時にアプリの説明を行うためのプラグイン。

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using the introductory part of the application.
    # アプリの導入部分を利用するための設定を記述します。
    introduction:
      enable: true # チュートリアルを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`MasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // チュートリアルのアダプターを追加。
        const IntroductionMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// チュートリアルのコントローラーを取得。
final introduction = ref.app.controller(Introduction.query());

// チュートリアルを表示。
introduction.show(
  // チュートリアルのページ一覧。
  pages: [
    IntroductionPage(
      // タイトル。
      title: "ようこそ",
      // 説明文。
      description: "このアプリの使い方を説明します。",
      // 画像。
      image: const AssetImage("assets/images/tutorial_1.png"),
    ),
    IntroductionPage(
      title: "機能1",
      description: "このアプリの機能1について説明します。",
      image: const AssetImage("assets/images/tutorial_2.png"),
    ),
    IntroductionPage(
      title: "機能2",
      description: "このアプリの機能2について説明します。",
      image: const AssetImage("assets/images/tutorial_3.png"),
    ),
  ],
);
```
