import 'package:katana_cli/katana_cli.dart';

/// Contents of router_usage.mdc.
///
/// router_usage.mdcの中身。
class RouterUsageMdcCliAiCode extends CliAiCode {
  /// Contents of router_usage.mdc.
  ///
  /// router_usage.mdcの中身。
  const RouterUsageMdcCliAiCode();

  @override
  String get name => "`Router`の利用方法";

  @override
  String get description => "Masamuneフレームワークによる`Router`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
`Page`を遷移する際の`Router`の利用は下記のように行う。

## 通常利用

- 履歴を残して次のページに遷移

    ```dart
    final result = await router.push(NextPage.query());
    ```

    - `result`には遷移先のページでpopメソッドが実行された時に引数に渡された値が返却される。
        - 遷移先のページでpopメソッドが実行されるまではawaitが完了しない。
    - pushメソッド内で`TransitionQuery`を渡すことで[遷移時のアニメーション](mdc:.cursor/rules/docs/transition_usage.mdc)を設定可能。

        ```dart
        router.push(NextPage.query(), transition: TransitionQuery.fullscreen);
        ```

- 現在のページの履歴を破棄して次のページに遷移

    ```dart
    router.replace(NextPage.query());
    ```

    - replaceメソッド内で`TransitionQuery`を渡すことで[遷移時のアニメーション](mdc:.cursor/rules/docs/transition_usage.mdc)を設定可能。

        ```dart
        router.replace(NextPage.query(), transition: TransitionQuery.fullscreen);
        ```

- 前の履歴のページに戻る

    ```dart
    router.pop([returnValue]);
    ```

    - popメソッド内に`returnValue`を渡すことで前のページに戻る時に値を渡すことが可能（任意）

- すべての履歴を削除して指定のページに遷移

    ```dart
    router.resetAndPush(NextPage.query());
    ```


## ネストされた`Page`（`Page`内に表示された`Page`）での`Router`の利用

- 履歴を残して次のページに遷移

    ```dart
    final result = await context.router.push(NextPage.query());
    ```

    - `result`には遷移先のページでpopメソッドが実行された時に引数に渡された値が返却される。
        - 遷移先のページでpopメソッドが実行されるまではawaitが完了しない。
    - pushメソッド内で`TransitionQuery`を渡すことで[遷移時のアニメーション](mdc:.cursor/rules/docs/transition_usage.mdc)を設定可能。

        ```dart
        context.router.push(NextPage.query(), transition: TransitionQuery.fullscreen);
        ```

- 現在のページの履歴を破棄して次のページに遷移

    ```dart
    context.router.replace(NextPage.query());
    ```

    - replaceメソッド内で`TransitionQuery`を渡すことで[遷移時のアニメーション](mdc:.cursor/rules/docs/transition_usage.mdc)を設定可能。

        ```dart
        context.router.replace(NextPage.query(), transition: TransitionQuery.fullscreen);
        ```

- 前の履歴のページに戻る

    ```dart
    context.router.pop([returnValue]);
    ```

    - popメソッド内に`returnValue`を渡すことで前のページに戻る時に値を渡すことが可能（任意）

- すべての履歴を削除して指定のページに遷移

    ```dart
    context.router.resetAndPush(NextPage.query());
    ```
""";
  }
}
