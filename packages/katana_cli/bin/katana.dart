library katana_cli;

import 'dart:convert';
import 'dart:io';

import 'package:katana/katana.dart';
import 'package:yaml/yaml.dart';
import 'src/framework.dart';

part 'command/pub/pub.dart';
part 'command/pub/get.dart';
part 'command/pub/upgrade.dart';
part 'command/pub/version.dart';
part 'command/pub/publish.dart';

part 'command/code/code.dart';
part 'command/code/create.dart';
part 'command/code/format.dart';
part 'command/code/generate.dart';
part 'command/code/watch.dart';
part 'command/code/controller.dart';
part 'command/code/group.dart';
part 'command/code/page.dart';
part 'command/code/collection.dart';
part 'command/code/document.dart';

part 'command/submodule.dart';

part 'code/main.dart';
part 'code/page.dart';
part 'code/controller.dart';
part 'code/controller_group.dart';
part 'code/document_model.dart';
part 'code/collection_model.dart';

/// Defines a list of commands.
///
/// コマンドの一覧を定義します。
const commands = <String, CliCommand>{
  "pub": PubCliCommand(),
  "code": CodeCliCommand(),
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
