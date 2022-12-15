import 'dart:convert';
import 'dart:core';
import 'dart:core' as core;
import 'dart:io';

import 'package:katana/katana.dart';

/// Prefix of the path to trim.
///
/// トリムするパスのプレフィックス。
final _trimPrefixes = [
  "models",
  "pages",
  "widgets",
  "controllers",
];

/// The context in which the command is executed.
///
/// The contents of `katana.yaml` are passed to [yaml] and the arguments of the command are passed to [args].
///
/// コマンドを実行する際のコンテキスト。
///
/// [yaml]に`katana.yaml`の内容が渡され、[args]にコマンドの引数が渡されます。
class ExecContext {
  /// The context in which the command is executed.
  ///
  /// The contents of `katana.yaml` are passed to [yaml] and the arguments of the command are passed to [args].
  ///
  /// コマンドを実行する際のコンテキスト。
  ///
  /// [yaml]に`katana.yaml`の内容が渡され、[args]にコマンドの引数が渡されます。
  const ExecContext({
    required this.yaml,
    required this.args,
    int index = 1,
  }) : _index = index;

  /// The contents of `katana.yaml` will be included.
  ///
  /// `katana.yaml`の内容が入ります。
  final Map yaml;

  /// Arguments when the command is executed.
  ///
  /// コマンドを実行した際の引数。
  final List<String> args;

  final int _index;

  ExecContext _copyToChild() {
    return ExecContext(yaml: yaml, args: args, index: _index + 1);
  }
}

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
  /// The contents of `katana.yaml` and the arguments of the command are passed to [context].
  ///
  /// コマンドを実行します。
  ///
  /// [context]に`katana.yaml`の内容やコマンドの引数が渡されます。
  Future<void> exec(ExecContext context);
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
  Future<void> exec(ExecContext context) async {
    if (context.args.length <= context._index) {
      print(description);
      return;
    }
    final mode = context.args[context._index];
    if (mode.isEmpty) {
      print(description);
      return;
    }
    for (final tmp in commands.entries) {
      if (tmp.key != mode) {
        continue;
      }
      await tmp.value.exec(context._copyToChild());
      return;
    }
    print(description);
  }
}

/// Abstract class for defining base code.
///
/// ベースコードを定義するための抽象クラス。
abstract class CliCode {
  /// Abstract class for defining base code.
  ///
  /// ベースコードを定義するための抽象クラス。
  const CliCode();

  static const _baseName = r"${TM_FILENAME_BASE}";
  static const _className =
      r"${TM_FILENAME_BASE/([^_]*)(_?)/${1:/capitalize}/g}";
  static final _regExp = RegExp(r"\$\{[0-9]+(:([^\}]+))?\}");

  /// Defines the name of the code.
  ///
  /// コードの名前を定義します。
  String get name;

  /// Defines the outline of the code.
  ///
  /// コードの概要を定義します。
  String get description;

  /// Defines the code prefix. Used for snippets.
  ///
  /// コードのプレフィックスを定義します。スニペット用に利用します。
  String get prefix;

  /// Specify the folder where the code will be generated.
  ///
  /// コードを生成するフォルダを指定します。
  String get directory;

  /// Define the actual import code. [path] is passed relative to `lib`, [baseName] is the filename, and [className] is the filename converted to Pascal case.
  ///
  /// 実際のインポートコードを定義します。[path]に`lib`からの相対パス、[baseName]にファイル名が渡され、[className]にファイル名をパスカルケースに変換した値が渡されます。
  String import(String path, String baseName, String className);

  /// Defines the actual header code. [path] is passed relative to `lib`, [baseName] is the filename, and [className] is the filename converted to Pascal case.
  ///
  /// 実際のヘッダーコードを定義します。[path]に`lib`からの相対パス、[baseName]にファイル名が渡され、[className]にファイル名をパスカルケースに変換した値が渡されます。
  String header(String path, String baseName, String className);

  /// Defines the actual body code. [path] is passed relative to `lib`, [baseName] is the filename, and [className] is the filename converted to Pascal case.
  ///
  /// 実際の本体コードを定義します。[path]に`lib`からの相対パス、[baseName]にファイル名が渡され、[className]にファイル名をパスカルケースに変換した値が渡されます。
  String body(String path, String baseName, String className);

  /// Generate Dart code in [path].
  ///
  /// [path]にDartコードを生成します。
  Future<void> generateDartCode(String path) async {
    final baseName = path.last();
    final trimedPath = _trimPathPrefix(path);
    final className = baseName.toPascalCase();
    final dir = Directory(path.replaceAll("/$baseName", ""));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    await File("$path.dart").writeAsString(
      _removeCodeSnippetValue(
        "${import(trimedPath, baseName, className)}\n${header(trimedPath, baseName, className)}\n${body(trimedPath, baseName, className)}",
      ),
    );
  }

  /// Create a code snippet file for VSCode in [directory]/[name].code-snippets.
  ///
  /// [directory]/[name].code-snippetsにVSCode用のコードスニペットファイルを作成します。
  Future<void> generateCodeSnippet(String directory) async {
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final fileName = name.toSnakeCase();
    final json = {
      name: {
        "prefix": "m${prefix.toPascalCase()}",
        "description": description,
        "body":
            "${import(_baseName, _baseName, _className)}\n${header(_baseName, _baseName, _className)}\n${body(_baseName, _baseName, _className)}\n"
                .replaceAll("\r\n", "\n")
                .replaceAll("\r", "\n")
                .split("\n")
      },
      "${name}_import": {
        "prefix": "i${prefix.toPascalCase()}",
        "description": description,
        "body": "${import(_baseName, _baseName, _className)}\n"
            .replaceAll("\r\n", "\n")
            .replaceAll("\r", "\n")
            .split("\n")
      },
      "${name}_header": {
        "prefix": "h${prefix.toPascalCase()}",
        "description": description,
        "body": "${header(_baseName, _baseName, _className)}\n"
            .replaceAll("\r\n", "\n")
            .replaceAll("\r", "\n")
            .split("\n")
      },
      "${name}_body": {
        "prefix": "b${prefix.toPascalCase()}",
        "description": description,
        "body": "${body(_baseName, _baseName, _className)}\n"
            .replaceAll("\r\n", "\n")
            .replaceAll("\r", "\n")
            .split("\n")
      }
    };
    await File("$directory/$fileName.code-snippets").writeAsString(
      jsonEncode(json),
    );
  }

  static String _trimPathPrefix(String path) {
    path = path.trimStringLeft("lib/");
    for (final prefix in _trimPrefixes) {
      if (path.startsWith("$prefix/")) {
        path = path.trimStringLeft("$prefix/");
        break;
      }
    }
    return path;
  }

  static String _removeCodeSnippetValue(String value) {
    return value.replaceAllMapped(_regExp, (m) {
      return m.group(2) ?? "";
    });
  }
}

/// Display labels.
///
/// ラベルを表示します。
void label(String title) {
  print("\r\n#### $title");
}

/// Run command.
///
/// Enter the command in [executable] and the arguments in [arguments].
///
/// Specify the folder where the command will be executed with `[workingDirectory]'. Defaults to `Directory.current.path`.
///
/// If [runInShell] is set to `true`, it will run on the shell.
///
/// コマンドを実行します。
///
/// [executable]にコマンドを[arguments]に引数を入力してください。
///
/// [workingDirectory]でコマンドが実行されるフォルダを指定します。デフォルトは`Directory.current.path`になります。
///
/// [runInShell]を`true`にするとシェル上で実行されます。
Future<String> command(
  String title,
  List<String> commands, {
  String? workingDirectory,
  bool runInShell = true,
}) {
  print("\r\n#### " + title);
  if (commands.isEmpty) {
    throw Exception("At least one command is required.");
  }
  return Process.start(
    commands.first,
    commands.sublist(1, commands.length),
    runInShell: runInShell,
    workingDirectory: workingDirectory ?? Directory.current.path,
  ).print();
}

/// Extended methods to make [Process] easier to use.
///
/// [Process]を使いやすくするための拡張メソッド。
extension _ProcessExtensions on Future<Process> {
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
