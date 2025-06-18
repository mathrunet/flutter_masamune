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

    2. 下記のコマンドを実施してコードのバリデーションを行う。Issueがあれば修正。
        ```bash
        flutter analyze && dart run custom_lint
        ```

    3. `Page`や`Widget`、`Model`の`toTile`のエクステンションの更新が行われていた場合は、下記のコマンドを実施してゴールデンテスト用の画像を更新する。エラーやIssueがあれば修正。
        - 各種UIが更新されているにも関わらずこのステップが実行されない場合は`katana test run`でエラーになります。

        ```bash
        katana test update [テスト対象のクラス名],[テスト対象のクラス名],...
        ```

        - 例:
            ```bash
            katana test update TestPage,TestWidget,TestModel
            ```

    4. 下記のコマンドを実施して全体のテストを行う。エラーやIssueがあれば修正。
        ```bash
        katana test run
        ```

    5. 1〜4のステップでエラーやIssueが発生した場合は、再度1からステップをやり直す。エラーやIssueが無くなるまで繰り返す。

    6. 下記コマンドで変更をCommit&Push。
        
        ```bash
        katana git commit --message="コミットメッセージ" [コミット対象のファイル1] [コミット対象のファイル2] ...
        ```

        - 変更したファイルおよび下記のファイルも必ず含める。基本的には.gitignoreで除外されているファイル以外で生成・変更されたファイルはすべてコミット。
            - `katana code **`で生成した、もしくは変更したファイル
            - `katana code generate`で生成した、もしくは変更されたファイル
            - `katana test update`で生成した、もしくは変更されたファイル
    
    7. PullRequestが必要な場合は下記のコマンドでPullRequestを作成。

        ```bash
        katana git pull_request --target="マージ先のブランチ" --source="マージ元のブランチ" --title="PullRequestのタイトル" --body="PullRequestの説明（改行は`\\n`で行う）" [PullRequestの説明に加えるスクリーンショットのファイル1] [PullRequestの説明に加えるスクリーンショットのファイル2] ...
        ```

        - 6のコミットの中`katana test update`で生成した画像(`documents/test/**/*.png`)を「PullRequestの説明に加えるスクリーンショットのファイル」として指定する。
""";
  }
}
