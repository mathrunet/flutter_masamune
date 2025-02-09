// Project imports:
import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of openai.mdc.
///
/// openai.mdcの中身。
class PluginOpenAiMdcCliAiCode extends PluginUsageCliAiCode {
  /// Contents of openai.mdc.
  ///
  /// openai.mdcの中身。
  const PluginOpenAiMdcCliAiCode();

  @override
  String get name => "ChatGPT";

  @override
  String get description => "`ChatGPT`の利用方法";

  @override
  String get globs => "katana.yaml, lib/adapter.dart";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`ChatGPT`はGPTを利用した生成系AIの機能を提供するプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`ChatGPT`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using OpenAI's GPT, etc.
    # OpenAIのGPT等を利用するための設定を記述します。
    openai:
      enable: true # ChatGPTを利用する場合false -> trueに変更
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

        // ChatGPTのアダプターを追加。
        const OpenAiMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// ChatGPTのコントローラーを取得。
final openai = ref.app.controller(OpenAi.query());

// ChatGPTに質問を送信。
final response = await openai.chat(
  // メッセージの一覧。
  messages: [
    OpenAiChatMessage(
      role: OpenAiChatRole.system,
      content: "あなたは親切なアシスタントです。",
    ),
    OpenAiChatMessage(
      role: OpenAiChatRole.user,
      content: "こんにちは。",
    ),
  ],
  // モデルの種類。
  model: OpenAiModel.gpt3_5Turbo,
);

// レスポンスを取得。
final content = response.choices.first.message.content;
print("Response: \$content");

// 画像を生成。
final image = await openai.generateImage(
  // プロンプト。
  prompt: "A cute cat",
  // 画像のサイズ。
  size: OpenAiImageSize.size1024,
);

// 生成された画像のURLを取得。
final url = image.data.first.url;
print("Image URL: \$url");
```
""";
  }
}
