// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_side_bar.mdc.
///
/// universal_side_bar.mdcの中身。
class UniversalSideBarMdcCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_side_bar.mdc.
  ///
  /// universal_side_bar.mdcの中身。
  const UniversalSideBarMdcCliAiCode();

  @override
  String get name => "`UniversalSideBar`の利用方法";

  @override
  String get description =>
      "`SideBar`の`UniversalUI`版である`UniversalSideBar`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`Drawer`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。サイドバーとして使用することを想定したウィジェット。デスクトップモードでは常に表示され、モバイルモードではドロワーとして表示される。";

  @override
  String body(String baseName, String className) {
    return r"""
`UniversalSideBar`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalSideBar(
    width: 300,
    header: const UniversalHeaderTile(
        title: Text("メニュー"),
    ),
    children: [
        ListTile(
            leading: const Icon(Icons.home),
            title: const Text("ホーム"),
            onTap: () {
                // TODO: Implement the home action.
            },
        ),
        ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("設定"),
            onTap: () {
                // TODO: Implement the settings action.
            },
        ),
    ],
);
```

## プロパティ

- `width`: サイドバーの幅を設定する。
- `header`: サイドバーのヘッダーを設定する。
- `children`: サイドバーに表示するウィジェットのリストを設定する。
- `backgroundColor`: サイドバーの背景色を設定する。
- `elevation`: サイドバーの影の深さを設定する。
- `padding`: サイドバーの内側の余白を設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。

## 注意点

- デスクトップモードでは、常に表示される固定のサイドバーとして機能する。
- モバイルモードでは、ドロワーとして表示され、ハンバーガーメニューから開閉できる。
- `UniversalScaffold`と組み合わせることで、自動的にレスポンシブ対応が行われる。
- `header`には`UniversalHeaderTile`を使用することを推奨する。
- `width`はデスクトップモードでのみ有効で、モバイルモードでは画面幅の80%が適用される。
""";
  }
}
