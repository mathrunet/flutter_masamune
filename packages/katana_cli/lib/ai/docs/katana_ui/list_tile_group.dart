import 'package:katana_cli/ai/docs/katana_ui_usage.dart';

/// Contents of list_tile_group.mdc.
///
/// list_tile_group.mdcの中身。
class KatanaUIListTileGroupMdcCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of list_tile_group.mdc.
  ///
  /// list_tile_group.mdcの中身。
  const KatanaUIListTileGroupMdcCliAiCode();

  @override
  String get name => "`ListTileGroup`の利用方法";

  @override
  String get description =>
      "ListTileやLineTileをグループ化して表示するためのウィジェットである`ListTileGroup`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "ListTileやLineTileをグループ化して表示するためのウィジェット。タイル間の区切り線やスタイリングをカスタマイズ可能。";

  @override
  String body(String baseName, String className) {
    return """
# ListTileGroup

## 概要

$excerpt

## 特徴

- 複数の`ListTile`や`LineTile`をグループ化
- タイル間に区切り線を追加可能
- グループ全体の背景色やボーダーをカスタマイズ可能
- マージンとパディングの調整が可能
- 角丸の設定が可能

## 基本的な使い方

```dart
ListTileGroup(
  children: [
    ListTile(
      title: Text("タイル1"),
    ),
    ListTile(
      title: Text("タイル2"),
    ),
    ListTile(
      title: Text("タイル3"),
    ),
  ],
);
```

## カスタマイズ例

### 区切り線の追加

```dart
ListTileGroup(
  divider: const Divider(height: 1),
  children: [
    ListTile(
      title: Text("タイル1"),
    ),
    ListTile(
      title: Text("タイル2"),
    ),
    ListTile(
      title: Text("タイル3"),
    ),
  ],
);
```

### スタイリングのカスタマイズ

```dart
ListTileGroup(
  tileColor: Colors.grey[100],
  borderRadius: BorderRadius.circular(16),
  margin: const EdgeInsets.all(16),
  padding: const EdgeInsets.symmetric(vertical: 12),
  children: [
    ListTile(
      title: Text("タイル1"),
    ),
    ListTile(
      title: Text("タイル2"),
    ),
  ],
);
```

### LineTileとの組み合わせ

```dart
ListTileGroup(
  children: [
    LineTile(
      title: Text("タイトル1"),
      text: Text("テキスト1"),
    ),
    LineTile(
      title: Text("タイトル2"),
      text: Text("テキスト2"),
    ),
  ],
);
```

## 注意点

- `children`は必須パラメータ
- `children`が空の場合は`SizedBox.shrink()`が返される
- デフォルトのマージンは上下8px
- デフォルトのパディングは上下8px
- デフォルトの角丸は12px
- デフォルトの背景色は`Theme.of(context).colorScheme.surface`
- `ListTileGroup`は`LineTileGroup`のエイリアス
""";
  }
}
