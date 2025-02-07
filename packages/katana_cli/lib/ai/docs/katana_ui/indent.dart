import 'package:katana_cli/ai/docs/katana_ui_usage.dart';

/// Contents of indent.mdc.
///
/// indent.mdcの中身。
class KatanaUIIndentMdcCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of indent.mdc.
  ///
  /// indent.mdcの中身。
  const KatanaUIIndentMdcCliAiCode();

  @override
  String get name => "`Indent`の利用方法";

  @override
  String get description => "要素間にパディングを設定するためのウィジェットである`Indent`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "ColumnやListViewの中で、要素間にパディングを設定するためのウィジェット。複数の要素を含めることができ、全体的な見栄えを改善する。";

  @override
  String body(String baseName, String className) {
    return """
# Indent

## 概要

$excerpt

## 特徴

- 要素間のパディングを簡単に設定可能
- `Column`のような垂直方向のレイアウトを提供
- クロス軸とメイン軸の配置をカスタマイズ可能
- 垂直方向の配置を制御可能
- メインサイズの調整が可能

## 基本的な使い方

### シンプルな要素の配置

```dart
Indent(
  padding: const EdgeInsets.all(16),
  children: [
    Text("最初の要素"),
    Text("2番目の要素"),
    Text("3番目の要素"),
  ],
);
```

## カスタマイズ例

### カスタム配置とアライメント

```dart
Indent(
  padding: const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  ),
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.star),
    Text("中央揃えのテキスト"),
    ElevatedButton(
      onPressed: () {},
      child: Text("ボタン"),
    ),
  ],
);
```

### 逆方向の配置

```dart
Indent(
  padding: const EdgeInsets.all(8),
  verticalDirection: VerticalDirection.up,
  children: [
    Text("下に表示される要素"),
    Text("中央の要素"),
    Text("上に表示される要素"),
  ],
);
```

### 最大サイズでの配置

```dart
Indent(
  padding: const EdgeInsets.all(16),
  mainAxisSize: MainAxisSize.max,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("上部の要素"),
    Text("中央の要素"),
    Text("下部の要素"),
  ],
);
```

### 異なるウィジェットの組み合わせ

```dart
Indent(
  padding: const EdgeInsets.all(16),
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text("カード内のテキスト"),
      ),
    ),
    ElevatedButton(
      onPressed: () {},
      child: Text("アクションボタン"),
    ),
    Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8),
      child: Text("コンテナ内のテキスト"),
    ),
  ],
);
```

## 注意点

- `padding`と`children`は必須パラメータ
- デフォルトの`crossAxisAlignment`は`CrossAxisAlignment.start`
- デフォルトの`mainAxisAlignment`は`MainAxisAlignment.start`
- デフォルトの`mainAxisSize`は`MainAxisSize.min`
- デフォルトの`verticalDirection`は`VerticalDirection.down`
- 内部的には`Padding`と`Column`を組み合わせて実装
- 水平方向のレイアウトには対応していない（垂直方向のみ）
""";
  }
}
