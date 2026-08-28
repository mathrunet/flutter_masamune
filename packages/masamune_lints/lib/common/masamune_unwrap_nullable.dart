part of "/masamune_lints.dart";

class _MasamuneUnwrapNullable extends _MasamuneAnalysisRule {
  _MasamuneUnwrapNullable() : super(code);

  static const code = LintCode(
    "masamune_nullable_should_not_unwrap",
    "Unwrapping a nullable variable using the ! operator is used to unwrap a nullable variable; consider performing a null check or using the ? operator. nullableな変数に対して!演算子を使用してアンラップしています。nullチェックを行うか、?演算子を使用することを検討してください。",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  void run(_MasamuneRuleContext context) {
    context.registry.addPostfixExpression((node) {
      if (node.operator.type == TokenType.BANG) {
        final operandType = node.operand.staticType;
        if (operandType != null &&
            operandType.nullabilitySuffix == NullabilitySuffix.question) {
          reportAtNode(node);
        }
      }
    });
  }
}
