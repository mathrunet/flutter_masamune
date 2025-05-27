// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_search_bar.md.
///
/// universal_search_bar.mdの中身。
class UniversalSearchBarMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_search_bar.md.
  ///
  /// universal_search_bar.mdの中身。
  const UniversalSearchBarMdCliAiCode();

  @override
  String get name => "`UniversalSearchBar`の利用方法";

  @override
  String get description =>
      "`SearchBar`の`UniversalUI`版である`UniversalSearchBar`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`SearchBar`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。検索機能を提供し、`onSearch`、`onChanged`などのコールバックを設定可能。";

  @override
  String body(String baseName, String className) {
    return r"""
`UniversalSearchBar`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalSearchBar(
    hintText: "検索",
    onSearch: (value) {
        // TODO: Implement the search action.
    },
    onChanged: (value) {
        // TODO: Implement the text changed action.
    },
    leading: const Icon(Icons.search),
    trailing: [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
                // TODO: Implement the clear action.
            },
        ),
    ],
);
```

## プロパティ

- `hintText`: 検索バーのプレースホルダーテキストを設定する。
- `onSearch`: 検索実行時のコールバックを設定する。
- `onChanged`: テキスト変更時のコールバックを設定する。
- `leading`: 検索バーの左側に表示するウィジェットを設定する。
- `trailing`: 検索バーの右側に表示するウィジェットのリストを設定する。
- `controller`: テキストコントローラーを設定する。
- `focusNode`: フォーカスノードを設定する。
- `decoration`: 検索バーの装飾を設定する。
- `maxWidth`: 検索バーの最大幅を設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。

## 注意点

- デスクトップモードでは、`maxWidth`が適用され、検索バーが中央に配置される。
- モバイルモードでは、画面幅いっぱいに検索バーが表示される。
- `onSearch`は、Enterキーを押すか、検索アイコンをタップした時に呼び出される。
- `onChanged`は、テキストが変更される度に呼び出される。
- `UniversalScaffold`と組み合わせることで、より柔軟なレイアウトが可能。
""";
  }
}
