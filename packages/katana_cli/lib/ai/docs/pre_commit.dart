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

- コミット前に下記作業を実施してコードの品質と安全性を保つ。
    1. 下記のコマンドを実施してコードのフォーマットを行う。
        ```bash
        dart fix --apply lib && dart format . && flutter pub run import_sorter:main
        ```

    2. 下記のコマンドを実施してコードのバリデーションを行う。エラーがあれば修正。
        ```bash
        flutter analyze && dart run custom_lint
        ```

    3. `Page`や`Widget`、`Model`の`toTile`のエクステンションの更新が行われていた場合は、下記のコマンドを実施してゴールデンテスト用の画像を更新する。エラーがあれば修正。
        - 各種UIが更新されているにも関わらずこのステップが実行されない場合は`flutter test`でエラーになります。

        ```bash
        katana test update [テスト対象のクラス名],[テスト対象のクラス名],...
        ```

        - 例:
            ```bash
            katana test update TestPage,TestWidget,TestModel
            ```

    4. 下記のコマンドを実施して全体のテストを行う。エラーがあれば修正。
        ```bash
        flutter test --dart-define=CI=true --dart-define=FLAVOR=dev
        ```

    - これらの作業を実施してエラーが出た場合は該当箇所を修正し再度1から実施してください。
    - すべての作業がエラーなく完了した場合はコミットを行い、必要であればPullRequestを作成してください。
""";
  }
}
