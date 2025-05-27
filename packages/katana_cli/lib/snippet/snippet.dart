// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/snippet/modals/modals.dart';
import 'package:katana_cli/snippet/models/models.dart';
import 'package:katana_cli/snippet/redirects/redirects.dart';
import 'package:katana_cli/snippet/theme/theme.dart';
import 'pages/pages.dart';

/// Group for generating snippet.
///
/// スニペットを生成するためのグループ。
class CodeSnippetsCliGroup {
  /// Group for generating snippet.
  ///
  /// スニペットを生成するためのグループ。
  const CodeSnippetsCliGroup();

  /// Description of the group.
  ///
  /// グループの説明。
  String get groupDescription => "Generating snippet. スニペットを生成します。";

  /// Snippets of the group.
  ///
  /// グループのスニペット。
  List<CodeSnippetsCliCode> get snippets => const [
        PagesCodeSnippetsCliCode(),
        ModelsCodeSnippetsCliCode(),
        ModalsCodeSnippetsCliCode(),
        RedirectsCodeSnippetsCliCode(),
        ThemesCodeSnippetsCliCode(),
      ];

  /// Generate files.
  ///
  /// ファイルを生成します。
  Future<void> generateFiles() async {
    for (final snippet in snippets) {
      await snippet.generateFile("${snippet.name}.code-snippets");
    }
  }
}

/// Contents of masamune.code-snippets.
///
/// masamune.code-snippetsの中身。
abstract class CodeSnippetsCliCode extends CliCode {
  /// Contents of masamune.code-snippets.
  ///
  /// masamune.code-snippetsの中身。
  const CodeSnippetsCliCode();

  /// Snippets of the group.
  ///
  /// グループのスニペット。
  List<CliCodeSnippet> get snippets;

  @override
  String get name;

  @override
  String get prefix => name;

  @override
  String get directory => ".vscode";

  @override
  String get description =>
      "Create $name.code-snippets for VSCode. $name.code-snippetsを作成します。";

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
    final res = <String, dynamic>{};
    for (final snippet in snippets) {
      res.addAll(snippet.generate());
    }
    return jsonEncode(res);
  }
}
