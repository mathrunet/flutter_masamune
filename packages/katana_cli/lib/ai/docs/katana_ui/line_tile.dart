// Project imports:
import "package:katana_cli/ai/docs/katana_ui_usage.dart";

/// Contents of line_tile.md.
///
/// line_tile.mdの中身。
class KatanaUILineTileMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of line_tile.md.
  ///
  /// line_tile.mdの中身。
  const KatanaUILineTileMdCliAiCode();

  @override
  String get name => "`LineTile`の利用方法";

  @override
  String get description =>
      "`ListTile`に`text`プロパティを追加したもの、textプロパティにWidgetを設定するとtitleの右側に表示される。";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "`ListTile`に`text`プロパティを追加したもの、textプロパティにWidgetを設定するとtitleの右側に表示される。";

  @override
  String body(String baseName, String className) {
    return """
# LineTile

## 概要

$excerpt

## 特徴

- タイトルとテキストを横並びに配置可能
- タイトルとテキストの比率を`titleFlex`と`textFlex`で調整可能
- 間隔を`space`で調整可能
- シマーエフェクトに対応（`shimmer`プロパティ）
- `LineGroupTile`と組み合わせることで、デザイン的にグループ化された`LineTile`を横並びに配置可能

## 基本的な使い方

```dart
LineTile(
  title: const Text("タイトル"),
  text: const Text("テキスト"),
);
```

## カスタマイズ例

### フレックス比率の調整

```dart
LineTile(
  title: const Text("タイトル"),
  text: const Text("テキスト"),
  titleFlex: 2,  // タイトルの比率を2に
  textFlex: 1,   // テキストの比率を1に
);
```

### 間隔の調整

```dart
LineTile(
  title: const Text("タイトル"),
  text: const Text("テキスト"),
  space: 16.0,  // タイトルとテキストの間隔を16.0に
);
```

### シマーエフェクトの利用

```dart
LineTile(
  title: const Text("タイトル"),
  text: const Text("テキスト"),
  shimmer: true,  // シマーエフェクトを有効化
  shimmerBaseColor: Colors.grey[300],
  shimmerHighlightColor: Colors.grey[100],
);
```

## 注意点

- `text`プロパティは省略可能
- `ListTile`の機能をすべて継承しているため、`leading`や`trailing`なども利用可能
- シマーエフェクトを使用する場合は、ベースカラーとハイライトカラーを適切に設定することを推奨

## 利用シーン

- メニューの項目
- リストの項目
- `ListTile`の代替
""";
  }
}
