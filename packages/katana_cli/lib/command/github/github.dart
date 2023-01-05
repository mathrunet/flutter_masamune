library katana_cli.github;

import 'dart:convert';
import 'dart:io';

import 'package:katana_cli/katana_cli.dart';

part 'action.dart';

class GithubCliCommand extends CliCommandGroup {
  const GithubCliCommand();

  @override
  String get groupDescription =>
      "Configure settings related to Github. Githubに関連する設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "action": GithubActionCliCommand(),
      };
}
