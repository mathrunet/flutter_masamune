part of '/masamune_lints.dart';

const _kMaxNestingCount = 3;

class _MasamuneLimitIfNesting extends DartLintRule {
  const _MasamuneLimitIfNesting()
      : super(
          code: _code,
        );

  static const _code = lint_codes.LintCode(
    name: "masamune_if_nesting_should_limit",
    problemMessage:
        "Nesting hierarchy for if should be limited to $_kMaxNestingCount units. ifのネスト階層は$_kMaxNestingCount個までにしてください。",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addIfStatement((node) {
      int nestingLevel = 0;
      AstNode? currentNode = node;

      while (currentNode != null) {
        if (currentNode is IfStatement && currentNode.elseStatement == null) {
          nestingLevel++;
        }
        currentNode = currentNode.parent;
      }

      if (nestingLevel > _kMaxNestingCount) {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}
