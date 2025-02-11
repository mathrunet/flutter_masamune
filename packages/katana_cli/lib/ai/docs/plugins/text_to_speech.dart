// Project imports:
import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of text_to_speech.mdc.
///
/// text_to_speech.mdcの中身。
class PluginTextToSpeechMdcCliAiCode extends PluginUsageCliAiCode {
  /// Contents of text_to_speech.mdc.
  ///
  /// text_to_speech.mdcの中身。
  const PluginTextToSpeechMdcCliAiCode();

  @override
  String get name => "Text-To-Speech";

  @override
  String get description => "`Text-To-Speech`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`Text-To-Speech`はテキストを音声にして発話させる機能を提供するプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`Text-To-Speech`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using speech synthesis.
    # 音声合成による発話を利用するための設定を記述します。
    text_to_speech:
      enable: true # Text-To-Speechを利用する場合false -> trueに変更
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

        // Text-To-Speechのアダプターを追加。
        const TextToSpeechMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// Text-To-Speechのコントローラーを取得。
final tts = ref.app.controller(TextToSpeech.query());

// 音声を再生。
await tts.speak(
  // 発話するテキスト。
  text: "こんにちは。",
  // 言語。
  language: "ja-JP",
  // 音量（0.0 - 1.0）。
  volume: 1.0,
  // 速度（0.0 - 2.0）。
  rate: 1.0,
  // ピッチ（0.0 - 2.0）。
  pitch: 1.0,
);

// 音声を一時停止。
await tts.pause();

// 音声を再開。
await tts.resume();

// 音声を停止。
await tts.stop();
```
""";
  }
}
