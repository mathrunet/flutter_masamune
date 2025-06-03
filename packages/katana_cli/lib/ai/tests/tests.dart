// Project imports:
import "package:katana_cli/katana_cli.dart";

/// TestsAiCode is a command that generates AI code to do the test.
///
/// TestsAiCodeはテストを行うためのAIコードを生成するコマンドです。
class TestsAiCode extends CliAiCodeCommand {
  /// TestsAiCode is a command that generates AI code to do the test.
  ///
  /// TestsAiCodeはテストを行うためのAIコードを生成するコマンドです。
  const TestsAiCode();

  @override
  final String description =
      "Generate AI code for testing. テストを行うためのAIコードを生成します。";

  @override
  Map<String, CliAiCode> get codes => {
        "test": const TestMdCliAiCode(),
      };
}

/// Contents of test.md.
///
/// test.mdの中身。
class TestMdCliAiCode extends CliAiCode {
  /// Contents of test.md.
  ///
  /// test.mdの中身。
  const TestMdCliAiCode();

  @override
  String get name => "すべての`テスト`の実装";

  @override
  String get globs => "lib/**/*.dart";

  @override
  String get directory => "tests";

  @override
  String get description => "すべての`テスト`の実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
`test`フォルダに作成されているテストファイルを修正し
下記の順番通りにステップごとに実施

1. `Controllerのテストの実装`
2. `Widgetのテストの実装`
3. `Pageのテストの実装`

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
