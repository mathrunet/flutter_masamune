// Project imports:
import "package:katana_cli/ai/docs/universal_ui_usage.dart";

/// Contents of universal_sliver_app_bar.md.
///
/// universal_sliver_app_bar.mdの中身。
class UniversalSliverAppBarMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_sliver_app_bar.md.
  ///
  /// universal_sliver_app_bar.mdの中身。
  const UniversalSliverAppBarMdCliAiCode();

  @override
  String get name => "`UniversalSliverAppBar`の利用方法";

  @override
  String get description =>
      "Sliver対応の`UniversalAppBar`である`UniversalSliverAppBar`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "Sliver対応のUniversalAppBar。スクロール時に展開・縮小する動的な高さを持ち、タイトルの位置変更やスクロールスタイルの設定が可能。背景画像やフレキシブルスペースも設定可能。";

  @override
  String body(String baseName, String className) {
    return """
`UniversalSliverAppBar`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
UniversalSliverAppBar(
  title: const Text("SliverAppBar"),
  expandedHeight: 200.0,
  background: Container(
    color: Colors.blue,
  ),
);
```

## 展開可能なAppBarの例

```dart
UniversalSliverAppBar(
  title: const Text("展開AppBar"),
  subtitle: const Text("スクロールで変化"),
  expandedHeight: 300.0,
  floating: true,
  pinned: true,
  actions: [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
          // TODO: Implement the search action.
      },
    ),
  ],
  background: UniversalAppBarBackground(
    image: const AssetImage("assets/images/hero.jpg"),
    filterColor: Colors.black45,
  ),
);
```

## タイトル位置を変更した例

```dart
UniversalSliverAppBar(
  title: const Text("下部タイトル"),
  subtitle: const Text("タイトルが下に表示"),
  titlePosition: UniversalAppBarTitlePosition.bottom,
  expandedHeight: 250.0,
  scrollStyle: UniversalAppBarScrollStyle.pinned,
  background: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple, Colors.indigo],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
);
```

## フローティングスタイルの例

```dart
UniversalSliverAppBar(
  title: const Text("フローティング"),
  expandedHeight: 180.0,
  scrollStyle: UniversalAppBarScrollStyle.floating,
  snap: true,
  actions: [
    IconButton(
      icon: const Icon(Icons.share),
      onPressed: () {
          // TODO: Implement the share action.
      },
    ),
  ],
);
```

## カスタムフレキシブルスペースの例

```dart
UniversalSliverAppBar(
  title: const Text("カスタムスペース"),
  expandedHeight: 200.0,
  flexibleSpace: FlexibleSpaceBar(
    title: const Text("カスタムタイトル"),
    background: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/background.jpg",
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ),
  ),
);
```

## プロパティ

- `title`: AppBarのタイトルを設定する。
- `subtitle`: タイトルの下に表示するサブタイトルを設定する。
- `actions`: AppBarの右側に表示するウィジェットのリストを設定する。
- `expandedHeight`: 展開時のAppBarの高さを設定する（デフォルト: 240.0）。
- `collapsedHeight`: 縮小時のAppBarの高さを設定する。
- `floating`: スクロール時にAppBarを浮遊させるかどうかを設定する。
- `pinned`: AppBarを画面上部に固定するかどうかを設定する。
- `snap`: floatingが有効な場合にスナップ動作を有効にするかどうかを設定する。
- `stretch`: オーバースクロール時にAppBarを伸ばすかどうかを設定する。
- `flexibleSpace`: カスタムのフレキシブルスペースを設定する。
- `background`: AppBarの背景ウィジェットを設定する。
- `titlePosition`: タイトルの位置を設定する（flexible/top/bottom）。
- `scrollStyle`: スクロール時の動作を設定する（inherit/hidden/floating/pinned）。
- `backgroundColor`: AppBarの背景色を設定する。
- `foregroundColor`: AppBarの前景色を設定する。
- `expandedForegroundColor`: 展開時の前景色を設定する。

## スクロールスタイルの種類

- `inherit`: floating と pinned の値を使用する。
- `hidden`: スクロール時にAppBarを隠す。
- `floating`: スクロール時にAppBarを浮遊させる。
- `pinned`: AppBarを画面上部に固定する。

## 注意点

- `UniversalScaffold`と組み合わせて使用することで、自動的にSliverWidgetとして動作する。
- `expandedHeight`を設定することで、AppBarの展開時の高さを制御できる。
- `titlePosition`により、デスクトップとモバイルで異なるタイトル配置が可能。
- `floating`と`pinned`を組み合わせることで、様々なスクロール動作を実現できる。
- `snap`は`floating`が有効な場合のみ動作する。
- 背景画像を設定する場合は`UniversalAppBarBackground`を使用することを推奨する。
- カスタム`flexibleSpace`を使用する場合は、`background`プロパティより優先される。
""";
  }
}
