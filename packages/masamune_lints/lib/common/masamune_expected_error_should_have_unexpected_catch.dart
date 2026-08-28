part of "/masamune_lints.dart";

class _MasamuneExpectedErrorShouldHaveUnexpectedCatch
    extends _MasamuneAnalysisRule {
  _MasamuneExpectedErrorShouldHaveUnexpectedCatch() : super(code);

  static const code = LintCode(
    "masamune_expected_error_should_have_unexpected_catch",
    "A try statement with typed catches for expected errors must end with an untyped catch for unexpected errors. 想定内エラーを型付きcatchで処理するtryは、想定外エラー用の型指定なしcatchを最後に置いてください。",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  void run(_MasamuneRuleContext context) {
    context.registry.addTryStatement((node) {
      final catchClauses = node.catchClauses;
      if (catchClauses.isEmpty ||
          !catchClauses.any((clause) => clause.exceptionType != null)) {
        return;
      }
      if (catchClauses.last.exceptionType == null) {
        return;
      }
      reportAtNode(catchClauses.last);
    });
  }
}
