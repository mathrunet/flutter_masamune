import 'dart:convert';
import 'dart:core';
import 'dart:core' as core;
import 'dart:io';

import 'package:katana/katana.dart';

/// Abstract class for creating command templates.
///
/// コマンドの雛形を作成するための抽象クラス。
abstract class CliCommand {
  /// Abstract class for creating command templates.
  ///
  /// コマンドの雛形を作成するための抽象クラス。
  const CliCommand();

  /// Command Description.
  ///
  /// コマンドの説明。
  String get description;

  /// Run command.
  ///
  /// The contents of `katana.yaml` are passed in [yaml]. Arguments of the command are passed in [args].
  ///
  /// コマンドを実行します。
  ///
  /// [yaml]で`katana.yaml`の内容が渡されます。[args]にコマンドの引数が渡されます。
  Future<void> exec(Map yaml, List<String> args);
}

/// A template for creating command groups.
///
/// コマンドグループを作成するための雛形。
abstract class CliCommandGroup extends CliCommand {
  /// A template for creating command groups.
  ///
  /// コマンドグループを作成するための雛形。
  const CliCommandGroup();

  /// Defines a list of subcommands.
  ///
  /// サブコマンドの一覧を定義します。
  Map<String, CliCommand> get commands;

  /// Describe the group.
  ///
  /// グループの説明を記載します。
  String get groupDescription;

  @override
  String get description {
    return """
$groupDescription
${commands.toList((key, value) => "    $key:\r\n        - ${value.description}").join("\r\n")}
""";
  }

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    if (args.length <= 1) {
      print(description);
      return;
    }
    final mode = args[1];
    if (mode.isEmpty) {
      print(description);
      return;
    }
    for (final tmp in commands.entries) {
      if (tmp.key != mode) {
        continue;
      }
      await tmp.value.exec(yaml, args);
      return;
    }
    print(description);
  }
}

/// Extended methods to make [Process] easier to use.
///
/// [Process]を使いやすくするための拡張メソッド。
extension ProcessExtensions on Future<Process> {
  /// Prints the contents of the command to standard output.
  ///
  /// コマンドの内容を標準出力にプリントします。
  Future<String> print() async {
    final process = await this;
    var res = "";
    process.stderr.transform(utf8.decoder).forEach(core.print);
    process.stdout.transform(utf8.decoder).forEach((e) {
      res += e;
      core.print(e);
    });
    await process.exitCode;
    return res;
  }
}
