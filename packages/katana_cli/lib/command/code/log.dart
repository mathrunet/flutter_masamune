part of "code.dart";

/// Create a base class for the exception.
///
/// 例外のベースクラスを作成します。
class CodeLogCliCommand extends CliTestableCodeCommand {
  /// Create a base class for the exception.
  ///
  /// 例外のベースクラスを作成します。
  const CodeLogCliCommand();

  @override
  String get name => "log";

  @override
  String get prefix => "log";

  @override
  String get directory => "lib/logs";

  @override
  String get testDirectory => "test/logs";

  @override
  String get description =>
      "Create a base class for the log in `$directory/(filepath).dart`. ログのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code log [log_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code log [path]\r\n",
      );
      return;
    }
    label("Create a log class in `$directory/$path.dart`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
      final parentTestDir = Directory("$testDirectory/$parentPath");
      if (!parentTestDir.existsSync()) {
        await parentTestDir.create(recursive: true);
      }
    }
    await generateDartCode("$directory/$path", path);
  }

  @override
  String import(String path, String baseName, String className) {
    return """
import 'package:masamune/masamune.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Loggable for Logger.
class ${className}Loggable extends Loggable {
  const ${className}Loggable(
    // TODO: Define some arguments.
    \${1}
  );

  // TODO: Define fields and processes.
  \${2}

  /// The name of the log.
  // TODO: Define the name of the log.
  @override
  final String name = "${className.toSnakeCase()}";

  /// You can convert from Json to pass parameters.
  // TODO: Define the parameters to be passed.
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
""";
  }

  @override
  String test(
      String path, String sourcePath, String baseName, String className) {
    throw UnsupportedError("Not supported.");
  }
}
