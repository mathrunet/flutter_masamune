// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_app_bar.mdc.
///
/// universal_app_bar.mdcの中身。
class UniversalAppBarMdcCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_app_bar.mdc.
  ///
  /// universal_app_bar.mdcの中身。
  const UniversalAppBarMdcCliAiCode();

  @override
  String get name => "`UniversalAppBar`の利用方法";

  @override
  String get description => "`AppBar`の`UniversalUI`版である`UniversalAppBar`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`AppBar`の`UniversalUI`版。UniversalScaffold`と連携しSliverWidgetへの変換。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。`leading`、`title`、`actions`などの基本的なAppBarの機能に加え、`bottom`にウィジェットを追加可能。";

  @override
  String body(String baseName, String className) {
    return """
`UniversalAppBar`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalAppBar(
    leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
            // TODO: Implement the menu action.
        },
    ),
    title: const Text("アプリタイトル"),
    actions: [
        IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
                // TODO: Implement the settings action.
            },
        ),
    ],
    bottom: const PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: TabBar(
            tabs: [
                Tab(text: "タブ1"),
                Tab(text: "タブ2"),
            ],
        ),
    ),
);
```

## プロパティ

- `leading`: AppBarの左側に表示するウィジェットを設定する。
- `title`: AppBarのタイトルを設定する。
- `actions`: AppBarの右側に表示するウィジェットのリストを設定する。
- `bottom`: AppBarの下部に表示するウィジェットを設定する。
- `backgroundColor`: AppBarの背景色を設定する。
- `elevation`: AppBarの影の深さを設定する。
- `centerTitle`: タイトルを中央に配置するかどうかを設定する。
- `toolbarHeight`: AppBarの高さを設定する。
- `leadingWidth`: leadingウィジェットの幅を設定する。
- `automaticallyImplyLeading`: 自動的にleadingを追加するかどうかを設定する。

## 注意点

- `UniversalScaffold`と組み合わせて使用することで、自動的にSliverWidgetに変換される。
- デスクトップモードでは、`leading`と`actions`の配置が最適化される。
- モバイルモードでは、標準的なAppBarのレイアウトが適用される。
- `bottom`を設定する場合は、`PreferredSize`でラップする必要がある。
""";
  }
}
