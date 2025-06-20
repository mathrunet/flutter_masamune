part of "code.dart";

/// Create a base class for the exception.
///
/// 例外のベースクラスを作成します。
class CodeExceptionCliCommand extends CliTestableCodeCommand {
  /// Create a base class for the exception.
  ///
  /// 例外のベースクラスを作成します。
  const CodeExceptionCliCommand();

  @override
  String get name => "exception";

  @override
  String get prefix => "exception";

  @override
  String get directory => "lib/exceptions";

  @override
  String get testDirectory => "test/exceptions";

  @override
  String get description =>
      "Create a base class for the exception in `$directory/(filepath).dart`. 例外のベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code exception [exception_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code controller [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code exception [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    label("Create a exception class in `$directory/$path.dart`.");
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
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Exception for $className.
@immutable
class ${className}Exception implements Exception {
  /// Exception for $className.
  const ${className}Exception(
    // TODO: Define some arguments.
    \${1}
  );

  // TODO: Define fields and processes.
  \${2}
}
""";
  }

  @override
  String test(
      String path, String sourcePath, String baseName, String className) {
    throw UnsupportedError("Not supported.");
  }
}
