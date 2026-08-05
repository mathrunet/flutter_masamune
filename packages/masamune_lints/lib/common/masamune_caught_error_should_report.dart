part of "/masamune_lints.dart";

/// Names of the methods that count as reporting a caught error.
const _kReportMethodNames = {
  "error",
  "reportError",
  "recordError",
};

/// Static types of the receiver allowed for the generic [_kGenericReportMethodNames].
const _kReportReceiverTypes = {
  "Logger",
  "LoggerAdapter",
};

/// Method names that are too generic to be matched by name alone.
///
/// These require the static type of the receiver to be in [_kReportReceiverTypes].
const _kGenericReportMethodNames = {
  "error",
};

class _MasamuneCaughtErrorShouldReport extends DartLintRule {
  const _MasamuneCaughtErrorShouldReport()
      : super(
          code: _code,
        );

  static const _code = lint_codes.LintCode(
    name: "masamune_caught_error_should_report",
    problemMessage:
        "Exceptions swallowed by try-catch never reach FlutterError.onError, PlatformDispatcher.onError or runZonedGuarded, so they become invisible to the AI Debugger. Report it with appLogger.error(e, stackTrace), or rethrow it. try-catchで握り潰された例外はFlutterError.onErrorやPlatformDispatcher.onError、runZonedGuardedに到達せず、AI Debuggerから不可視になります。appLogger.error(e, stackTrace)で報告するか、rethrowしてください。",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCatchClause((node) {
      if (node.body.isReportingCaughtError()) {
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
      if (node.body.isReportingCaughtError()) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: "Report the caught error with appLogger.error",
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        final exceptionName = node.exceptionParameter?.name.lexeme;
        final stackTraceName = node.stackTraceParameter?.name.lexeme;

        // `on Xxx { }` has no catch clause at all, so add one.
        if (exceptionName == null) {
          final onType = node.exceptionType;
          if (onType == null) {
            // Should not happen. A catch clause always has `on` or `catch`.
            return;
          }
          builder.addSimpleInsertion(
            onType.sourceRange.end,
            " catch (e, stackTrace)",
          );
        } else if (stackTraceName == null) {
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
          "\n${_indentOf(resolver, node)}  ${isAsync ? "await " : ""}appLogger.error(${exceptionName ?? "e"}, ${stackTraceName ?? "stackTrace"});",
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

extension on AstNode {
  /// Whether this subtree reports or propagates the caught error.
  bool isReportingCaughtError() {
    final visitor = _CaughtErrorReportVisitor();
    accept(visitor);
    return visitor.found;
  }
}

/// Walks a catch body looking for a `rethrow`, a `throw` or a report call.
class _CaughtErrorReportVisitor extends RecursiveAstVisitor<void> {
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
    final methodName = node.methodName.name;
    if (_kReportMethodNames.contains(methodName)) {
      if (!_kGenericReportMethodNames.contains(methodName) ||
          _hasAllowedReceiver(node)) {
        found = true;
      }
    }
    super.visitMethodInvocation(node);
  }

  /// Whether the static type of the receiver of [node] is an allowed logger type.
  ///
  /// `error` is too generic a name to match on its own, so an unrelated `foo.error()` must not be treated as a report.
  bool _hasAllowedReceiver(MethodInvocation node) {
    final target = node.realTarget;
    if (target == null) {
      return false;
    }
    final staticType = target.staticType;
    if (staticType == null) {
      return false;
    }
    if (_kReportReceiverTypes
        .contains(staticType.getDisplayString().split("<").first)) {
      return true;
    }
    // Also allow subclasses of LoggerAdapter such as FirebaseLoggerAdapter.
    if (staticType is InterfaceType) {
      for (final supertype in staticType.allSupertypes) {
        if (_kReportReceiverTypes
            .contains(supertype.getDisplayString().split("<").first)) {
          return true;
        }
      }
    }
    return false;
  }
}
