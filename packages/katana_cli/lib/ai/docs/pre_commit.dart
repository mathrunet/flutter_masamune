// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of pre_commit.md.
///
/// pre_commit.mdの中身。
class PreCommitMdCliAiCode extends CliAiCode {
  /// Contents of pre_commit.md.
  ///
  /// pre_commit.mdの中身。
  const PreCommitMdCliAiCode();

  @override
  String get name => "コミット前のチェック作業について";

  @override
  String get description => "コミット前のチェック作業について";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## コミット前のチェック作業について。

- コミット前に必ず下記を実施しコードの品質と安全性を保つ。
    1. 下記のコマンドを実施してコードのフォーマットを行う。
        ```bash
        dart fix --apply lib && dart format . && flutter pub run import_sorter:main
        ```

    2. 下記のコマンドを実施してコードのバリデーションを行う。ErrorやWarningがあれば修正して再度実行。ErrorやWarningがなくなるまで繰り返す。
        ```bash
        flutter analyze && dart run custom_lint

    3. `Page`や`Widget`、`Model`の`toTile`のエクステンションの更新が行われていた場合は、下記のコマンドを実施してゴールデンテスト用の画像を更新する。ErrorやWarningがあれば修正して再度実行。ErrorやWarningがなくなるまで繰り返す。
        - 各種UIが更新されているにも関わらずこのステップが実行されない場合は`katana test debug`でエラーになります。

        ```bash
        katana test update [テスト対象のクラス名],[テスト対象のクラス名],...
        ```

        - 出力先: `documents/test/**/*.png`
        - 例:
            ```bash
            katana test update TestPage,TestWidget,TestModel
            ```
        ```

    4. 下記のコマンドを実施して全体のテストを行う。ErrorやWarningがあれば修正して再度実行。ErrorやWarningがなくなるまで繰り返す。
        ```bash
        katana test debug
        ```

    5. 1〜4のステップでエラーやWarningが発生した場合は、再度1からステップをやり直す。エラーやWarningがなくなるまで繰り返す。

    6. **Claudeでコミットする場合のみ**、エラーがなくなったら下記のコマンドを実施してCI用のゴールデンテスト画像を生成する。
        - **重要**: このコマンドはDocker使用のため非常に時間がかかります。Claudeでコミット作業を行う直前に1度だけ実行してください。
        - **注意**: CI環境（`katana test run`）と同一条件で画像を生成するためDocker環境が必要です。
        - 各種UIが更新されているにも関わらずこのステップが実行されない場合はCI内の`katana test run`でエラーになります。

        ```bash
        katana test build [テスト対象のクラス名],[テスト対象のクラス名],...
        ```

        - 出力先: `documents/test/**/*.png`（CI環境と同一条件の画像）
        - 例:
            ```bash
            katana test build TestPage,TestWidget,TestModel
            ```
""";
  }
}
