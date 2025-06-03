// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of page_logic_impl.md.
///
/// page_logic_impl.mdの中身。
class PageLogicImplMdCliAiCode extends CliAiCode {
  /// Contents of page_logic_impl.md.
  ///
  /// page_logic_impl.mdの中身。
  const PageLogicImplMdCliAiCode();

  @override
  String get name => "`Page`のロジック実装";

  @override
  String get globs => "lib/pages/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Page設計書`を用いた`Page`のロジック実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/page_design.md`に記載されている`Page設計書`と`lib/pages`に作成されているDartファイルを参照して`Page`のロジックを実装
`documents/designs/page_design.md`が存在しない場合は絶対に実施しない

`Page設計書`に記載されている各`Page`の`PageType`に応じてそれぞれ下記を実行

## `listview`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the variable loading process.`以下に`ref`を用いてプロジェクト内の各種`Model`や`Controller`を取得する。
    - 適宜`import`を追加する
    - `Model`や`Controller`の取得方法は下記を参照。
        - `Model`や`Controller`の取得方法(`documents/rules/docs/state_management_usage.md`)
        - `Model`の利用方法(`documents/rules/docs/model_usage.md`)
    - 例：
        ```dart
        // TODO: Implement the variable loading process.
        final memoController = ref.app.controller(MemoController.query());
        final memoCollection = ref.app.model(MemoModel.collection())..load();
        final memoState = ref.page.watch((_) => ValueNotifier<bool>(false));
        ```

## `gridview`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the variable loading process.`以下に`ref`を用いてプロジェクト内の各種`Model`や`Controller`を取得する。
    - 適宜`import`を追加する
    - `Model`や`Controller`の取得方法は下記を参照。
        - `Model`や`Controller`の取得方法(`documents/rules/docs/state_management_usage.md`)
        - `Model`の利用方法(`documents/rules/docs/model_usage.md`)
    - 例：
        ```dart
        // TODO: Implement the variable loading process.
        final memoController = ref.app.controller(MemoController.query());
        final memoCollection = ref.app.model(MemoModel.collection())..load();
        final memoState = ref.page.watch((_) => ValueNotifier<bool>(false));
        ```

## `fixedview`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the variable loading process.`以下に`ref`を用いてプロジェクト内の各種`Model`や`Controller`を取得する。
    - 適宜`import`を追加する
    - `Model`や`Controller`の取得方法は下記を参照。
        - `Model`や`Controller`の取得方法(`documents/rules/docs/state_management_usage.md`)
        - `Model`の利用方法(`documents/rules/docs/model_usage.md`)
    - 例：
        ```dart
        // TODO: Implement the variable loading process.
        final memoController = ref.app.controller(MemoController.query());
        final memoCollection = ref.app.model(MemoModel.collection())..load();
        final memoState = ref.page.watch((_) => ValueNotifier<bool>(false));
        ```

## `fixedform`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the variable loading process.`以下に`ref`を用いてプロジェクト内の各種`Model`や`Controller`を取得する。
    - 適宜`import`を追加する
    - `Model`や`Controller`の取得方法は下記を参照。
        - `Model`や`Controller`の取得方法(`documents/rules/docs/state_management_usage.md`)
        - `Model`の利用方法(`documents/rules/docs/model_usage.md`)
        - `FormController`の利用方法(`documents/rules/docs/form_usage.md`)
    - 例：
        ```dart
        // TODO: Implement the variable loading process.
        final memoController = ref.app.controller(MemoController.query());
        final memoCollection = ref.app.model(MemoModel.collection())..load();
        final memoState = ref.page.watch((_) => ValueNotifier<bool>(false));
        final formController = ref.app.form(MemoModel.form(MemoModel()));
        ```

## `listform`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the variable loading process.`以下に`ref`を用いてプロジェクト内の各種`Model`や`Controller`を取得する。
    - 適宜`import`を追加する
    - `Model`や`Controller`の取得方法は下記を参照。
        - `Model`や`Controller`の取得方法(`documents/rules/docs/state_management_usage.md`)
        - `Model`の利用方法(`documents/rules/docs/model_usage.md`)
        - `FormController`の利用方法(`documents/rules/docs/form_usage.md`)
    - 例：
        ```dart
        // TODO: Implement the variable loading process.
        final memoController = ref.app.controller(MemoController.query());
        final memoCollection = ref.app.model(MemoModel.collection())..load();
        final memoState = ref.page.watch((_) => ValueNotifier<bool>(false));
        final formController = ref.app.form(MemoModel.form(MemoModel()));
        ```

## `navigation`

実施しない

## `tab`

実施しない

## `page`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the variable loading process.`以下に`ref`を用いてプロジェクト内の各種`Model`や`Controller`を取得する。
    - 適宜`import`を追加する
    - `Model`や`Controller`の取得方法は下記を参照。
        - `Model`や`Controller`の取得方法(`documents/rules/docs/state_management_usage.md`)
        - `Model`の利用方法(`documents/rules/docs/model_usage.md`)
    - 例：
        ```dart
        // TODO: Implement the variable loading process.
        final memoController = ref.app.controller(MemoController.query());
        final memoCollection = ref.app.model(MemoModel.collection())..load();
        final memoState = ref.page.watch((_) => ValueNotifier<bool>(false));
        ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
