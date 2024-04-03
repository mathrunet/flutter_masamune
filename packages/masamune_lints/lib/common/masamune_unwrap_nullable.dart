part of '/masamune_lints.dart';

class _MasamuneUnwrapNullable extends DartLintRule {
  const _MasamuneUnwrapNullable()
      : super(
          code: _code,
        );

  static const _code = LintCode(
    name: "masamune_nullable_should_not_unwrap",
    problemMessage:
        "Unwrapping a nullable variable using the ! operator is used to unwrap a nullable variable; consider performing a null check or using the ? operator. nullableな変数に対して!演算子を使用してアンラップしています。nullチェックを行うか、?演算子を使用することを検討してください。",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPostfixExpression((node) {
      if (node.operator.type == TokenType.BANG) {
        final operandType = node.operand.staticType;
        if (operandType != null &&
            operandType.nullabilitySuffix == NullabilitySuffix.question) {
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }
}
