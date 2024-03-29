library katana_cli.github;

// Project imports:
import 'package:katana_cli/katana_cli.dart';

part 'submodule.dart';

class GitCliCommand extends CliCommandGroup {
  const GitCliCommand();

  @override
  String get groupDescription =>
      "Configure settings related to Git and Github. GitやGithubに関連する設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "submodule": GitSubmoduleCliCommand(),
      };
}
