library katana_cli.github;

import 'package:katana_cli/katana_cli.dart';

import 'platform/android.dart';
import 'platform/ios.dart';
import 'platform/web.dart';

part 'action.dart';
part 'submodule.dart';
part 'hook.dart';

class GitCliCommand extends CliCommandGroup {
  const GitCliCommand();

  @override
  String get groupDescription =>
      "Configure settings related to Git and Github. GitやGithubに関連する設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "action": GitActionCliCommand(),
        "hook": GitHookCliCommand(),
        "submodule": GitSubmoduleCliCommand(),
      };
}
