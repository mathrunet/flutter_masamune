// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:core" as core;
import "dart:core";
import "dart:io";

// Package imports:
import "package:katana/katana.dart";
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

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
  ExecContext({
    required this.yaml,
    required this.args,
    this.secrets = const {},
    int index = 1,
  }) : _index = index;

  /// The contents of `katana.yaml` will be included.
  ///
  /// `katana.yaml`の内容が入ります。
  final Map yaml;

  /// The contents of `katana_secrets.yaml` will be included.
  ///
  /// `katana_secrets.yaml`の内容が入ります。
  final Map secrets;

  /// Arguments when the command is executed.
  ///
  /// コマンドを実行した際の引数。
  final List<String> args;

  /// Post action after execution.
  ///
  /// 実行した後のポストアクション。
  final List<PostAction> postActions = [];

  final int _index;

  ExecContext _copyToChild() {
    return ExecContext(yaml: yaml, args: args, index: _index + 1);
  }

  /// Save [yaml] to `katana.yaml`.
  ///
  /// [yaml]を`katana.yaml`に保存します。
  Future<void> save() async {
    final content = YamlWriter().write(yaml);
    await File("katana.yaml").writeAsString(content);
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

  /// Example of command input.
  ///
  /// コマンド入力の例。
  String? get example;

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
  String? get example => null;
  @override
  Future<void> exec(ExecContext context) async {
    if (context.args.length <= context._index) {
      // ignore: avoid_print
      print(description);
      return;
    }
    final mode = context.args[context._index];
    if (mode.isEmpty) {
      // ignore: avoid_print
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
    // ignore: avoid_print
    print(description);
  }
}

/// Abstract class for executing AI code creation.
///
/// AIコード作成を実行するための抽象クラス。
abstract class CliAiCodeCommand implements CliCommand {
  /// Abstract class for executing AI code creation.
  ///
  /// AIコード作成を実行するための抽象クラス。
  const CliAiCodeCommand({
    this.defaultDirectory = "documents/rules",
    this.includeName = true,
  });

  /// Defines the default directory for the AI code.
  ///
  /// AIコードのデフォルトディレクトリを定義します。
  final String defaultDirectory;

  /// Defines whether to include the name in the AI code.
  ///
  /// AIコードに名前を含めるかどうかを定義します。
  final bool includeName;

  /// Defines a list of AI code.
  ///
  /// AIコードの一覧を定義します。
  Map<String, CliAiCode> get codes;

  @override
  String? get example => null;
  @override
  Future<void> exec(ExecContext context) async {
    for (final entry in codes.entries) {
      await entry.value.generateAiCode(
        entry.key,
        defaultDirectory: defaultDirectory,
        includeName: includeName,
      );
    }
  }
}

/// Abstract class for creating AI code groups.
///
/// AIコードグループを作成するための抽象クラス。
abstract class CliAiCodeGroup extends CliAiCode {
  /// Abstract class for creating AI code groups.
  ///
  /// AIコードグループを作成するための抽象クラス。
  const CliAiCodeGroup();

  /// Defines a list of subcommands.
  ///
  /// サブコマンドの一覧を定義します。
  Map<String, CliAiCode> get children;

  /// Defines the actual header code. [path] is passed relative to `lib`, [baseName] is the filename, and [className] is the filename converted to Pascal case.
  ///
  /// 実際の本体コードのヘッダを定義します。[path]に`lib`からの相対パス、[baseName]にファイル名が渡され、[className]にファイル名をパスカルケースに変換した値が渡されます。
  String header(String path, String baseName, String className);

  @override
  String body(String baseName, String className) {
    return children
        .toList((key, value) =>
            "- [${value.name}](`documents/rules/${key.replaceAll("/${key.last()}", "")}.md`)")
        .join("\n");
  }
}

/// Abstract class for defining AI code.
///
/// AIコードを定義するための抽象クラス。
abstract class CliAiCode {
  /// Abstract class for defining AI code.
  ///
  /// AIコードを定義するための抽象クラス。
  const CliAiCode();

  /// Define the name of the code.
  ///
  /// コードの名前を定義します。
  String get name;

  /// Define the description of the code.
  ///
  /// コードの説明を定義します。
  String get description;

  /// Define the file extension.
  ///
  /// ファイルの拡張子を定義します。
  String get globs;

  /// Specify the folder where the code will be generated.
  ///
  /// コードを生成するフォルダを指定します。
  String get directory;

  /// Defines the actual body code. [path] is passed relative to `lib`, [baseName] is the filename, and [className] is the filename converted to Pascal case.
  ///
  /// 実際の本体コードを定義します。[path]に`lib`からの相対パス、[baseName]にファイル名が渡され、[className]にファイル名をパスカルケースに変換した値が渡されます。
  String body(String baseName, String className);

  /// Generate md code in [path].
  ///
  /// You can edit the data inside with [filter].
  ///
  /// [path]にmdコードを生成します。
  ///
  /// [filter]で中身のデータを編集することができます。
  Future<void> generateAiCode(
    String path, {
    String ext = "md",
    String defaultDirectory = "documents/rules",
    String Function(String value)? filter,
    bool includeName = true,
  }) async {
    final baseName = path.last();
    final editClassName = path.split("/").distinct().join("_").toPascalCase();
    final dir = Directory(
        "$defaultDirectory/${directory.isEmpty ? "" : "/$directory/"}");
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final output =
        "${includeName ? "# $name\n\n" : ""}${body(baseName, editClassName)}";
    await File(
            "$defaultDirectory/${directory.isEmpty ? "" : "/$directory/"}$path.$ext")
        .writeAsString(filter?.call(output) ?? output);
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

  static final _regExp = RegExp(r"\$\{[0-9]+(:([^\}]+))?\}");

  /// Defines the name of the code.
  ///
  /// コードの名前を定義します。
  String get name;

  /// Defines the outline of the code.
  ///
  /// コードの概要を定義します。
  String get description;

  /// Defines the code prefix.
  ///
  /// コードのプレフィックスを定義します。
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
  /// You can edit the data inside with [filter].
  ///
  /// [path]にDartコードを生成します。
  ///
  /// [filter]で中身のデータを編集することができます。
  Future<void> generateDartCode(
    String path,
    String className, {
    String ext = "dart",
    String Function(String value)? filter,
  }) async {
    final baseName = path.last();
    final trimedPath = _trimPathPrefix(path);
    final editClassName =
        className.split("/").distinct().join("_").toPascalCase();
    final dir = Directory(path.replaceAll("/$baseName", ""));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final output = _removeCodeSnippetValue(
      "${import(trimedPath, baseName, editClassName)}\n${header(trimedPath, baseName, editClassName)}\n${body(trimedPath, baseName, editClassName)}",
    );
    await File("$path.$ext").writeAsString(filter?.call(output) ?? output);
  }

  /// Create a specific file in [directory]/[fileName].
  ///
  /// You can edit the data inside with [filter].
  ///
  /// [directory]/[fileName]に特定のファイルを作成します。
  ///
  /// [filter]で中身のデータを編集することができます。
  Future<void> generateFile(
    String fileName, {
    String Function(String value)? filter,
  }) async {
    if (directory.isNotEmpty) {
      final dir = Directory(directory);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
    }
    final output =
        "${import("", "", "")}${header("", "", "")}${body("", "", "")}";
    await File("${directory.isNotEmpty ? "$directory/" : ""}$fileName")
        .writeAsString(filter?.call(output) ?? output);
  }

  static String _trimPathPrefix(String path) {
    path = path.replaceAll(RegExp("^lib/"), "");
    for (final prefix in _trimPrefixes) {
      if (path.startsWith("$prefix/")) {
        path = path.replaceAll(RegExp("^$prefix/"), "");
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

/// Abstract class for defining code snippets.
///
/// コードスニペットを定義するための抽象クラス。
abstract class CliCodeSnippet {
  /// Abstract class for defining code snippets.
  ///
  /// コードスニペットを定義するための抽象クラス。
  const CliCodeSnippet();

  static const _baseName = r"${TM_FILENAME_BASE}";
  static const _className =
      r"${TM_FILENAME_BASE/([^_]*)(_?)/${1:/capitalize}/g}";

  /// Defines the code prefix.
  ///
  /// コードのプレフィックスを定義します。
  String get prefix;

  /// Defines the name of the code.
  ///
  /// コードの名前を定義します。
  String get name;

  /// Defines the outline of the code.
  ///
  /// コードの概要を定義します。
  String get description;

  /// Defines the language of the code.
  ///
  /// コードの言語を定義します。
  String get language => "dart";

  /// Defines the actual body code. [path] is passed relative to `lib`, [baseName] is the filename, and [className] is the filename converted to Pascal case.
  ///
  /// 実際の本体コードを定義します。[path]に`lib`からの相対パス、[baseName]にファイル名が渡され、[className]にファイル名をパスカルケースに変換した値が渡されます。
  String body(String path, String baseName, String className);

  /// Generate code snippet.
  ///
  /// コードスニペットを生成します。
  DynamicMap generate() {
    return {
      name: {
        "prefix": prefix,
        "description": description,
        "scope": language,
        "body": "${body(_baseName, _baseName, _className)}\n"
            .replaceAll("\r\n", "\n")
            .replaceAll("\r", "\n")
            .split("\n")
      },
    };
  }
}

/// Mixin for setting up internal actions to be executed by the `apply` command.
///
/// `apply`コマンドで実行するための内部アクションを設定するためのMixin。
mixin CliActionMixin on CliCommand {
  /// Decide whether to apply this action based on the contents of [context].
  ///
  /// Return `true` if applicable.
  ///
  /// [context]の内容を元にこのアクションを適用するかどうかを決定する。
  ///
  /// 適用する場合`true`を返す。
  bool checkEnabled(ExecContext context);

  @override
  String? get example => null;
}

/// Set the action to be taken after execution.
///
/// 実行した後のアクションを設定します。
abstract class PostAction {
  /// Set the action to be taken after execution.
  ///
  /// 実行した後のアクションを設定します。
  const PostAction();

  /// Do action.
  ///
  /// アクションを実行します。
  Future<void> exec(ExecContext context);
}

/// Abstract class for creating a code-based command template.
///
/// コードベースのコマンドの雛形を作成するための抽象クラス。
abstract class CliCodeCommand extends CliCode implements CliCommand {
  /// Abstract class for creating a code-based command template.
  ///
  /// コードベースのコマンドの雛形を作成するための抽象クラス。
  const CliCodeCommand();
}

/// An abstract class for creating testable code-based command templates.
///
/// テスト可能なコードベースのコマンドの雛形を作成するための抽象クラス。
abstract class CliTestableCodeCommand extends CliCodeCommand {
  /// An abstract class for creating testable code-based command templates.
  ///
  /// テスト可能なコードベースのコマンドの雛形を作成するための抽象クラス。
  const CliTestableCodeCommand();

  /// Specify the folder where test code is to be generated.
  ///
  /// テストコードを生成するフォルダを指定します。
  String get testDirectory;

  /// Define test code. The path [path] is passed relative to `lib`, [sourcePath] is the source file path, [baseName] is the filename, and [className] is the filename converted to Pascal case.
  ///
  /// テストコードを定義します。[path]に`lib`からの相対パス、[sourcePath]にソースファイルのパス、[baseName]にファイル名が渡され、[className]にファイル名をパスカルケースに変換した値が渡されます。
  String test(
      String path, String sourcePath, String baseName, String className);

  /// Generate Dart test code in [path].
  ///
  /// You can edit the data inside with [filter].
  ///
  /// [path]にDartテストコードを生成します。
  ///
  /// [filter]で中身のデータを編集することができます。
  Future<void> generateDartTestCode(
    String path,
    String className, {
    String ext = "dart",
    String Function(String value)? filter,
  }) async {
    final baseName = path.last();
    final trimedPath = CliCode._trimPathPrefix(path);
    final editClassName =
        className.split("/").distinct().join("_").toPascalCase();
    final dir = Directory(path.replaceAll("/$baseName", ""));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final output = CliCode._removeCodeSnippetValue(
      test(trimedPath, className, baseName, editClassName),
    );
    await File("${path}_test.$ext")
        .writeAsString(filter?.call(output) ?? output);
  }
}

/// Make an Unmodifidable map or listing Modifidable.
///
/// UnmodifidableなマップやリストをModifidableにします。
dynamic modifize(dynamic object) {
  if (object is Map) {
    final modifized = Map.from(object);
    for (final tmp in object.entries) {
      modifized[tmp.key] = modifize(tmp.value);
    }
    return modifized;
  } else if (object is List) {
    final modifized = List.from(object);
    for (var i = 0; i < modifized.length; i++) {
      modifized[i] = modifize(modifized[i]);
    }
    return modifized;
  } else {
    return object;
  }
}

/// Display labels.
///
/// ラベルを表示します。
void label(String title) {
  stdout.add(utf8.encode("\r\n#### $title"));
}

/// Display errors.
///
/// エラーを表示します。
void error(String message) {
  _isError = true;
  stderr.add(utf8.encode(message));
}

/// Whether an error has occurred.
///
/// エラーが発生したかどうか。
bool get isError => _isError;
bool _isError = false;

/// Validate the file path.
///
/// ファイルパスを検証します。
bool validateFilePath(String path) {
  if (!RegExp(r"^[a-z0-9/_]+$").hasMatch(path)) {
    return false;
  }
  if (!path.startsWith(RegExp(r"[a-z]")) ||
      !RegExp(r"[a-z]+$").hasMatch(path) ||
      RegExp(r"/[0-9/_]+").hasMatch(path)) {
    return false;
  }
  return true;
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
  bool catchError = false,
  void Function(Process process, String line)? action,
}) async {
  String? prevDirectory;
  stdout.add(utf8.encode("\r\n#### $title"));
  if (commands.isEmpty) {
    throw Exception("At least one command is required.");
  }
  if (action != null) {
    var res = "";
    var err = false;
    if (workingDirectory != null) {
      prevDirectory = Directory.current.path;
      Directory.current = workingDirectory.startsWith("/")
          ? workingDirectory
          : "${Directory.current.path}/$workingDirectory";
    }
    final process = await Process.start(
      commands.first,
      commands.sublist(1, commands.length),
      runInShell: runInShell,
      mode: ProcessStartMode.normal,
    );
    unawaited(
      process.stderr.forEach((e) {
        final line = utf8.decoder.convert(e);
        err = true;
        res += line;
        stderr.add(e);
      }),
    );
    unawaited(
      process.stdout.forEach((e) {
        final line = utf8.decoder.convert(e);
        res += line;
        stdout.add(e);
        action.call(process, line);
      }),
    );
    final exitCode = await process.exitCode;
    if (catchError && exitCode != 0) {
      throw Exception(
        "An error has occurred. Please check the log above for details.",
      );
    }
    if (workingDirectory != null) {
      Directory.current = prevDirectory!;
    }
    if (catchError && err) {
      throw Exception(
        "An error has occurred. Please check the log above for details.",
      );
    }
    return res;
  } else {
    if (workingDirectory != null) {
      prevDirectory = Directory.current.path;
      Directory.current = workingDirectory.startsWith("/")
          ? workingDirectory
          : "${Directory.current.path}/$workingDirectory";
    }
    final res = await Process.start(
      commands.first,
      commands.sublist(1, commands.length),
      runInShell: runInShell,
    ).print(catchError);
    if (workingDirectory != null) {
      Directory.current = prevDirectory!;
    }
    return res;
  }
}

/// Add flutter imports by giving [packages].
///
/// If it has already been added, it will not be added.
///
/// [packages]を与えてflutterのimportを追加します。
///
/// すでに追加されている場合は、追加されません。
Future<void> addFlutterImport(
  List<String> packages, {
  bool development = false,
  String flutterCommand = "flutter",
}) async {
  final addPackages = <String>[];
  final pubspecFile = File("pubspec.yaml");
  final pubspec = loadYaml(await pubspecFile.readAsString()) as Map;
  if (development) {
    final dependencies = pubspec.getAsMap("dev_dependencies");
    for (final package in packages) {
      if (dependencies.containsKey(package)) {
        continue;
      }
      addPackages.add(package);
    }
    if (addPackages.isNotEmpty) {
      await command(
        "Import packages.",
        [
          flutterCommand,
          "pub",
          "add",
          "--dev",
          ...addPackages,
        ],
      );
    }
  } else {
    final dependencies = pubspec.getAsMap("dependencies");
    for (final package in packages) {
      if (dependencies.containsKey(package)) {
        continue;
      }
      addPackages.add(package);
    }
    if (addPackages.isNotEmpty) {
      await command(
        "Import packages.",
        [
          flutterCommand,
          "pub",
          "add",
          ...addPackages,
        ],
      );
    }
  }
}

/// Get the Flutter version.
///
/// Flutterのバージョンを取得します。
Future<String> getFlutterVersion() async {
  final flutterVersionSource = await command(
    "Get Flutter version.",
    [
      "flutter",
      "--version",
      "--machine",
    ],
    catchError: true,
  );
  final json = jsonDecodeAsMap(flutterVersionSource);
  return json.get("frameworkVersion", "");
}

/// Get the first file that matches [pattern] in [root].
///
/// [root]の中にある[pattern]に最初に当てはまるファイルを取得します。
Future<File?> find(
  Directory root,
  Pattern pattern, {
  bool recursive = true,
}) async {
  final files = root.list(recursive: recursive);
  await for (final file in files) {
    final name = file.path.trimQuery().last();
    final match = pattern.allMatches(name);
    if (match.isEmpty) {
      continue;
    }
    return File(file.path);
  }
  return null;
}

/// Get the first directory in [root] that matches [pattern].
///
/// [root]の中にある[pattern]に最初に当てはまるディレクトリを取得します。
Future<Directory?> findDirectory(Directory root, Pattern pattern) async {
  final files = root.list(recursive: true);
  await for (final file in files) {
    final name = file.path.trimQuery().last();
    final match = pattern.allMatches(name);
    if (match.isEmpty) {
      continue;
    }
    return Directory(file.path);
  }
  return null;
}

/// Get the directory where Git resides.
///
/// Gitが存在するディレクトリを取得します。
Future<Directory?> findGitDirectory(Directory current) {
  return findDirectory(current, RegExp(r"^\.git$")).then((value) {
    if (value != null) {
      return value.parent;
    }
    if (current.path == current.parent.path) {
      return null;
    }
    return findGitDirectory(current.parent);
  });
}

/// Retrieve the package name.
///
/// パッケージ名を取得します。
String retrievePackageName() {
  final pubspecFile = File("pubspec.yaml");
  final pubspec = loadYaml(pubspecFile.readAsStringSync()) as Map;
  final name = pubspec.get("name", "");
  return name;
}

/// Extended methods to make [Directory] easier to use.
///
/// [Directory]を使いやすくするための拡張メソッド。
extension CliDirectoryExtensions on Directory {
  /// Obtains a path relative to the current directory.
  ///
  /// 現在のディレクトリとの相対パスを取得します。
  String difference(Directory? other) {
    if (other == null) {
      return path;
    }
    if (other.path.length < path.length) {
      final relative = path.replaceAll(other.path, "").trimStringLeft("/");
      return ("../" * relative.split("/").length).trimString("/");
    } else if (other.path.length > path.length) {
      return other.path.replaceAll(path, "").trimStringLeft("/");
    } else {
      return "";
    }
  }
}

/// Extended methods to make [Process] easier to use.
///
/// [Process]を使いやすくするための拡張メソッド。
extension ProcessExtensions on Future<Process> {
  /// Prints the contents of the command to standard output.
  ///
  /// コマンドの内容を標準出力にプリントします。
  Future<String> print(bool catchError) async {
    final process = await this;
    var res = "";
    var err = false;
    unawaited(
      process.stderr.forEach((e) {
        final line = utf8.decoder.convert(e);
        err = true;
        res += line;
        stderr.add(e);
      }),
    );
    unawaited(
      process.stdout.forEach((e) {
        final line = utf8.decoder.convert(e);
        res += line;
        stdout.add(e);
      }),
    );
    final exitCode = await process.exitCode;
    if (catchError && exitCode != 0) {
      throw Exception(
        "An error has occurred. Please check the log above for details.",
      );
    }
    if (catchError && err) {
      throw Exception(
        "An error has occurred. Please check the log above for details.",
      );
    }
    return res;
  }
}
