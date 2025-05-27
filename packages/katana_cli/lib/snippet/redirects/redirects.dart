// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/snippet/redirects/login.dart';
import 'package:katana_cli/snippet/snippet.dart';

/// Redirects code snippets.
///
/// リダイレクトのコードスニペット。
class RedirectsCodeSnippetsCliCode extends CodeSnippetsCliCode {
  /// Redirects code snippets.
  ///
  /// リダイレクトのコードスニペット。
  const RedirectsCodeSnippetsCliCode();

  @override
  String get name => "redirects";

  @override
  List<CliCodeSnippet> get snippets => const [
        RedirectsLoginCliCodeSnippet(),
      ];
}
