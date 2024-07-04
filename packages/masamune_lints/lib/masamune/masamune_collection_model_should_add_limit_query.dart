part of '/masamune_lints.dart';

class _MasamuneCollectionModelShouldAddLimitQuery extends DartLintRule {
  const _MasamuneCollectionModelShouldAddLimitQuery() : super(code: _code);

  static const _code = LintCode(
    name: "masamune_model_should_add_limit_query",
    problemMessage:
        "When querying the collection model, it is necessary to limit the number with [limitTo]. コレクションモデルをクエリする場合は[limitTo]で数の制限をする必要があります。",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final res = <_MasamuneCollectionModelShouldAddLimitQueryValue>[];

    /// Functionの実行時
    context.registry.addFunctionExpressionInvocation((node) {
      final buildMethod = node.thisOrAncestorOfType<MethodDeclaration>();
      if (buildMethod == null || buildMethod.name.lexeme != "build") {
        return;
      }
      final found = res.firstWhereOrNull((e) => e.node == node);
      if (found != null) {
        // 直接limitToメソッドを呼び出しているときこちらは後に呼ばれる
        found.isLimit = true;
        return;
      }
      final function = node.function;
      if (function is! PropertyAccess) {
        return;
      }
      final functionType = function.staticType;
      if (functionType is! InterfaceType ||
          !functionType.toString().endsWith("ModelCollectionQuery")) {
        return;
      }
      final variable = node.thisOrAncestorOfType<VariableDeclaration>();
      if (variable == null) {
        res.add(
          _MasamuneCollectionModelShouldAddLimitQueryValue()
            ..method = node
            ..node = node,
        );
      } else {
        res.add(
          _MasamuneCollectionModelShouldAddLimitQueryValue()
            ..variableName = variable.name.lexeme
            ..variable = variable
            ..method = node
            ..node = node,
        );
      }
    });

    // メソッドの実行時
    context.registry.addMethodInvocation((node) {
      final buildMethod = node.thisOrAncestorOfType<MethodDeclaration>();
      if (buildMethod == null || buildMethod.name.lexeme != "build") {
        return;
      }
      final functionName = node.methodName.name;
      switch (functionName) {
        case "limitTo":
          // 変数に入れていないとき
          final parentMethodInvocationNode = node.target
                  ?.thisOrAncestorOfType<FunctionExpressionInvocation>() ??
              node.thisOrAncestorOfType<FunctionExpressionInvocation>();
          if (parentMethodInvocationNode != null) {
            final found = res.firstWhereOrNull(
                (e) => e.method == parentMethodInvocationNode);
            if (found != null) {
              found.isLimit = true;
            } else {
              res.add(
                _MasamuneCollectionModelShouldAddLimitQueryValue()
                  ..method = parentMethodInvocationNode
                  ..node = parentMethodInvocationNode,
              );
            }
            return;
          }
          // 変数に入れていないときかつカスケードでメソッドを呼び出しているとき
          final parentCascadeExpressionVariableNode =
              node.parent?.thisOrAncestorOfType<CascadeExpression>();
          if (parentCascadeExpressionVariableNode != null) {
            final parentMethodInvocationNode =
                parentCascadeExpressionVariableNode.target
                    .thisOrAncestorOfType<FunctionExpressionInvocation>();
            if (parentMethodInvocationNode != null) {
              final found = res.firstWhereOrNull(
                  (e) => e.method == parentMethodInvocationNode);
              if (found != null) {
                found.isLimit = true;
              } else {
                res.add(
                  _MasamuneCollectionModelShouldAddLimitQueryValue()
                    ..method = parentMethodInvocationNode
                    ..node = parentMethodInvocationNode,
                );
              }
              return;
            }
          }
          // 変数に入れているとき
          final parentVariableDeclarationNode =
              node.thisOrAncestorOfType<VariableDeclaration>();
          if (parentVariableDeclarationNode != null) {
            final found = res.firstWhereOrNull(
                (e) => e.variable == parentVariableDeclarationNode);
            if (found != null) {
              found.isLimit = true;
              return;
            }
          }
          // 変数に入れているときかつメソッドを呼び出しているとき
          final simpleIdentifier = node.thisOrTargetOfType<SimpleIdentifier>();
          if (simpleIdentifier != null) {
            final found = res.firstWhereOrNull(
                (e) => e.variableName == simpleIdentifier.name);
            found?.isLimit = true;
            return;
          }
          final functionExpressionInvocation =
              node.thisOrTargetOfType<FunctionExpressionInvocation>();
          if (functionExpressionInvocation != null) {
            final found = res.firstWhereOrNull(
                (e) => e.method == functionExpressionInvocation);
            if (found != null) {
              found.isLimit = true;
            } else {
              res.add(
                _MasamuneCollectionModelShouldAddLimitQueryValue()
                  ..method = functionExpressionInvocation
                  ..node = functionExpressionInvocation,
              );
            }
          }
          break;
      }
    });

    // すべての処理が終わった後
    context.addPostRunCallback(() {
      if (res.isEmpty) {
        return;
      }
      for (final node in res) {
        if (node.isLimit) {
          continue;
        }
        reporter.atNode(
          node.node!,
          _code,
        );
      }
    });
  }
}

class _MasamuneCollectionModelShouldAddLimitQueryValue {
  String? variableName;
  FunctionExpressionInvocation? method;
  VariableDeclaration? variable;
  AstNode? node;
  bool isLimit = false;

  @override
  String toString() {
    return "Query: $variableName($variable) Node: $node IsLimit: $isLimit";
  }
}
