part of katana_cli;

/// Firebase Functions index.ts codebase.
///
/// Firebase Functionsのindex.tsのコードベース。
class FirebaseFunctionsIndexCliCode extends CliCode {
  /// Firebase Functions index.ts codebase.
  ///
  /// Firebase Functionsのindex.tsのコードベース。
  const FirebaseFunctionsIndexCliCode();

  @override
  String get name => "index";

  @override
  String get prefix => "index";

  @override
  String get directory => "firebase/functions/src";

  @override
  String get description =>
      "Define the code for index.ts in Firebase Functions. Firebase Functionsのindex.tsのコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import * as m from "@mathrunet/masamune";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
// Define [m.Functions.xxxx] for the functions to be added to Functions.
// 
// Functionsに追加する機能を[m.Functions.xxxx]を定義してください。
m.deploy(
    exports,
    [],
);
""";
  }
}
