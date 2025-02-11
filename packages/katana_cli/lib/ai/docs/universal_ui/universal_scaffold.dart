// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_scaffold.mdc.
///
/// universal_scaffold.mdcの中身。
class UniversalScaffoldMdcCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_scaffold.mdc.
  ///
  /// universal_scaffold.mdcの中身。
  const UniversalScaffoldMdcCliAiCode();

  @override
  String get name => "`UniversalScaffold`の利用方法";

  @override
  String get description =>
      "`Scaffold`の`UniversalUI`版である`UniversalScaffold`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`Scaffold`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。`appBar`、`body`、`drawer`、`bottomNavigationBar`などの基本的なScaffoldの機能に加え、`slivers`を使用したカスタムレイアウトが可能。";

  @override
  String body(String baseName, String className) {
    return r"""
`UniversalScaffold`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalScaffold(
    appBar: UniversalAppBar(
        title: const Text("アプリタイトル"),
    ),
    drawer: Drawer(
        child: ListView(
            children: [
                const DrawerHeader(
                    child: Text("メニュー"),
                ),
                ListTile(
                    title: const Text("メニュー1"),
                    onTap: () {
                        // TODO: Implement the menu action.
                    },
                ),
            ],
        ),
    ),
    body: const Center(
        child: Text("コンテンツ"),
    ),
    bottomNavigationBar: BottomNavigationBar(
        items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "ホーム",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "設定",
            ),
        ],
        onTap: (index) {
            // TODO: Implement the navigation action.
        },
    ),
);
```

## プロパティ

- `appBar`: アプリケーションバーを設定する。
- `body`: メインコンテンツを設定する。
- `drawer`: ドロワーメニューを設定する。
- `endDrawer`: 右側のドロワーメニューを設定する。
- `bottomNavigationBar`: 下部のナビゲーションバーを設定する。
- `floatingActionButton`: フローティングアクションボタンを設定する。
- `backgroundColor`: 背景色を設定する。
- `resizeToAvoidBottomInset`: キーボードが表示された際に自動的にリサイズするかどうかを設定する。
- `slivers`: カスタムスクロール可能なウィジェットのリストを設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。

## 注意点

- デスクトップモードでは、`drawer`が常に表示され、`bottomNavigationBar`が非表示になる。
- モバイルモードでは、標準的なScaffoldのレイアウトが適用される。
- `slivers`を使用する場合、`body`は無視される。
- `UniversalAppBar`と組み合わせることで、より柔軟なレイアウトが可能。
- `breakpoint`を設定することで、カスタムのレスポンシブ対応が可能。
""";
  }
}
