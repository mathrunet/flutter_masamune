// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/snippet/modals/confirmation.dart";
import "package:katana_cli/snippet/snippet.dart";

/// Modals code snippets.
///
/// モーダルのコードスニペット。
class ModalsCodeSnippetsCliCode extends CodeSnippetsCliCode {
  /// Modals code snippets.
  ///
  /// モーダルのコードスニペット。
  const ModalsCodeSnippetsCliCode();

  @override
  String get name => "modals";

  @override
  List<CliCodeSnippet> get snippets => const [
        ModalsConfirmationCliCodeSnippet(),
      ];
}
