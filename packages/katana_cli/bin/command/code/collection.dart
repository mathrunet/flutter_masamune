part of katana_cli;

/// Create a base class for the collection model.
///
/// コレクションモデルのベースクラスを作成します。
class CodeCollectionCliCommand extends CliCommand {
  /// Create a base class for the collection model.
  ///
  /// コレクションモデルのベースクラスを作成します。
  const CodeCollectionCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = CollectionModelCliCode();

  @override
  String get description =>
      "Create a base class for the collection model in `${code.directory}/(filepath).dart`. コレクションモデルのベースクラスを`${code.directory}/(filepath).dart`に作成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final path = args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code collection [path]\r\n",
      );
      return;
    }
    label("Create a collection class in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
