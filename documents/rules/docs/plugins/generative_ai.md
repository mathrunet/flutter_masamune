# Generative AI

`Generative AI`は下記のように利用する。

## 概要

`Generative AI`はOpenAI ChatGPTやGeminiなどの生成系AIをアプリに統合するプラグイン。マルチターン会話、ストリーミング応答、ツール連携(MCP)に対応。

MasamuneフレームワークではOpenAIとGeminiの2つのAIプロバイダーをサポートしています。

**注意**: `masamune_ai`がコアパッケージで、具体的な実装として`masamune_ai_openai`(ChatGPT)または`masamune_ai_firebase`(Gemini)を追加します。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Configure settings for generative AI.
    # 生成AIの設定を行います。
    generative_ai:
      # Describe the settings for using OpenAI's GPT, etc.
      # OpenAIのGPT等を利用するための設定を記述します。
      openai:
        enable: true # OpenAI ChatGPTを利用する場合false -> trueに変更

      # Configure settings for the gemini.
      # Geminiのための設定を行います。
      gemini:
        enable: false # Geminiを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`にAIアダプターを追加。

    **OpenAI ChatGPTの場合:**

    ```dart
    // lib/adapter.dart

    import 'package:masamune_ai_openai/masamune_ai_openai.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // OpenAI ChatGPTのアダプターを追加
        OpenaiAIMasamuneAdapter(
          apiKey: String.fromEnvironment("OPENAI_API_KEY"),  // 必須: OpenAI APIキー
          model: OpenaiAIModel.gpt4o,                         // 使用するモデル
          defaultConfig: AIConfig(
            systemPromptContent: AIContent.system([
              AIContent.model(text: "あなたは親切なアシスタントです。"),
            ]),
          ),
        ),
    ];
    ```

    **Firebase Geminiの場合:**

    ```dart
    // lib/adapter.dart

    import 'package:masamune_ai_firebase/masamune_ai_firebase.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Firebase Geminiのアダプターを追加
        FirebaseAIMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,  // Firebase設定
          model: FirebaseAIModel.gemini20Flash,             // 使用するモデル
          enableAppCheck: true,                              // オプション: App Checkを有効化
          defaultConfig: AIConfig(
            systemPromptContent: AIContent.system([
              AIContent.model(text: "あなたは親切なアシスタントです。"),
            ]),
          ),
        ),
    ];
    ```

### 手動でパッケージを追加する場合

**OpenAI ChatGPTの場合:**

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_ai
    flutter pub add masamune_ai_openai
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`OpenaiAIMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_ai_openai/masamune_ai_openai.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // OpenAI ChatGPTのアダプターを追加
        OpenaiAIMasamuneAdapter(
          apiKey: String.fromEnvironment("OPENAI_API_KEY"),  // 必須: OpenAI APIキー
          model: OpenaiAIModel.gpt4o,                         // 使用するモデル
          defaultConfig: AIConfig(
            systemPromptContent: AIContent.system([
              AIContent.model(text: "あなたは親切なアシスタントです。"),
            ]),
          ),
        ),
    ];
    ```

**Firebase Geminiの場合:**

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_ai
    flutter pub add masamune_ai_firebase
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`FirebaseAIMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_ai_firebase/masamune_ai_firebase.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Firebase Geminiのアダプターを追加
        FirebaseAIMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,  // Firebase設定
          model: FirebaseAIModel.gemini20Flash,             // 使用するモデル
          enableAppCheck: true,                              // オプション: App Checkを有効化
          defaultConfig: AIConfig(
            systemPromptContent: AIContent.system([
              AIContent.model(text: "あなたは親切なアシスタントです。"),
            ]),
          ),
        ),
    ];
    ```

## 利用方法

### マルチターン会話(AIThread)

複数回のやり取りを管理する場合は`AIThread`を使用:

```dart
class ChatPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    // マルチターン会話のコントローラーを取得
    final thread = ref.app.controller(
      AIThread.query(
        threadId: "chat-1",
        initialContents: [
          AIContent.text("こんにちは！"),
        ],
      ),
    );

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: thread.value.length,
            itemBuilder: (context, index) {
              final content = thread.value[index];
              return ListTile(
                title: Text(content.role.name),
                subtitle: Text(content.text),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // ユーザーの質問を送信してAIの応答を取得
            await thread.generateContent([
              AIContent.text("最新のニュースを教えて"),
            ]);
          },
          child: const Text("送信"),
        ),
      ],
    );
  }
}
```

### シングルターン会話(AISingle)

1回限りの質問と回答の場合は`AISingle`を使用:

```dart
class SummaryScopedWidget extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final single = ref.app.controller(
      AISingle.query(
        config: AIConfig(
          model: "gpt-4o-mini",  // または "gemini-2.0-flash"
        ),
      ),
    );

    return ElevatedButton(
      onPressed: () async {
        final result = await single.generateContent([
          AIContent.text("この文章を要約してください"),
        ]);
        print("要約: ${result.first.text}");
      },
      child: const Text("要約する"),
    );
  }
}
```

### ストリーミング応答

AIの応答をリアルタイムで表示:

```dart
final thread = ref.app.controller(
  AIThread.query(threadId: "chat-1"),
);

final response = await thread.generateContent([
  AIContent.text("長い物語を教えて"),
]);

// ストリーミング更新を監視
response.loading.then((_) {
  print("応答完了!");
});
```

### ツール連携(MCP)

AIにカスタムツールを使わせることができます:

```dart
// ツールの定義
final weatherTool = AITool(
  name: "weather",
  description: "現在の天気を取得",
  parameters: {
    "city": AISchema.string(description: "都市名"),
  },
);

// ツールを使用する会話
final thread = ref.app.controller(
  AIThread.query(
    threadId: "chat-with-tools",
    tools: {weatherTool},
  ),
);

await thread.generateContent([
  AIContent.text("東京の天気は?"),
]);
```

## 利用可能なモデル

### OpenAI ChatGPT

```dart
OpenaiAIModel.gpt4o                 // GPT-4o (デフォルト)
OpenaiAIModel.gpt4oMini             // GPT-4o mini
OpenaiAIModel.gpt5Mini              // GPT-5 mini (最新)
OpenaiAIModel.o1                    // O1モデル
OpenaiAIModel.o1Mini                // O1 mini
OpenaiAIModel.gpt4                  // GPT-4
OpenaiAIModel.gpt4Turbo             // GPT-4 Turbo
OpenaiAIModel.gpt35Turbo            // GPT-3.5 Turbo
```

### Firebase Gemini

```dart
FirebaseAIModel.gemini20Flash         // Gemini 2.0 Flash (デフォルト)
FirebaseAIModel.gemini15Flash         // Gemini 1.5 Flash
FirebaseAIModel.gemini15FlashLatest   // Gemini 1.5 Flash (最新版)
FirebaseAIModel.gemini15Flash8B       // Gemini 1.5 Flash 8B (軽量版)
FirebaseAIModel.gemini15Pro           // Gemini 1.5 Pro
FirebaseAIModel.gemini15ProLatest     // Gemini 1.5 Pro (最新版)
```

## 環境変数の設定

**OpenAI ChatGPT:**

```bash
# ターミナルまたは.envファイルで設定
export OPENAI_API_KEY="sk-your-api-key-here"

# または実行時に--dart-defineを使用
flutter run --dart-define=OPENAI_API_KEY=sk-your-api-key-here
```

OpenAI APIキーは[OpenAI Platform](https://platform.openai.com/api-keys)から取得できます。

**Firebase Gemini:**

Firebase設定は`firebase_options.dart`で管理されます。Firebase CLIで設定:

```bash
flutterfire configure
```

## バックエンド連携(OpenAI専用)

`OpenaiChatGPTFunctionsAction`を使用してバックエンドからChatGPTを呼び出し:

```dart
import "package:masamune_ai_openai/functions.dart";

// Masamune Functionsハンドラー内で実行
final response = await functions.execute(
  OpenaiChatGPTFunctionsAction(
    apiKey: yourApiKey,
    model: "gpt-4o",
    messages: [
      {"role": "user", "content": "こんにちは、ChatGPT!"},
    ],
  ),
);

print(response.text);
```

### Tips

- OpenAIとGeminiは同じ`AIThread`/`AISingle` APIで使用可能
- ストリーミング応答に対応し、リアルタイムで結果を表示できる
- MCPツールで関数呼び出し機能を拡張可能
- Geminiの場合、Firebase App Checkで追加のセキュリティを有効化できる
- OpenAIのAPIキーはバックエンドで管理することを推奨
```
