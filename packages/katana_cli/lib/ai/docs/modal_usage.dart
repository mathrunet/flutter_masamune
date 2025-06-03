// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of modal_usage.md.
///
/// modal_usage.mdの中身。
class ModalUsageMdCliAiCode extends CliAiCode {
  /// Contents of modal_usage.md.
  ///
  /// modal_usage.mdの中身。
  const ModalUsageMdCliAiCode();

  @override
  String get name => "`Modal`の実装方法";

  @override
  String get description => "アラートやダイアログの表示を行うための`Modal`の実装方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
`Modal`には下記の3種類存在する。それぞれ目的に応じて実装する。

## AlertModal

- ユーザーに情報を伝えるためのモーダル。
    - 下記の要素が利用可能
        - `タイトル`
        - `メッセージ`
        - `確定ボタン`
    - エラーメッセージやお知らせダイアログなどユーザーにメッセージを表示し知らせるために利用する。
    - 例：
        ```dart
        Modal.alert(
            context,
            title: "タイトル",
            text: "メッセージ（Optional）",
            submitText: "確定ボタンのテキスト",
            onSubmit: () {
                // 確定ボタンが押された時の処理
            },
        );
        ```

## ConfirmModal

- ユーザーの同意を得るためのモーダル。
    - 下記の要素が利用可能
        - `タイトル`
        - `メッセージ`
        - `確定ボタン`
        - `キャンセルボタン`
    - ユーザーに選択肢を選ばせるためのダイアログやユーザーの同意を得るためのダイアログに利用する。
    - 例：
        ```dart
        Modal.confirm(
            context,
            title: "タイトル",
            text: "メッセージ（Optional）",
            submitText: "確定ボタンのテキスト",
            cancelText: "キャンセルボタンのテキスト",
            onSubmit: () {
                // 確定ボタンが押された時の処理
            },
            onCancel: () {
                // キャンセルボタンが押された時の処理（Optional）
            },
        );
        ```

## CustomModal

- 自由にカスタマイズ可能なモーダル。
    - 自由にウィジェットを作成し表示することが可能。
    - `Modal`クラスを拡張して作成する。
    - 作成手順
        1. 下記のコマンドを実行して`lib/modals`フォルダにカスタム`Modal`クラスを作成する。

            ```bash
            katana code modal [ModalName(SnakeCase)]
            ```

        2. `lib/modals/[ModalName(SnakeCase)].dart`にカスタム`Modal`クラスが作成される。
            - 例：
                ```dart
                // lib/modals/test.dart

                /// Modal widget for Test.
                @immutable
                class TestModal extends Modal {
                  const TestModal();

                  @override
                  Widget build(BuildContext context, ModalRef ref) {
                    // Describes the structure of the modal.
                    // TODO: Implement the view.
                    return const Empty();
                  }
                }
                ```
        3. 作成した`Modal`クラスを表示するには下記のようにする。
            ```dart
            Modal.show(context, modal: TestModal());
            ```
""";
  }
}
