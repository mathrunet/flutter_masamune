part of katana_cli;

/// Create a base class for the document model.
///
/// ドキュメントモデルのベースクラスを作成します。
class CodeDocumentCliCommand extends CliCommand {
  /// Create a base class for the document model.
  ///
  /// ドキュメントモデルのベースクラスを作成します。
  const CodeDocumentCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = DocumentModelCliCode();

  @override
  String get description =>
      "Create a base class for the document model in `${code.directory}/(filepath).dart`. ドキュメントモデルのベースクラスを`${code.directory}/(filepath).dart`に作成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final path = args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code document [path]\r\n",
      );
      return;
    }
    label("Create a document class in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
