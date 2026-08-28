part of "/masamune_lints.dart";

class _MasamuneCaughtErrorShouldReport extends _MasamuneAnalysisRule {
  _MasamuneCaughtErrorShouldReport() : super(code);

  static const code = LintCode(
    "masamune_caught_error_should_report",
    "An untyped catch handles an unexpected error. Report the caught error and stack trace with appLogger.error(e, stackTrace), or propagate it with rethrow/throw. 型指定なしのcatchは想定外エラーを処理します。捕捉したエラーとスタックトレースをappLogger.error(e, stackTrace)で報告するか、rethrow/throwで伝播してください。",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  void run(_MasamuneRuleContext context) {
    context.registry.addCatchClause((node) {
      // A typed `on XxxException catch` explicitly declares an expected
      // error. It is handled locally and does not need incident reporting.
      if (node.exceptionType != null) {
        return;
      }
      if (node.isReportingCaughtError()) {
        return;
      }
      reportAtNode(node);
    });
  }
}

class _MasamuneCaughtErrorShouldReportFix extends ResolvedCorrectionProducer {
  static const _fixKind = FixKind(
    "masamune_lints.fix.report_caught_error",
    DartFixKindPriority.standard,
    "Report the caught error with appLogger.error",
  );

  _MasamuneCaughtErrorShouldReportFix({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final catchClause = node.thisOrAncestorOfType<CatchClause>();
    if (catchClause == null ||
        catchClause.exceptionType != null ||
        catchClause.isReportingCaughtError()) {
      return;
    }
    final exceptionName = catchClause.exceptionParameter?.name.lexeme;
    if (exceptionName == null) {
      return;
    }
    final stackTraceName = catchClause.stackTraceParameter?.name.lexeme;
    await builder.addDartFileEdit(file, (builder) {
      if (stackTraceName == null) {
        builder.addSimpleInsertion(
          catchClause.exceptionParameter!.end,
          ", stackTrace",
        );
      }
      final isAsync =
          catchClause.thisOrAncestorOfType<FunctionBody>()?.isAsynchronous ??
          false;
      builder.addSimpleInsertion(
        catchClause.body.leftBracket.end,
        "\n${_indentOf(catchClause)}  ${isAsync ? "await " : ""}appLogger.error($exceptionName, ${stackTraceName ?? "stackTrace"});",
      );
    });
  }

  /// Get the indentation of the enclosing `try` so the inserted line lines up.
  ///
  /// [node] starts at the `on`/`catch` keyword, which sits mid-line, so its own
  /// column cannot be used.
  String _indentOf(CatchClause node) {
    final offset = node.thisOrAncestorOfType<TryStatement>()?.offset;
    if (offset == null) {
      return "";
    }
    final location = unitResult.lineInfo.getLocation(offset);
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
        .where((argument) => _namedArgumentName(argument) == null)
        .toList(growable: false);
    if (positionalArguments.length < 2) {
      return false;
    }
    final errorArgument = _argumentExpression(positionalArguments[0]);
    final stackTraceArgument = _argumentExpression(positionalArguments[1]);
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
