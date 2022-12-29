library katana_cli;

import 'dart:io';

import 'package:katana_cli/katana_cli.dart';
import 'package:yaml/yaml.dart';

/// Defines a list of commands.
///
/// コマンドの一覧を定義します。
const commands = <String, CliCommand>{
  "app": AppCliCommand(),
  "pub": PubCliCommand(),
  "code": CodeCliCommand(),
  "create": CreateCliCommand(),
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
  final katana = File("katana.yaml");
  if (!katana.existsSync()) {
    for (final tmp in commands.entries) {
      if (tmp.key != command) {
        continue;
      }
      await tmp.value.exec(
        ExecContext(
          yaml: {},
          args: args,
        ),
      );
      return;
    }
  } else {
    final yaml = modifize(loadYaml(await katana.readAsString()));
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
      await tmp.value.exec(
        ExecContext(
          yaml: yaml,
          args: args,
        ),
      );
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
