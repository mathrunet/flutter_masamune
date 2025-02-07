import 'package:katana_cli/katana_cli.dart';

/// Contents of state_management_usage.mdc.
///
/// state_management_usage.mdcの中身。
class StateManagementUsageMdcCliAiCode extends CliAiCode {
  /// Contents of state_management_usage.mdc.
  ///
  /// state_management_usage.mdcの中身。
  const StateManagementUsageMdcCliAiCode();

  @override
  String get name => "`State`の利用方法";

  @override
  String get description => "Masamuneフレームワークによる`State`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
`Page`や`Widget`、`Modal`、`Controller`や`RedirectQuery`内で利用される`State`は下記の方法で利用可能。

## `Model`や`Controller`、`RedirectQuery`

`Model`や`Controller`、`RedirectQuery`内では[main.dart](mdc:lib/main.dart)内で定義されている`appRef`を利用することにより`State`を利用可能。

- `Controller`の取得

    ```dart
    final controller = appRef.controller(AnyController.query());
    ```

- `Model`（`Collection`）の取得

    ```dart
    final collection = appRef.model(AnyModel.collection())..load();
    ```

    - `AnyModal.collection()`の後にメソッドチェーンをつなげることで取得する`Collection`の条件を指定可能。詳しくは[`Collection`のフィルタリング方法](mdc:.cursor/rules/docs/collection_filter.mdc)を参照。

- `Model`（`Document`）の取得

    ```dart
    final document = appRef.model(AnyModel.document())..load();
    ```

- `Plugin`のコントローラーの取得

    ```dart
    final pluginController = appRef.controller(AnyPlugin.query());
    ```

- フォームコントローラーの取得

    ```dart
    final formController = appRef.form(AnyModel.form(AnyModel()));
    ```


## `Page`（PageScopedWidgetを継承したもの）および`Widget`（ScopedWidgetを継承したもの）

Page（PageScopedWidgetを継承したもの）およびWidget（ScopedWidgetを継承したもの）内ではbuildメソッド内の`ref`を利用することにより`State`を利用可能。

- `Controller`の取得（アプリケーション全体にわたって状態が保持されるもの）

    ```dart
    final controller = ref.app.controller(AnyController.query());
    ```

- `Controller`の取得（`Page`内でのみ状態が保持されるもの）

    ```dart
    final controller = ref.page.controller(AnyController.query());
    ```

- `Model`（`Collection`）の取得

    ```dart
    final collection = ref.app.model(AnyModel.collection())..load();
    ```

    - `AnyModal.collection()`の後にメソッドチェーンをつなげることで取得する`Collection`の条件を指定可能。詳しくは[`Collection`のフィルタリング方法](mdc:.cursor/rules/docs/collection_filter.mdc)を参照。

- `Model`（`Document`）の取得

    ```dart
    final document = ref.app.model(AnyModel.document())..load();
    ```

- `Plugin`のコントローラーの取得

    ```dart
    final pluginController = ref.app.controller(AnyPlugin.query());
    ```

- フォームコントローラーの取得

    ```dart
    final formController = ref.page.form(AnyModel.form(AnyModel()));
    ```

- `Page`内でのみ保持される状態の取得

    ```dart
    final intState = ref.page.watch((_) => ValueNotifier<int>(0));
    final stringState = ref.page.watch((_) => ValueNotifier<String>(""));
    final boolState = ref.page.watch((_) => ValueNotifier<bool>(false));    
    ```

その他`ref`を用いて`Page`内部に状態を保持しながら利用できる機能が提供される

- `Page`の表示時、更新時、破棄時に処理を実行できる。

    ```dart
    ref.page.on(
      initOrUpdate: () {
        // `Page`が表示された時、または更新された時に実行される処理
      },
      disposed: () {
        // `Page`が破棄された時に実行される処理
      },
      keys: [
        // `Page`の表示時、更新時に実行される処理を特定するためのキー。このキーの中身が変更されると再度`initOrUpdate`が実行される。
      ],
    );
    ```

- 一定時間ごとに毎回処理を実行する。

    ```dart
    ref.page.periodic(
      (DateTime currentTime, DateTime startTime) {
        // 一定時間ごとに実行される処理
      },
      // 実行間隔
      duration: Duration(seconds: 1),
    );
    ```

- 一定時間後に処理を実行する。

    ```dart
    ref.page.timer(
      (DateTime currentTime, DateTime startTime) {
        // 一定時間後に実行される処理
      },
      // 処理を実行するまでの遅延時間
      duration: Duration(seconds: 1),
    );
    ```

- 指定した時間に処理を実行する。

    ```dart
    ref.page.schedule(
      (DateTime currentTime, DateTime startTime) {
        // 指定した時間に実行される処理
      },
      // 実行日時
      dateTime: DateTime.now().add(Duration(seconds: 1)),
    );
    ```

- `FutureOr`を渡して非同期処理を実行後`Page`や`Widget`の描画を更新する。

    ```dart
    ref.page.future(
      () async {
        // 非同期処理
      },
    );
    ```

- `Page`や`Widget`の描画を更新する。

    ```dart
    ref.refresh();
    ```
""";
  }
}
