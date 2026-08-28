part of "/masamune_lints.dart";

const _kMaxNestingCount = 3;

class _MasamuneLimitIfNesting extends _MasamuneAnalysisRule {
  _MasamuneLimitIfNesting() : super(code);

  static const code = LintCode(
    "masamune_if_nesting_should_limit",
    "Nesting hierarchy for if should be limited to $_kMaxNestingCount units. ifのネスト階層は$_kMaxNestingCount個までにしてください。",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  void run(_MasamuneRuleContext context) {
    context.registry.addIfStatement((node) {
      var nestingLevel = 0;
      AstNode? currentNode = node;

      while (currentNode != null) {
        if (currentNode is IfStatement && currentNode.elseStatement == null) {
          nestingLevel++;
        }
        currentNode = currentNode.parent;
      }

      if (nestingLevel > _kMaxNestingCount) {
        reportAtNode(node);
      }
    });
  }
}
