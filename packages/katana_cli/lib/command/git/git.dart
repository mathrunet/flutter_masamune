library;

// Project imports:
import "package:katana_cli/katana_cli.dart";

part "submodule.dart";

/// Configure settings related to Git and Github.
///
/// GitやGithubに関連する設定を行います。
class GitCliCommand extends CliCommandGroup {
  /// Configure settings related to Git and Github.
  ///
  /// GitやGithubに関連する設定を行います。
  const GitCliCommand();

  @override
  String get groupDescription =>
      "Configure settings related to Git and Github. GitやGithubに関連する設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "submodule": GitSubmoduleCliCommand(),
      };
}
