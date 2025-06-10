library;

import "package:katana_cli/action/git/claude_code.dart";
import "package:katana_cli/action/git/status_check.dart";
import "package:katana_cli/katana_cli.dart";

part "submodule.dart";
part "update.dart";

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
        "update": GitUpdateCliCommand(),
      };
}
