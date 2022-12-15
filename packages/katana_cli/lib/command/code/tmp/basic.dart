part of katana_cli.code.tmp;

/// Create templates to create forms for listing, detailing, adding, and editing data.
///
/// データの一覧、詳細、追加、編集のフォームを作成するためのテンプレートを作成します。
class CodeTmpBasicCliCommand extends CliCommand {
  /// Create templates to create forms for listing, detailing, adding, and editing data.
  ///
  /// データの一覧、詳細、追加、編集のフォームを作成するためのテンプレートを作成します。
  const CodeTmpBasicCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = TmpBasicCliCode();

  @override
  String get description =>
      "Create a template in `${code.directory}/(filepath).dart` to create forms for listing, detailing, adding and editing data. データの一覧、詳細、追加、編集のフォームを作成するためのテンプレートを`${code.directory}/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code tmp form [path]\r\n",
      );
      return;
    }
    label("Create a basic template in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
