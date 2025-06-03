// Project imports:
import "package:katana_cli/ai/docs/universal_ui_usage.dart";

/// Contents of universal_extent_app_bar.md.
///
/// universal_extent_app_bar.mdの中身。
class UniversalExtentAppBarMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_extent_app_bar.md.
  ///
  /// universal_extent_app_bar.mdの中身。
  const UniversalExtentAppBarMdCliAiCode();

  @override
  String get name => "`UniversalExtentAppBar`の利用方法";

  @override
  String get description =>
      "固定の高さを持つ拡張された`AppBar`である`UniversalExtentAppBar`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "固定の高さを持つ拡張されたAppBar。通常は`ListView`、`UniversalListView`等のリストの中に配置する。タイトルの位置を上下で選択可能で、背景にグラデーションや画像を設定可能。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。";

  @override
  String body(String baseName, String className) {
    return """
`UniversalExtentAppBar`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalExtentAppBar(
  height: 200.0,
  title: const Text("拡張AppBar"),
  subtitle: const Text("固定サイズのAppBar"),
  titlePosition: UniversalAppBarTitlePosition.bottom,
  actions: [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
          // TODO: Implement the search action.
      },
    ),
  ],
  background: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  titlePadding: const EdgeInsets.all(24),
);
```

## グラデーション背景の例

```dart
UniversalExtentAppBar(
  height: 150.0,
  title: const Text("グラデーション"),
  titlePosition: UniversalAppBarTitlePosition.bottom,
  background: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.orange, Colors.red],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  ),
);
```

## 画像背景の例

```dart
UniversalExtentAppBar(
  height: 180.0,
  title: const Text("画像背景"),
  foregroundColor: Colors.white,
  background: Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: NetworkImage("https://example.com/header.jpg"),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.black54, BlendMode.multiply),
      ),
    ),
  ),
);
```

## プロパティ

- `height`: AppBarの固定高さを設定する（デフォルト: 240.0）。
- `title`: AppBarのタイトルを設定する。
- `subtitle`: タイトルの下に表示するサブタイトルを設定する。
- `titlePosition`: タイトルの位置を設定する（top/bottom/flexible）。
- `actions`: AppBarの右側に表示するウィジェットのリストを設定する。
- `background`: AppBarの背景ウィジェットを設定する。
- `titlePadding`: タイトルとサブタイトルのパディングを設定する。
- `backgroundColor`: AppBarの背景色を設定する。
- `foregroundColor`: AppBarの前景色（テキスト・アイコン色）を設定する。
- `centerTitle`: タイトルを中央に配置するかどうかを設定する。
- `leading`: AppBarの左側に表示するウィジェットを設定する。
- `leadingWidth`: leadingウィジェットの幅を設定する。
- `titleSpacing`: タイトルのスペーシングを設定する。
- `automaticallyImplyLeading`: 自動的にleadingを追加するかどうかを設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。
- `enableResponsivePadding`: レスポンシブパディングを有効にするかどうかを設定する。

## 注意点

- 高さが固定されているため、スクロール時にも高さは変わらない。
- `titlePosition`を`bottom`に設定すると、タイトルがAppBarの下部に配置される。
- `background`ウィジェットを使用して、グラデーションや画像背景を設定できる。
- `foregroundColor`でテキストやアイコンの色を一括で設定できる。
- レスポンシブ対応により、デスクトップとモバイルで適切なレイアウトが適用される。
- `PreferredSizeWidget`を実装しているため、`Scaffold.appBar`に直接設定可能。
""";
  }
}
