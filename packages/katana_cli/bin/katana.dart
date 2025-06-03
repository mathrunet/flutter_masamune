library katana_cli;

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:katana_cli/command/test/test.dart';
import 'package:yaml/yaml.dart';

// Project imports:
import 'package:katana_cli/command/apply.dart';
import 'package:katana_cli/command/cer/cer.dart';
import 'package:katana_cli/command/deploy.dart';
import 'package:katana_cli/command/doctor.dart';
import 'package:katana_cli/command/module.dart';
import 'package:katana_cli/command/store/store.dart';
import 'package:katana_cli/katana_cli.dart';

/// Defines a list of commands.
///
/// コマンドの一覧を定義します。
const commands = <String, CliCommand>{
  "pub": PubCliCommand(),
  "code": CodeCliCommand(),
  "test": TestCliCommand(),
  "git": GitCliCommand(),
  "apply": ApplyCliCommand(),
  "create": CreateCliCommand(),
  "package": PackageCliCommand(),
  "compose": ComposeCliCommand(),
  "deploy": DeployCliCommand(),
  "store": StoreCliCommand(),
  "module": CreateModuleCliCommand(),
  "doctor": DoctorCliCommand(),
  "cer": CerCliCommand(),
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
  final katanaSecrets = File("katana_secrets.yaml");
  if (!katana.existsSync()) {
    for (final tmp in commands.entries) {
      if (tmp.key != command) {
        continue;
      }
      final context = ExecContext(
        yaml: {},
        secrets: katanaSecrets.existsSync()
            ? loadYaml(await katanaSecrets.readAsString())
            : {},
        args: args,
      );
      await tmp.value.exec(context);
      for (final action in context.postActions) {
        await action.exec(context);
      }
      return;
    }
  } else {
    final yaml = modifize(loadYaml(await katana.readAsString()));
    if (yaml.isEmpty) {
      error(
        "katana.yaml file could not be found. Place it in the root of the project.",
      );
      return;
    }

    for (final tmp in commands.entries) {
      if (tmp.key != command) {
        continue;
      }
      final context = ExecContext(
        yaml: yaml,
        secrets: katanaSecrets.existsSync()
            ? modifize(loadYaml(await katanaSecrets.readAsString()))
            : {},
        args: args,
      );
      await tmp.value.exec(context);
      for (final action in context.postActions) {
        await action.exec(context);
      }
      return;
    }
  }
  showReadme();
}

/// Displays a description of the command.
///
/// コマンドの説明を表示します。
void showReadme() {
  // ignore: avoid_print
  print(
    """
Katana command line interfaces.

${commands.toList((key, value) => "$key:\r\n    - ${value.description}").join("\r\n")}
""",
  );
}
