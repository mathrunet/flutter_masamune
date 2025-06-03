// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of widget_impl.md.
///
/// widget_impl.mdの中身。
class WidgetImplMdCliAiCode extends CliAiCode {
  /// Contents of widget_impl.md.
  ///
  /// widget_impl.mdの中身。
  const WidgetImplMdCliAiCode();

  @override
  String get name => "`Widget`の実装";

  @override
  String get globs => "lib/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Widget設計書`を用いた`Widget`の実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/widget_design.md`に記載されている`Widget設計書`から`Widget`を作成し実装
下記の順番通りにステップごとに実施

1. `Widget`の作成
    - `documents/rules/impls/widget_creation.md`を参照して、`Widget`を作成
2. `Widget`のロジックの実装
    - 1で作成した`Widget`に対して、`documents/rules/impls/widget_logic_impl.md`を参照して、`Widget`のロジックを実装
3. `Widget`のUIの実装
    - 1で作成した`Widget`に対して、2で作成した`Widget`のロジックを用いながら`documents/rules/impls/widget_ui_impl.md`を参照して、`Widget`のUIを実装

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
