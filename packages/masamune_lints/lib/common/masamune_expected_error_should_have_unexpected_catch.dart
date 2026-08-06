part of "/masamune_lints.dart";

class _MasamuneExpectedErrorShouldHaveUnexpectedCatch extends DartLintRule {
  const _MasamuneExpectedErrorShouldHaveUnexpectedCatch()
      : super(
          code: _code,
        );

  static const _code = lint_codes.LintCode(
    name: "masamune_expected_error_should_have_unexpected_catch",
    problemMessage:
        "A try statement with typed catches for expected errors must end with an untyped catch for unexpected errors. 想定内エラーを型付きcatchで処理するtryは、想定外エラー用の型指定なしcatchを最後に置いてください。",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addTryStatement((node) {
      final catchClauses = node.catchClauses;
      if (catchClauses.isEmpty ||
          !catchClauses.any((clause) => clause.exceptionType != null)) {
        return;
      }
      if (catchClauses.last.exceptionType == null) {
        return;
      }
      reporter.atNode(catchClauses.last, _code);
    });
  }
}
