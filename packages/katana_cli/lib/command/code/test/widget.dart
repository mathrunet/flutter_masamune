part of "test.dart";

/// Create a widget test template.
///
/// ウィジェットのテストテンプレートを作成します。
class CodeTestWidgetCliCommand extends CliCodeCommand {
  /// Create a widget test template.
  ///
  /// ウィジェットのテストテンプレートを作成します。
  const CodeTestWidgetCliCommand();

  @override
  String get name => "widget_test";

  @override
  String get prefix => "widgetTest";

  @override
  String get directory => "lib/widgets";

  @override
  String get description =>
      "Create a widget test template in `$directory/(filepath).dart`. ウィジェットのテストテンプレートを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code test widget [widget_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code test widget [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code test widget [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    const command = CodeWidgetCliCommand();
    await command.generateDartTestCode("${command.testDirectory}/$path", path);
  }

  @override
  String body(String path, String baseName, String className) {
    throw UnimplementedError();
  }

  @override
  String header(String path, String baseName, String className) {
    throw UnimplementedError();
  }

  @override
  String import(String path, String baseName, String className) {
    throw UnimplementedError();
  }
}
