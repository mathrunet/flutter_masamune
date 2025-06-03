// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of page_types.md.
///
/// page_types.mdの中身。
class PageTypesMdCliAiCode extends CliAiCode {
  /// Contents of page_types.md.
  ///
  /// page_types.mdの中身。
  const PageTypesMdCliAiCode();

  @override
  String get name => "`PageType`の一覧とその概要";

  @override
  String get description => "`Page`のテンプレートである`PageType`の一覧とその概要";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
`Page`のテンプレートである`PageType`の一覧とその概要を下記に記載する。

## `PageType`一覧

| PageType | PageTypeID | 概要 |
| --- | --- | --- |
| リストビュー | `listview` | 上から下に要素が並んでおりスクロール可能なView。 |
| グリッドビュー | `gridview` | 上から下に格子状に要素が並んでおりスクロール可能なView。 |
| 固定ビュー | `fixedview` | スクロール不可で各要素が固定されているView。 |
| リストフォームビュー（新規追加） | `listform_add` | 入力・選択フォームが上から下に並んでおりスクロール可能なView。新規追加時に使用。 |
| 固定フォームビュー（新規追加） | `fixedform_add` | スクロール不可で入力・選択フォームが固定されているView。新規追加時に使用。 |
| リストフォームビュー（既存編集） | `listform_edit` | 入力・選択フォームが上から下に並んでおりスクロール可能なView。既存項目編集時に使用。 |
| 固定フォームビュー（既存編集） | `fixedform_edit` | スクロール不可で入力・選択フォームが固定されているView。既存項目編集時に使用。 |
| ナビゲーションビュー | `navigation` | 下部に横並びでナビゲーションが配置され、メインスペースに別`Page`が表示されているView。 |
| タブビュー | `tab` | 上部に横並びでタブが配置され、タブを切り替えることで画面がスライドするView。 |
| その他 | `page` | その他通常の`Page`View。 |
""";
  }
}
