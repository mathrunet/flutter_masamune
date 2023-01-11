part of katana_cli;

/// Firebase Hosting index.html codebase.
///
/// Firebase Hostingのindex.htmlのコードベース。
class FirebaseHostingIndexCliCode extends CliCode {
  /// Firebase Hosting index.html codebase.
  ///
  /// Firebase Hostingのindex.htmlのコードベース。
  const FirebaseHostingIndexCliCode();

  @override
  String get name => "index";

  @override
  String get prefix => "index";

  @override
  String get directory => "firebase/functions/src";

  @override
  String get description =>
      "Define the code for index.html in Firebase Hosting.Firebase Hostingのindex.htmlのコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
""";
  }
}
