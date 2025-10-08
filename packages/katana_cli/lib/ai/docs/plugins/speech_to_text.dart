// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of speech_to_text.md.
///
/// speech_to_text.mdの中身。
class PluginSpeechToTextMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of speech_to_text.md.
  ///
  /// speech_to_text.mdの中身。
  const PluginSpeechToTextMdCliAiCode();

  @override
  String get name => "Speech-To-Text";

  @override
  String get description => "`Speech-To-Text`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`Speech-To-Text`は音声認識してテキストに変換する機能を提供するプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`Speech-To-Text`は下記のように利用する。

## 概要

$excerpt

## 設定方法

### katana.yamlを使用する場合(推奨)

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
      enable: true
      permission:
        en: Used to perform voice recognition.
        ja: 音声認識を実行するために使用されます。
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`SpeechToTextMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Speech-To-Textのアダプターを追加。
        // デフォルトの言語設定を指定（必須）
        const SpeechToTextMasamuneAdapter(
          defaultLocale: Locale('ja', 'JP'),  // 日本語を使用
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_speech_to_text
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`SpeechToTextMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Speech-To-Textのアダプターを追加。
        // デフォルトの言語設定を指定（必須）
        const SpeechToTextMasamuneAdapter(
          defaultLocale: Locale('ja', 'JP'),  // 日本語を使用
        ),
    ];
    ```

**英語を使用する場合**:

```dart
const SpeechToTextMasamuneAdapter(
  defaultLocale: Locale('en', 'US'),
)
```

**自動初期化を有効にする場合**（オプション）:

```dart
// 自動初期化用のコントローラーを作成
final sttController = SpeechToTextController();

const SpeechToTextMasamuneAdapter(
  defaultLocale: Locale('ja', 'JP'),
  speechToTextController: sttController,  // 起動時に初期化
  initializeOnBoot: true,                 // 自動初期化を有効化
)
```

## 利用方法

### 基本的な使い方

`SpeechToTextController`を使用して音声認識を初期化し、リスニングを開始し、結果を処理します。

```dart
class VoiceInputPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final stt = ref.page.controller(SpeechToTextController.query());

    // ページ読み込み時に初期化
    ref.page.on(
      initOrUpdate: () {
        stt.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("音声入力")),
      body: Column(
        children: [
          Text(stt.recognizedText ?? "何か話してください..."),

          ElevatedButton(
            onPressed: () async {
              if (stt.isListening) {
                await stt.stop();
              } else {
                await stt.listen(
                  onResult: (result) {
                    print("認識結果: \${result.recognizedWords}");
                  },
                );
              }
            },
            child: Text(stt.isListening ? "停止" : "音声認識を開始"),
          ),
        ],
      ),
    );
  }
}
```

### 継続的なリスニング

- `listen()`で認識を開始します。途中経過の文字起こしを受け取るには`partialResults: true`を設定します
- `stt.pause()` / `stt.resume()`を使用して、完全な再初期化なしでリスニングセッションを管理します
- 権限チェックを処理します。マイクアクセスが拒否された場合、コントローラーは例外をスローします

```dart
// 部分的な結果を含めてリスニング
await stt.listen(
  partialResults: true,
  onResult: (result) {
    if (result.finalResult) {
      print("確定: \${result.recognizedWords}");
    } else {
      print("途中経過: \${result.recognizedWords}");
    }
  },
);

// 一時停止と再開
await stt.pause();
await stt.resume();
```

### エラーハンドリング

エラーストリームをリッスンするか、`listen()`に`onError`を指定して`SpeechRecognitionError`の詳細を取得します。

```dart
await stt.listen(
  onError: (SpeechRecognitionError error) {
    debugPrint("エラー: \${error.errorMsg}");
  },
  onResult: (result) {
    print("認識結果: \${result.recognizedWords}");
  },
);
```

### 認識状態の監視

コントローラーの状態を監視してUIを更新します:

```dart
// リスニング中かどうかを確認
if (stt.isListening) {
  // リスニング中のUIを表示
}

// 初期化済みかどうかを確認
if (stt.initialized) {
  // 初期化済みの場合の処理
}

// 新しい認識結果があるかどうかを確認
if (stt.updated) {
  // 新しい結果を処理
}
```

### テキスト入力フィールドとの連携

音声認識結果をテキストフィールドに反映する:

```dart
class VoiceTextField extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final stt = ref.page.controller(SpeechToTextController.query());
    final textController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: "テキスト入力",
            suffixIcon: IconButton(
              icon: Icon(stt.isListening ? Icons.mic : Icons.mic_none),
              onPressed: () async {
                if (stt.isListening) {
                  await stt.stop();
                } else {
                  await stt.listen(
                    onResult: (result) {
                      // 認識結果をテキストフィールドに追加
                      textController.text = result.recognizedWords;
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
```

### Tips

- リスニング前に必ず`initialize()`を呼び出してください。パフォーマンスのため、セッション間でコントローラーを再利用します
- リスニング中はUI フィードバック（アニメーション、ステータスインジケーター）を提供してください
- ターゲットオーディエンスに合わせてロケールID（例: `ja_JP`、`fr_FR`）をローカライズしてください
- テキスト入力フィールドと組み合わせて、ユーザーが認識されたテキストを編集できるようにしてください
- マイク権限が拒否された場合の適切なエラーハンドリングとユーザーへのフィードバックを実装してください
""";
  }
}
