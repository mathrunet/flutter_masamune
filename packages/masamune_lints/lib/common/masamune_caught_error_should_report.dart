part of "/masamune_lints.dart";

class _MasamuneCaughtErrorShouldReport extends DartLintRule {
  const _MasamuneCaughtErrorShouldReport()
      : super(
          code: _code,
        );

  static const _code = lint_codes.LintCode(
    name: "masamune_caught_error_should_report",
    problemMessage:
        "An untyped catch handles an unexpected error. Report the caught error and stack trace with appLogger.error(e, stackTrace), or propagate it with rethrow/throw. 型指定なしのcatchは想定外エラーを処理します。捕捉したエラーとスタックトレースをappLogger.error(e, stackTrace)で報告するか、rethrow/throwで伝播してください。",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCatchClause((node) {
      // A typed `on XxxException catch` explicitly declares an expected
      // error. It is handled locally and does not need incident reporting.
      if (node.exceptionType != null) {
        return;
      }
      if (node.isReportingCaughtError()) {
        return;
      }
      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [_MasamuneCaughtErrorShouldReportFix()];
}

class _MasamuneCaughtErrorShouldReportFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addCatchClause((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }
      if (node.exceptionType != null || node.isReportingCaughtError()) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: "Report the caught error with appLogger.error",
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        final exceptionName = node.exceptionParameter?.name.lexeme;
        if (exceptionName == null) {
          // An untyped catch always has an exception parameter.
          return;
        }
        final stackTraceName = node.stackTraceParameter?.name.lexeme;

        if (stackTraceName == null) {
          builder.addSimpleInsertion(
            node.exceptionParameter!.sourceRange.end,
            ", stackTrace",
          );
        }

        // `unawaited` is not in scope by default, so only add `await` when the
        // enclosing body is asynchronous and drop the future otherwise.
        final isAsync =
            node.thisOrAncestorOfType<FunctionBody>()?.isAsynchronous ?? false;
        builder.addSimpleInsertion(
          node.body.leftBracket.end,
          "\n${_indentOf(resolver, node)}  ${isAsync ? "await " : ""}appLogger.error($exceptionName, ${stackTraceName ?? "stackTrace"});",
        );
      });
    });
  }

  /// Get the indentation of the enclosing `try` so the inserted line lines up.
  ///
  /// [node] starts at the `on`/`catch` keyword, which sits mid-line, so its own
  /// column cannot be used.
  String _indentOf(CustomLintResolver resolver, CatchClause node) {
    final offset = node.thisOrAncestorOfType<TryStatement>()?.offset;
    if (offset == null) {
      return "";
    }
    final location = resolver.lineInfo.getLocation(offset);
    return " " * (location.columnNumber - 1);
  }
}

extension on CatchClause {
  /// Whether this catch reports the same error and stack trace, or propagates
  /// the error to an upper-level handler.
  bool isReportingCaughtError() {
    final visitor = _CaughtErrorReportVisitor(
      exceptionName: exceptionParameter?.name.lexeme,
      stackTraceName: stackTraceParameter?.name.lexeme,
    );
    body.accept(visitor);
    return visitor.found;
  }
}

/// Walks a catch body looking for a `rethrow`, a `throw`, or an exact
/// `appLogger.error(caughtError, caughtStackTrace)` call.
class _CaughtErrorReportVisitor extends RecursiveAstVisitor<void> {
  _CaughtErrorReportVisitor({
    required this.exceptionName,
    required this.stackTraceName,
  });

  final String? exceptionName;
  final String? stackTraceName;

  bool found = false;

  @override
  void visitRethrowExpression(RethrowExpression node) {
    found = true;
    super.visitRethrowExpression(node);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    found = true;
    super.visitThrowExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_isCaughtErrorReport(node)) {
      found = true;
    }
    super.visitMethodInvocation(node);
  }

  bool _isCaughtErrorReport(MethodInvocation node) {
    if (exceptionName == null || stackTraceName == null) {
      return false;
    }
    if (node.methodName.name != "error") {
      return false;
    }
    final target = node.realTarget;
    if (target is! SimpleIdentifier || target.name != "appLogger") {
      return false;
    }
    final targetType = target.staticType;
    if (targetType is! InterfaceType || !_isLoggerType(targetType)) {
      return false;
    }
    final positionalArguments = node.argumentList.arguments
        .where((argument) => argument is! NamedExpression)
        .toList(growable: false);
    if (positionalArguments.length < 2) {
      return false;
    }
    final errorArgument = positionalArguments[0];
    final stackTraceArgument = positionalArguments[1];
    return errorArgument is SimpleIdentifier &&
        errorArgument.name == exceptionName &&
        stackTraceArgument is SimpleIdentifier &&
        stackTraceArgument.name == stackTraceName;
  }

  bool _isLoggerType(InterfaceType type) {
    if (type.getDisplayString().split("<").first == "Logger") {
      return true;
    }
    return type.allSupertypes.any(
      (supertype) => supertype.getDisplayString().split("<").first == "Logger",
    );
  }
}
