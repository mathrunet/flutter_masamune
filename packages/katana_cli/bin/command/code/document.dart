part of katana_cli;

/// Create a base class for the document model in `lib/model/(filepath).dart`.
///
/// ドキュメントモデルのベースクラスを`lib/model/(filepath).dart`に作成します。
class CodeDocumentCliCommand extends CliCommand {
  /// Create a base class for the document model in `lib/model/(filepath).dart`.
  ///
  /// ドキュメントモデルのベースクラスを`lib/model/(filepath).dart`に作成します。
  const CodeDocumentCliCommand();

  @override
  String get description =>
      "Create a base class for the document model in `lib/model/(filepath).dart`. ドキュメントモデルのベースクラスを`lib/model/(filepath).dart`に作成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final path = args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code document [path]\r\n",
      );
      return;
    }
    label("Create a document class in `lib/page/$path.dart`.");
    await const DocumentModelCliCode().generateDartCode("lib/model/$path");
  }
}
