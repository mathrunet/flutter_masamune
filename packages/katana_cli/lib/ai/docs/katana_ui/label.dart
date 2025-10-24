// Project imports:
import "package:katana_cli/ai/docs/katana_ui_usage.dart";

/// Contents of label.md.
///
/// label.mdの中身。
class KatanaUILabelMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of label.md.
  ///
  /// label.mdの中身。
  const KatanaUILabelMdCliAiCode();

  @override
  String get name => "`Label`の利用方法";

  @override
  String get description =>
      "項目のタイトルなどで使うラベルを表示するためのウィジェットである`Label`の利用方法。アイコン、テキスト、アクションボタンを組み合わせたセクションヘッダーやラベル表示を実現。";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt => "項目のタイトルなどで使うラベルを表示するためのウィジェット。アイコンやテキストを組み合わせて使用可能。";

  @override
  String body(String baseName, String className) {
    return """
# Label

## 概要

$excerpt

## 特徴

- テキストとアイコンの組み合わせが可能
- カスタマイズ可能な背景色とスタイリング
- アクションボタンの追加が可能
- 柔軟なパディングとアライメントの設定
- テーマに基づいたデフォルトスタイリング

## 基本的な使い方

### シンプルなラベル

```dart
Label(
  "シンプルなラベル",
);
```

### アイコン付きラベル

```dart
Label(
  "アイコン付きラベル",
  leading: Icon(Icons.label),
);
```

### スタイル付きラベル

```dart
Label(
  "スタイル付きラベル",
  backgroundColor: Colors.blue.withOpacity(0.1),
  color: Colors.blue,
  padding: const EdgeInsets.all(8),
);
```

## カスタマイズ例

### アクション付きラベル

```dart
Label(
  "アクション付きラベル",
  leading: Icon(Icons.label),
  actions: [
    IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        // 編集アクション
      },
    ),
    IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        // 削除アクション
      },
    ),
  ],
);
```

### カスタムデコレーション

```dart
Label(
  "カスタムデコレーション",
  decoration: BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey),
  ),
  padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
);
```

### カスタムテキストスタイル

```dart
Label(
  "カスタムテキストスタイル",
  textStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.indigo,
  ),
);
```

## 注意点

- `text`は必須パラメータ
- デフォルトのテキストスタイルは`Theme.of(context).textTheme.titleMedium`をベースに太字（`fontWeight: FontWeight.bold`）で設定
- `textStyle`を指定した場合でも、`color`パラメータで色を上書き可能
- `actions`を追加すると、`Spacer()`でテキストとアクションの間にスペースが挿入され、アクション間に自動的に8.0の左パディングが追加される
- `leading`（アイコン）とテキストの間のデフォルトスペースは8.0（`leadingSpace`で変更可能）
- テキストの色とアイコンの色は`color`パラメータで統一的に設定可能
- アイコンのサイズのデフォルトは`textStyle?.fontSize * 1.5`
- テキストの`height`は1.0に固定される
- `textAlign`のデフォルトは`TextAlign.start`
- `decoration`と`backgroundColor`の両方を指定した場合、`decoration`が優先される（Containerのデフォルト動作）

## 利用シーン

- メニューのグループ項目のタイトルラベル
- UIのセクションのタイトルラベル
- フォームの項目のラベル
""";
  }
}
