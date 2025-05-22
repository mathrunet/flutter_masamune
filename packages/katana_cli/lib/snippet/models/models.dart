import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/snippet/models/user.dart';
import 'package:katana_cli/snippet/snippet.dart';

/// Models code snippets.
///
/// モデルのコードスニペット。
class ModelsCodeSnippetsCliCode extends CodeSnippetsCliCode {
  /// Models code snippets.
  ///
  /// モデルのコードスニペット。
  const ModelsCodeSnippetsCliCode();

  @override
  String get name => "models";

  @override
  List<CliCodeSnippet> get snippets => const [
        ModelsUserCliCodeSnippet(),
      ];
}
