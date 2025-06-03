// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of router_usage.md.
///
/// router_usage.mdの中身。
class RouterUsageMdCliAiCode extends CliAiCode {
  /// Contents of router_usage.md.
  ///
  /// router_usage.mdの中身。
  const RouterUsageMdCliAiCode();

  @override
  String get name => "`Router`の利用方法";

  @override
  String get description => "`Page`を遷移する際に利用する`Router`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
`Page`を遷移する際に利用する`Router`の利用方法を下記に記載する。
`Router`は`lib/router.dart`で定義されているため適宜`lib/router.dart`をインポートする。

## 通常利用

- 履歴を残して次のページに遷移

    ```dart
    final result = await router.push(NextPage.query());
    ```

    - `result`には遷移先のページでpopメソッドが実行された時に引数に渡された値が返却される。
        - 遷移先のページでpopメソッドが実行されるまではawaitが完了しない。
    - pushメソッド内で`TransitionQuery`を渡すことで`遷移時のアニメーション`(`documents/rules/docs/transition_usage.md`)を設定可能。

        ```dart
        router.push(NextPage.query(), transition: TransitionQuery.fullscreen);
        ```

- 現在のページの履歴を破棄して次のページに遷移

    ```dart
    router.replace(NextPage.query());
    ```

    - replaceメソッド内で`TransitionQuery`を渡すことで`遷移時のアニメーション`(`documents/rules/docs/transition_usage.md`)を設定可能。

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
    - pushメソッド内で`TransitionQuery`を渡すことで`遷移時のアニメーション`(`documents/rules/docs/transition_usage.md`)を設定可能。

        ```dart
        context.router.push(NextPage.query(), transition: TransitionQuery.fullscreen);
        ```

- 現在のページの履歴を破棄して次のページに遷移

    ```dart
    context.router.replace(NextPage.query());
    ```

    - replaceメソッド内で`TransitionQuery`を渡すことで`遷移時のアニメーション`(`documents/rules/docs/transition_usage.md`)を設定可能。

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

## 初回表示ページの設定

- `Router`の設定は`lib/router.dart`の`AppRouter`の`initialQuery`に設定する。
    - また`pages`に各ページの`RouteQueryBuilder`を設定することでWebにおけるURLの直接指定による起動が可能。
    
    ```dart
    // lib/router.dart

    final router = AppRouter(
      boot: null,
      initialQuery: InitialPage.query(), // 初回ページの設定
      redirect: [],
      pages: [
        IndexPage.query, // PagePathが`/`の場合に表示されるページ
        LoginPage.query, // PagePathが`/login`の場合に表示されるページ
        RegisterPage.query, // PagePathが`/register`の場合に表示されるページ
      ],
    );
    ```

## `Boot`ページの設定

- `Boot`ページはアプリの起動時に表示されるページ。
    - アプリのロゴの表示や最初に必ず実行しておきたい初期化処理やデータの読み込み処理を行う。

### `Boot`ページの作成

- 下記のコマンドを実行して`lib/boot.dart`に`Boot`ページを作成する。

    ```bash
    katana code boot
    ```

    - `lib/boot.dart`に`Boot`ページが作成される。
    - その後、`build`メソッド内にアプリのロゴの表示を記載し、`onInit`メソッド内に最初に必ず実行しておきたい初期化処理やデータの読み込み処理を行う。`onInit`の処理が失敗した場合のエラー表示を`onError`メソッド内に記載する。
    - 例:
        ```dart
        // lib/boot.dart

        @immutable
        class Boot extends BootRouteQueryBuilder {
          const Boot({super.key});

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              backgroundColor: theme.color.primary,
              body: Center(
                child: Image(
                  width: 128,
                  image: theme.asset.icon.provider,
                ),
              ),
            );
          }

          @override
          FutureOr<void> onInit(BuildContext context) async {
            await wait(
              [
                appAuth.tryRestoreAuth(),
              ],
            );
          }

          @override
          void onError(
              BuildContext context, BootRef ref, Object error, StackTrace stackTrace) {
            Modal.alert(
              context,
              submitText: "閉じる",
              title: "エラー",
              text: "初期化に失敗しました。",
              onSubmit: () {
                ref.quit();
              },
            );
          }

          @override
          TransitionQuery get initialTransitionQuery => TransitionQuery.fade;
        }
        ```

- `Boot`ページの設定は`lib/router.dart`の`AppRouter`の`boot`に設定する。

    ```dart
    // lib/router.dart

    final router = AppRouter(
      boot: const Boot(), // `Boot`ページの設定
      initialQuery: InitialPage.query(), // 初回ページの設定
      redirect: [],
      pages: [
        IndexPage.query, // PagePathが`/`の場合に表示されるページ
        LoginPage.query, // PagePathが`/login`の場合に表示されるページ
        RegisterPage.query, // PagePathが`/register`の場合に表示されるページ
      ],
    );
    ```
""";
  }
}
