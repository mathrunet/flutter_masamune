// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of page_types.mdc.
///
/// page_types.mdcの中身。
class PageTypesMdcCliAiCode extends CliAiCode {
  /// Contents of page_types.mdc.
  ///
  /// page_types.mdcの中身。
  const PageTypesMdcCliAiCode();

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
| リストフォームビュー | `listform` | 入力・選択フォームが上から下に並んでおりスクロール可能なView。 |
| 固定フォームビュー | `fixedform` | スクロール不可で入力・選択フォームが固定されているView。 |
| ナビゲーションビュー | `navigation` | 下部に横並びでナビゲーションが配置され、メインスペースに別`Page`が表示されているView。 |
| タブビュー | `tab` | 上部に横並びでタブが配置され、タブを切り替えることで画面がスライドするView。 |
| その他 | `page` | その他通常の`Page`View。 |
""";
  }
}
