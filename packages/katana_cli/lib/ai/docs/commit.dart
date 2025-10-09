// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of commit.md.
///
/// commit.mdの中身。
class CommitMdCliAiCode extends CliAiCode {
  /// Contents of commit.md.
  ///
  /// commit.mdの中身。
  const CommitMdCliAiCode();

  @override
  String get name => "コミット方法について";

  @override
  String get description => "コミット方法について";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## コミット方法について。

- コミット前には必ず下記の作業を実施する。
    - `documents/rules/docs/pre_commit.md`を参照してコミット前のチェック作業を実施する。

- コミット方法は下記の通り。
    1. 下記コマンドで変更をCommit&Push。
        
        ```bash
        katana git commit --message="コミットメッセージ" [コミット対象のファイル1] [コミット対象のファイル2] ...
        ```

        - 変更したファイルおよび下記のファイルも必ず含める。基本的には.gitignoreで除外されているファイル以外で生成・変更されたファイルはすべてコミット。
            - `katana code **`で生成した、もしくは変更したファイル
            - `katana code generate`で生成した、もしくは変更されたファイル
            - `katana test update`で生成した、もしくは変更されたファイル
    
    2. PullRequestを新しく作成するは下記のコマンドでPullRequestを作成。

        ```bash
        katana git pull_request --target="マージ先のブランチ" --source="マージ元のブランチ" --title="PullRequestのタイトル" --body="PullRequestの説明（改行は`\\n`で行う）" [PullRequestの説明に加えるスクリーンショットのファイル1] [PullRequestの説明に加えるスクリーンショットのファイル2] ...
        ```

        - 1のコミットの中`katana test update`で生成した画像(`documents/test/**/*.png`)を「PullRequestの説明に加えるスクリーンショットのファイル」として指定する。

    3. PullRequestがすでに作成されており、さらにコメントを追加したい場合は下記のコマンドを用いてコメントを追加。

        ```bash
        katana git pull_request_comment --comment="PullRequestのコメント" --target="マージ先のブランチ" --source="マージ元のブランチ" [PullRequestのコメントに加えるスクリーンショットのファイル1] [PullRequestのコメントに加えるスクリーンショットのファイル2] ...
        ```

        - 1のコミットの中`katana test update`で生成した画像(`documents/test/**/*.png`)を「PullRequestのコメントに加えるスクリーンショットのファイル」として指定する。
""";
  }
}
