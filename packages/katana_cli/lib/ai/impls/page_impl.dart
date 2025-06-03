// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of page_impl.md.
///
/// page_impl.mdの中身。
class PageImplMdCliAiCode extends CliAiCode {
  /// Contents of page_impl.md.
  ///
  /// page_impl.mdの中身。
  const PageImplMdCliAiCode();

  @override
  String get name => "`Page`の実装";

  @override
  String get globs => "lib/pages/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Page設計書`を用いた`Page`の実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/page_design.md`に記載されている`Page設計書`から`Page`を作成し実装
下記の順番通りにステップごとに実施

1. `Page`の作成
    - `documents/rules/impls/page_creation.md`を参照して、`Page`を作成
2. `Page`のロジックの実装
    - 1で作成した`Page`に対して、`documents/rules/impls/page_logic_impl.md`を参照して、`Page`のロジックを実装
3. `Page`のUIの実装
    - 1で作成した`Page`に対して、2で作成した`Page`のロジックを用いながら`documents/rules/impls/page_ui_impl.md`を参照して、`Page`のUIを実装

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
