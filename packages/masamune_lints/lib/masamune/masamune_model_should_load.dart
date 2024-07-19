part of '/masamune_lints.dart';

class _MasamuneModelShouldLoad extends DartLintRule {
  const _MasamuneModelShouldLoad() : super(code: _code);

  static const _code = LintCode(
    name: "masamune_model_should_load",
    problemMessage:
        "The object obtained from ref.app.model must be executed with the load or reload or aggregate method. Change ref to appRef to avoid this. ref.app.modelから取得したオブジェクトはloadメソッドもしくはreloadメソッド、もしくはaggregateメソッドを実行する必要があります。refをappRefに変更すると回避できます。",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final res = <_MasamuneModelShouldLoadValue>[];

    // メソッドの実行時
    context.registry.addMethodInvocation((node) {
      final buildMethod = node.thisOrAncestorOfType<MethodDeclaration>();
      if (buildMethod == null || buildMethod.name.lexeme != "build") {
        return;
      }
      final functionName = node.methodName.name;
      switch (functionName) {
        case "model":
        case "controller":
        case "watch":
        case "cache":
          final targetType = node.target?.staticType.toString();
          if (targetType != "PageRef" &&
              targetType != "WidgetRef" &&
              targetType != "AppScopedValueRef") {
            return;
          }
          final found = res.firstWhereOrNull((e) => e.node == node);
          if (found != null) {
            // 直接loadメソッドを呼び出しているときこちらは後に呼ばれる
            found.isLoad = true;
            return;
          }
          final variable = node.thisOrAncestorOfType<VariableDeclaration>();
          if (variable == null) {
            res.add(
              _MasamuneModelShouldLoadValue()
                ..method = node
                ..node = node
                ..isModel = functionName == "model",
            );
          } else {
            res.add(
              _MasamuneModelShouldLoadValue()
                ..variableName = variable.name.lexeme
                ..variable = variable
                ..method = node
                ..node = node
                ..isModel = functionName == "model",
            );
          }
          break;
        case "load":
        case "create":
        case "reload":
        case "aggregate":
        case "search":
          // 変数に入れていないとき
          final parentMethodInvocationNode =
              node.target?.thisOrAncestorOfType<MethodInvocation>() ??
                  node.parent?.thisOrAncestorOfType<MethodInvocation>();
          if (parentMethodInvocationNode != null &&
              parentMethodInvocationNode != node) {
            final found = res.firstWhereOrNull(
                (e) => e.method == parentMethodInvocationNode);
            if (found != null) {
              found
                ..isLoad = true
                ..method = parentMethodInvocationNode
                ..node = parentMethodInvocationNode;
            } else {
              res.add(
                _MasamuneModelShouldLoadValue()
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
                    .thisOrAncestorOfType<MethodInvocation>();
            if (parentMethodInvocationNode != null &&
                parentMethodInvocationNode != node) {
              final found = res.firstWhereOrNull(
                  (e) => e.method == parentMethodInvocationNode);
              if (found != null) {
                found
                  ..isLoad = true
                  ..method = parentMethodInvocationNode
                  ..node = parentMethodInvocationNode;
              } else {
                res.add(
                  _MasamuneModelShouldLoadValue()
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
              found.isLoad = true;
              return;
            }
          }
          // 変数に入れているときかつメソッドを呼び出しているとき
          final simpleIdentifier = node.thisOrTargetOfType<SimpleIdentifier>();
          if (simpleIdentifier != null) {
            final found = res.firstWhereOrNull(
                (e) => e.variableName == simpleIdentifier.name);
            found?.isLoad = true;
            return;
          }
          final methodInvocation = node.thisOrTargetOfType<MethodInvocation>();
          if (methodInvocation != null) {
            final found =
                res.firstWhereOrNull((e) => e.method == methodInvocation);
            if (found != null) {
              found
                ..isLoad = true
                ..method = methodInvocation
                ..node = methodInvocation;
            } else {
              res.add(
                _MasamuneModelShouldLoadValue()
                  ..method = methodInvocation
                  ..node = methodInvocation,
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
        if (node.isLoad || !node.isModel || node.node == null) {
          continue;
        }
        reporter.reportErrorForNode(
          _code,
          node.node!,
        );
      }
    });
  }
}

class _MasamuneModelShouldLoadValue {
  String? variableName;
  MethodInvocation? method;
  VariableDeclaration? variable;
  AstNode? node;
  bool isLoad = false;
  bool isModel = false;

  @override
  String toString() {
    return "Variable: $variableName($variable) Method: $method Node: $node IsLoad: $isLoad";
  }
}
