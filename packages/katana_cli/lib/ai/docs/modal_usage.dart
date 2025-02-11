// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of modal_usage.mdc.
///
/// modal_usage.mdcの中身。
class ModalUsageMdcCliAiCode extends CliAiCode {
  /// Contents of modal_usage.mdc.
  ///
  /// modal_usage.mdcの中身。
  const ModalUsageMdcCliAiCode();

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
        - 例：
            ```dart
            class CustomModal extends Modal {
                @override
                Widget build(BuildContext context, ModalRef ref) {
                    return Container();
                }
            }
            ```
    - 作成した`Modal`を表示するには下記のようにする。
        ```dart
        Modal.show(context, modal: CustomModal());
        ```
""";
  }
}
