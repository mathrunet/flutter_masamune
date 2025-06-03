// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/snippet/snippet.dart";
import "package:katana_cli/snippet/theme/form/auth_button.dart";

/// Themes code snippets.
///
/// テーマのコードスニペット。
class ThemesCodeSnippetsCliCode extends CodeSnippetsCliCode {
  /// Themes code snippets.
  ///
  /// テーマのコードスニペット。
  const ThemesCodeSnippetsCliCode();

  @override
  String get name => "theme";

  @override
  List<CliCodeSnippet> get snippets => const [
        ThemeFormAuthButtonCliCodeSnippet(),
      ];
}
