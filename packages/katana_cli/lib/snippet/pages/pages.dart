// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/snippet/pages/logic/retrieve_user.dart';
import 'package:katana_cli/snippet/pages/page/login.dart';
import 'package:katana_cli/snippet/snippet.dart';

/// Pages code snippets.
///
/// ページのコードスニペット。
class PagesCodeSnippetsCliCode extends CodeSnippetsCliCode {
  /// Pages code snippets.
  ///
  /// ページのコードスニペット。
  const PagesCodeSnippetsCliCode();

  @override
  String get name => "pages";

  @override
  List<CliCodeSnippet> get snippets => const [
        PagesPageLoginCliCodeSnippet(),
        PagesLogicRetrieveUserCliCodeSnippet(),
      ];
}
