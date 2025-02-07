import 'package:katana_cli/ai/docs/katana_ui_usage.dart';

/// Contents of message_box.mdc.
///
/// message_box.mdcの中身。
class KatanaUIMessageBoxMdcCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of message_box.mdc.
  ///
  /// message_box.mdcの中身。
  const KatanaUIMessageBoxMdcCliAiCode();

  @override
  String get name => "MessageBoxの利用方法";

  @override
  String get description => "MasamuneフレームワークにおけるMessageBoxの利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "メッセージを表示するためのボックスウィジェット。アイコン、メッセージ、アクションを含むカスタマイズ可能なメッセージボックス。";

  @override
  String body(String baseName, String className) {
    return """
# MessageBox

## 概要

$excerpt

## 特徴

- アイコンとメッセージを横並びに表示
- カスタマイズ可能なスタイリング（色、背景色、ボーダー、角丸など）
- アクションボタンの追加が可能
- デフォルトのアイコンとして`Icons.info_outline`を使用

## 基本的な使い方

```dart
MessageBox(
  label: const Text("メッセージ内容をここに記載します"),
);
```

## カスタマイズ例

### カスタムアイコンとカラーの設定

```dart
MessageBox(
  label: const Text("カスタムアイコンとカラーを設定したメッセージ"),
  icon: const Icon(Icons.warning),
  color: Colors.orange,
  backgroundColor: Colors.orange.withOpacity(0.1),
);
```

### アクションボタンの追加

```dart
MessageBox(
  label: const Text("アクションボタン付きのメッセージ"),
  actions: [
    TextButton(
      onPressed: () {
        // アクション処理
      },
      child: const Text("OK"),
    ),
  ],
);
```

### カスタムスタイリング

```dart
MessageBox(
  label: const Text("カスタムスタイリングを適用したメッセージ"),
  padding: const EdgeInsets.all(24),
  margin: const EdgeInsets.all(16),
  borderRadius: BorderRadius.circular(8),
  border: Border.all(
    color: Colors.blue,
    width: 2,
  ),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
);
```

## 注意点

- `label`は必須パラメータ
- `icon`を指定しない場合は`Icons.info_outline`が使用される
- `color`を指定しない場合は`Theme.of(context).primaryColor`が使用される
- `backgroundColor`を指定しない場合は`color.withValues(alpha: 0.1)`が使用される
- `actions`は空のリストがデフォルト値
""";
  }
}
