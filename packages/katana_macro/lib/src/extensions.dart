part of '/katana_macro.dart';

/// Extension method of [ConstructorDeclaration].
///
/// [ConstructorDeclaration]の拡張メソッド。
extension MacroConstructorDeclarationExtensions on ConstructorDeclaration {
  /// Returns a concatenated list of [namedParameters] and [positionalParameters].
  ///
  /// [namedParameters]と[positionalParameters]を結合したリストを返します。
  List<FormalParameterDeclaration> get parameters {
    return [...namedParameters, ...positionalParameters]
        .distinct((e) => e.identifier.name);
  }
}

/// Extension method of [Builder].
///
/// [Builder]の拡張メソッド。
extension MacroBuilderExtensions on Builder {
  /// [message] can be printed.
  ///
  /// If [isError] is set to `true`, it is treated as an error.
  ///
  /// [message]をプリント可能です。
  ///
  /// [isError]を`true`にするとエラーとして扱われます。
  void print(String message, {bool isError = false}) {
    report(
      Diagnostic(
        DiagnosticMessage(message),
        isError ? Severity.error : Severity.info,
      ),
    );
  }
}
