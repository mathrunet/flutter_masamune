# Speech-To-Text

`Speech-To-Text`は下記のように利用する。

## 概要

`Speech-To-Text`は音声認識してテキストに変換する機能を提供するプラグイン。

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using voice recognition.
    # Specify the permission message to use the library in IOS in [permission].
    # Please include `en`, `ja`, etc. and write the message in that language there.
    # 音声認識を利用するための設定を記述します。
    # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
    # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
    speech_to_text:
      enable: true # Speech-To-Textを利用する場合false -> trueに変更
      permission:
        en: Used to perform voice recognition. # 利用用途を言語ごとに記載。
        ja: 音声認識のためにマイクを利用します。# 利用用途を言語ごとに記載。
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

        // Speech-To-Textのアダプターを追加。
        const SpeechToTextMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// Speech-To-Textのコントローラーを取得。
final stt = ref.app.controller(SpeechToText.query());

// 音声認識を開始。
await stt.listen(
  // 言語。
  language: "ja-JP",
  // 認識結果を受け取るコールバック。
  onResult: (text) {
    print("Recognized text: $text");
  },
  // エラーを受け取るコールバック。
  onError: (error) {
    print("Error: $error");
  },
);

// 音声認識を停止。
await stt.stop();

// 利用可能な言語の一覧を取得。
final languages = await stt.getAvailableLanguages();
print("Available languages: $languages");
```
