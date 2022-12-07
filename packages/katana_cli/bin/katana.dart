library katana_cli;

import 'dart:convert';
import 'dart:io';

import 'package:katana/katana.dart';
import 'package:yaml/yaml.dart';
import 'src/framework.dart';

part 'command/format.dart';
part 'command/generate.dart';
part 'command/publish.dart';
part 'command/submodule.dart';
part 'command/upgrade.dart';
part 'command/version.dart';
part 'command/create.dart';

/// Defines a list of commands.
///
/// コマンドの一覧を定義します。
const commands = <String, CliCommand>{
  "create": CreateCliCommand(),
  "format": FormatCliCommand(),
  "publish": PublishCliCommand(),
  "version": VersionCliCommand(),
  "upgrade": UpgradeCliCommand(),
  "generate": GenerateCliCommand(),
  "submodule": SubmoduleCliCommand(),
};

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    showReadme();
    return;
  }
  final command = args.firstOrNull;
  if (command == "help") {
    showReadme();
    return;
  }
  final masamune = File("katana.yaml");
  if (!masamune.existsSync()) {
    for (final tmp in commands.entries) {
      if (tmp.key != command) {
        continue;
      }
      await tmp.value.exec({}, args);
      return;
    }
  } else {
    final yaml = loadYaml(await masamune.readAsString());
    if (yaml.isEmpty) {
      print(
        "katana.yaml file could not be found. Place it in the root of the project.",
      );
      return;
    }
    for (final tmp in commands.entries) {
      if (tmp.key != command) {
        continue;
      }
      await tmp.value.exec(yaml, args);
      return;
    }
  }
  showReadme();
}

/// Displays a description of the command.
///
/// コマンドの説明を表示します。
void showReadme() {
  print(
    """
Katana command line interfaces.

${commands.toList((key, value) => "$key:\r\n    - ${value.description}").join("\r\n")}
""",
  );
}
