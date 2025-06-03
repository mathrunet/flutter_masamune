// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of router_impl.md.
///
/// router_impl.mdの中身。
class RouterImplMdCliAiCode extends CliAiCode {
  /// Contents of router_impl.md.
  ///
  /// router_impl.mdの中身。
  const RouterImplMdCliAiCode();

  @override
  String get name => "`Router`の実装";

  @override
  String get globs => "lib/router.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Page設計書`を用いた`Router`の設定方法";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/page_design.md`に記載されている`Page設計書`から`lib/router.dart`を編集
`documents/designs/page_design.md`が存在しない場合は絶対に実施しない

1. `Page設計書`で定義されている内容を元に`lib/router.dart`を書き換える
    - `lib/router.dart`の`AppRouter`を変更
      - `Page`の中でトップページとなる`Page`を選出
        - 基本的には`PagePath`が`/`の`Page``を設定
      - `AppRouter`の`initialQuery`にトップページの`Page`に対する`[PageID(PascalCase&末尾にPageが付与されている)].query()`を設定

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
