// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add automatic review function for pull requests using GPT.
///
/// GPTを利用したプルリクエスト用の自動レビュー機能を追加します。
class GitReviewCliAction extends CliCommand with CliActionMixin {
  /// Add automatic review function for pull requests using GPT.
  ///
  /// GPTを利用したプルリクエスト用の自動レビュー機能を追加します。
  const GitReviewCliAction();

  @override
  String get description =>
      "Add automatic review function for pull requests using GPT. GPTを利用したプルリクエスト用の自動レビュー機能を追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("github").getAsMap("review");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final gh = bin.get("gh", "gh");
    final github = context.yaml.getAsMap("github");
    final review = github.getAsMap("review");

    final openAPIKey = review.get("openai_api_key", "");
    if (openAPIKey.isEmpty) {
      error(
        "There is no [github]->[review]->[openai_api_key], please get OpenAI API key from [https://platform.openai.com/settings/profile?tab=api-keys].",
      );
      return;
    }
    await command(
      "Set OpenAIApiKey in `secrets.OPENAI_API_KEY`.",
      [
        gh,
        "secret",
        "set",
        "OPENAI_API_KEY",
        "--body",
        openAPIKey,
      ],
    );
    label("Create review.yaml");
    final gitDir = await findGitDirectory(Directory.current);
    final workingPath = Directory.current.difference(gitDir);
    await const GitReviewCliCode().generateFile(
      "${workingPath.isEmpty ? "." : workingPath}/.github/workflows/review.yaml",
    );
  }
}

/// Contents of review.yaml.
///
/// review.yamlの中身。
class GitReviewCliCode extends CliCode {
  /// Contents of review.yaml.
  ///
  /// review.yamlの中身。
  const GitReviewCliCode();

  @override
  String get name => "review";

  @override
  String get prefix => "review";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create review.yaml for automatic review function for pull requests using GPT. GPTを利用したプルリクエスト用の自動レビュー機能用のreview.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
# Code review of Flutter and TypeScript files.
# 
# FlutterおよびTypeScriptのファイルのコードレビューをします。
name: CodeReview

permissions:
  contents: read
  pull-requests: write

on:
  pull_request:
    types: [opened, reopened, synchronize]
    paths:
      - "**.dart"
      - "**.ts"

jobs:
  gpt_review:
    runs-on: ubuntu-latest
    steps:
      - uses: anc95/ChatGPT-CodeReview@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
          LANGUAGE: Japanese
          OPENAI_API_ENDPOINT: https://api.openai.com/v1
          MODEL: gpt-4o
          PROMPT: |
            あなたはベテランエンジニアです。回答は日本語でお願いします。
            渡されたコードについて改善点を見つけ、変更する理由を説明した上で、変更後のコード例を示してください。
            改善点がない場合には絶対にコメントをしないでください。
            対象とするファイルは `**.dart` と `**.ts` ファイルです。
            ただし`**.g.dart`、`**.freezed.dart`、`**.m.dart`、`**.page.dart`、`**.localize.dart`、`**.theme.dart`は自動生成されたコードなため対象外です。絶対にコメントしないでください。
            それ以外のファイルにも絶対にコメントしないでください。

            特に以下の点を指摘してください:
              - 誤解を招いたり、実態を正確に表していない命名があるか
              - 適度に変数を定義し自己ドキュメントされているか
              - 冗長な書き方のコードがないか
              - N+1問題（N+1 query problem）を引き起こす箇所
              - 読んで理解が難しい箇所にコメントが適切にされているか
              - コメントの内容は日本語として読んでわかりやすく、簡潔に説明できているか
              - 理解の難しい複雑な条件式が作られていないか
              - テスト内の説明文は、テストの内容をわかりやすく適切に表しているか
              - 明らかなセキュリティの問題があるか

            誰にとっても読みやすいコードになるよう、改善点を見つけたら積極的にレビューしてください。
            あなたに渡されるコードは一部分であるため、未定義のメソッドやクラスなどの指摘については消極的にしてください。
          top_p: 1
          temperature: 1
          max_tokens: 4096
          MAX_PATCH_LENGTH: 4096
""";
  }
}
