// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of text_to_speech.md.
///
/// text_to_speech.mdの中身。
class PluginTextToSpeechMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of text_to_speech.md.
  ///
  /// text_to_speech.mdの中身。
  const PluginTextToSpeechMdCliAiCode();

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

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_text_to_speech
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`TextToSpeechMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Text-To-Speechのアダプターを追加。
        const TextToSpeechMasamuneAdapter(
          defaultLocale: Locale('ja', 'JP'),                         // デフォルト言語（必須）
          defaultSpeechRate: 0.5,                                    // 話速（0.0-1.0、デフォルト: 1.0）
          defaultVolume: 1.0,                                        // 音量（0.0-1.0、デフォルト: 1.0）
          defaultPitch: 1.0,                                         // ピッチ（0.0-1.0、デフォルト: 1.0）
          defaultIosAudioCategory: TextToSpeechIosAudioCategory.playback,  // iOSオーディオカテゴリ
          defaultIosAudioCategoryOptions: [
            TextToSpeechIosAudioCategoryOptions.mixWithOthers,       // 他のオーディオとミックス
          ],
        ),
    ];
    ```

**英語を使用する場合**:

```dart
const TextToSpeechMasamuneAdapter(
  defaultLocale: Locale('en', 'US'),
)
```

## 利用方法

### 基本的な使い方

`TextToSpeechController`を使用してテキストを読み上げ、再生を停止し、音声を照会します。

```dart
class TextReaderPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final tts = ref.page.controller(TextToSpeechController.query());

    // ページ読み込み時に初期化
    ref.page.on(
      initOrUpdate: () {
        tts.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Text to Speech")),
      body: Column(
        children: [
          TextField(
            onChanged: (text) {
              // 読み上げるテキストを保存
            },
          ),

          ElevatedButton(
            onPressed: () async {
              await tts.speak("こんにちは、Masamune！");
            },
            child: const Text("読み上げ"),
          ),

          ElevatedButton(
            onPressed: () async {
              await tts.stop();
            },
            child: const Text("停止"),
          ),
        ],
      ),
    );
  }
}
```

### 音声パラメータの設定

ピッチ、話速、言語を動的に変更できます。

```dart
await tts.setLanguage("ja-JP");
await tts.setSpeechRate(0.6);
await tts.setPitch(1.2);
await tts.speak("こんにちは");
```

`availableLanguages()`と`availableVoices()`を使用して、ユーザーに選択UIを提供できます。

```dart
// 利用可能な言語を取得
final languages = await tts.getAvailableLanguages();
print("利用可能な言語: \$languages");

// 利用可能な音声を取得
final voices = await tts.getAvailableVoices();
for (final voice in voices) {
  print("音声: \${voice.name}, 言語: \${voice.locale}");
}
```

### キューイングと完了

- `await tts.speak()`は再生が完了すると解決されます
- `tts.setQueueMode(QueueMode.queue)`を使用して複数の文をキューに入れます
- 音声が終了したときに反応するために`onComplete`コールバックを登録します

```dart
// キューモードで複数のテキストを読み上げ
await tts.setQueueMode(QueueMode.queue);
await tts.speak("最初の文章です。");
await tts.speak("次の文章です。");
await tts.speak("最後の文章です。");
```

### 再生状態の監視

コントローラーの状態を監視してUIを更新します:

```dart
// 読み上げ中かどうかを確認
if (tts.speaking) {
  // 読み上げ中のUIを表示
}

// 初期化済みかどうかを確認
if (tts.initialized) {
  // 初期化済みの場合の処理
}

// 変更を監視
tts.addListener(() {
  // 状態が変更されたときの処理
});
```

### iOSのオーディオカテゴリ設定

iOSでは、他のオーディオとの混合を制御するためにオーディオカテゴリを設定できます:

```dart
const TextToSpeechMasamuneAdapter(
  defaultLocale: Locale('ja', 'JP'),
  defaultIosAudioCategory: TextToSpeechIosAudioCategory.playback,  // 再生カテゴリ
  defaultIosAudioCategoryOptions: [
    TextToSpeechIosAudioCategoryOptions.mixWithOthers,  // 他のオーディオとミックス
    TextToSpeechIosAudioCategoryOptions.duckOthers,     // 他のオーディオを下げる
  ],
)
```

利用可能なカテゴリ:
- `playback`: バックグラウンド再生対応
- `ambient`: 他のオーディオとミックス（システム音声を消音しない）
- `playAndRecord`: 録音と再生の両方

### 実用的な例：テキストリーダー

```dart
class ArticleReaderPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final tts = ref.page.controller(TextToSpeechController.query());
    final article = "長い記事のテキスト...";

    return Scaffold(
      appBar: AppBar(
        title: const Text("記事リーダー"),
        actions: [
          IconButton(
            icon: Icon(tts.speaking ? Icons.pause : Icons.play_arrow),
            onPressed: () async {
              if (tts.speaking) {
                await tts.stop();
              } else {
                await tts.speak(article);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(article),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "speed_up",
            mini: true,
            child: const Icon(Icons.fast_forward),
            onPressed: () async {
              final currentRate = await tts.getSpeechRate();
              await tts.setSpeechRate((currentRate + 0.1).clamp(0.0, 2.0));
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "speed_down",
            mini: true,
            child: const Icon(Icons.fast_rewind),
            onPressed: () async {
              final currentRate = await tts.getSpeechRate();
              await tts.setSpeechRate((currentRate - 0.1).clamp(0.0, 2.0));
            },
          ),
        ],
      ),
    );
  }
}
```

### Tips

- iOSのオーディオカテゴリ（`playback`、`ambient`など）を設定して、他のオーディオとの混合を制御します
- `tts.initialize()`のエラーを適切に処理してください。特にWebでは権限が異なります
- 連続呼び出しで低レイテンシが必要な場合は、頻繁に使用するフレーズをキャッシュします
- `masamune_speech_to_text`と組み合わせて会話型インターフェースを構築できます
- 読み上げ中はユーザーに視覚的なフィードバック（進行状況バー、ハイライトなど）を提供してください
""";
  }
}
