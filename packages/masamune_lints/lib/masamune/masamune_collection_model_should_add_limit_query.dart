part of '/masamune_lints.dart';

class _MasamuneCollectionModelShouldAddLimitQuery extends DartLintRule {
  const _MasamuneCollectionModelShouldAddLimitQuery() : super(code: _code);

  static const _code = lint_codes.LintCode(
    name: "masamune_model_should_add_limit_query",
    problemMessage:
        "When querying in the collection model, [limitTo] must be used to limit the number of queries. Conversely, [limitTo] must not be specified when using [aggregate]. コレクションモデルでクエリする場合は[limitTo]で数の制限をする必要があります。[aggregate]を用いる場合は逆に[limitTo]を指定してはいけません。",
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
      final model = node.parent?.thisOrAncestorOfType<MethodInvocation>();
      final modelFound = res.firstWhereOrNull((e) => e.model == model);
      if (modelFound != null) {
        final variable = node.thisOrAncestorOfType<VariableDeclaration>();
        if (variable == null) {
          modelFound
            ..method = node
            ..node = node;
        } else {
          modelFound
            ..variableName = variable.name.lexeme
            ..variable = variable
            ..method = node
            ..node = node;
        }
      } else {
        final variable = node.thisOrAncestorOfType<VariableDeclaration>();
        if (variable == null) {
          res.add(
            _MasamuneCollectionModelShouldAddLimitQueryValue()
              ..method = node
              ..node = node
              ..model = model,
          );
        } else {
          res.add(
            _MasamuneCollectionModelShouldAddLimitQueryValue()
              ..variableName = variable.name.lexeme
              ..variable = variable
              ..method = node
              ..node = node
              ..model = model,
          );
        }
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
            final model = node.parent?.thisOrAncestorOfType<MethodInvocation>();
            final modelFound = res.firstWhereOrNull((e) => e.model == model);
            final found = res.firstWhereOrNull(
                    (e) => e.method == parentMethodInvocationNode) ??
                modelFound;

            if (found != null) {
              found
                ..isLimit = true
                ..method = parentMethodInvocationNode
                ..node = parentMethodInvocationNode;
            } else {
              res.add(
                _MasamuneCollectionModelShouldAddLimitQueryValue()
                  ..method = parentMethodInvocationNode
                  ..node = parentMethodInvocationNode
                  ..model = model,
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
              final model =
                  node.parent?.thisOrAncestorOfType<MethodInvocation>();
              final modelFound = res.firstWhereOrNull((e) => e.model == model);
              final found = res.firstWhereOrNull(
                      (e) => e.method == parentMethodInvocationNode) ??
                  modelFound;
              if (found != null) {
                found
                  ..isLimit = true
                  ..method = parentMethodInvocationNode
                  ..node = parentMethodInvocationNode;
              } else {
                res.add(
                  _MasamuneCollectionModelShouldAddLimitQueryValue()
                    ..method = parentMethodInvocationNode
                    ..node = parentMethodInvocationNode
                    ..model = model,
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
            final model = node.parent?.thisOrAncestorOfType<MethodInvocation>();
            final modelFound = res.firstWhereOrNull((e) => e.model == model);
            final found = res.firstWhereOrNull(
                    (e) => e.method == functionExpressionInvocation) ??
                modelFound;
            if (found != null) {
              found
                ..isLimit = true
                ..method = functionExpressionInvocation
                ..node = functionExpressionInvocation;
            } else {
              res.add(
                _MasamuneCollectionModelShouldAddLimitQueryValue()
                  ..method = functionExpressionInvocation
                  ..node = functionExpressionInvocation
                  ..model = model,
              );
            }
          }
          break;
        case "model":
          final targetType = node.target?.staticType.toString();
          if (targetType != "PageRef" &&
              targetType != "WidgetRef" &&
              targetType != "AppScopedValueRef") {
            return;
          }
          final found = res.firstWhereOrNull((e) => e.model == node);
          if (found != null) {
            // 直接createメソッドを呼び出しているときこちらは後に呼ばれる
            return;
          }
          final variable = node.thisOrAncestorOfType<VariableDeclaration>();
          if (variable == null) {
            res.add(
              _MasamuneCollectionModelShouldAddLimitQueryValue()..model = node,
            );
          } else {
            res.add(
              _MasamuneCollectionModelShouldAddLimitQueryValue()
                ..modelVariableName = variable.name.lexeme
                ..modelVariable = variable
                ..model = node,
            );
          }
          break;
        case "create":
        case "aggregate":
          // 変数に入れていないとき
          final parentMethodInvocationNode =
              node.target?.thisOrAncestorOfType<MethodInvocation>() ??
                  node.parent?.thisOrAncestorOfType<MethodInvocation>();
          if (parentMethodInvocationNode != null &&
              parentMethodInvocationNode != node) {
            final found = res
                .firstWhereOrNull((e) => e.model == parentMethodInvocationNode);
            if (found != null) {
              found.isCreate = functionName == "create";
              found.isAggregate = functionName == "aggregate";
            } else {
              res.add(
                _MasamuneCollectionModelShouldAddLimitQueryValue()
                  ..model = parentMethodInvocationNode
                  ..isCreate = functionName == "create"
                  ..isAggregate = functionName == "aggregate",
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
                  (e) => e.model == parentMethodInvocationNode);
              if (found != null) {
                found.isCreate = functionName == "create";
                found.isAggregate = functionName == "aggregate";
              } else {
                res.add(
                  _MasamuneCollectionModelShouldAddLimitQueryValue()
                    ..model = parentMethodInvocationNode
                    ..isCreate = functionName == "create"
                    ..isAggregate = functionName == "aggregate",
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
                (e) => e.modelVariable == parentVariableDeclarationNode);
            if (found != null) {
              found.isCreate = functionName == "create";
              found.isAggregate = functionName == "aggregate";
              return;
            }
          }
          // 変数に入れているときかつメソッドを呼び出しているとき
          final simpleIdentifier = node.thisOrTargetOfType<SimpleIdentifier>();
          if (simpleIdentifier != null) {
            final found = res.firstWhereOrNull(
                (e) => e.modelVariableName == simpleIdentifier.name);
            found?.isCreate = functionName == "create";
            found?.isAggregate = functionName == "aggregate";
            return;
          }
          final methodInvocation = node.thisOrTargetOfType<MethodInvocation>();
          if (methodInvocation != null) {
            final found =
                res.firstWhereOrNull((e) => e.model == methodInvocation);
            if (found != null) {
              found.isCreate = functionName == "create";
              found.isAggregate = functionName == "aggregate";
            } else {
              res.add(
                _MasamuneCollectionModelShouldAddLimitQueryValue()
                  ..model = methodInvocation
                  ..isCreate = functionName == "create"
                  ..isAggregate = functionName == "aggregate",
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
        if (node.node == null) {
          continue;
        }
        if (node.isAggregate) {
          if (node.isLimit) {
            reporter.reportErrorForNode(
              _code,
              node.node!,
            );
          }
          continue;
        }
        if (node.isLimit || node.isCreate) {
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

class _MasamuneCollectionModelShouldAddLimitQueryValue {
  String? variableName;
  FunctionExpressionInvocation? method;
  VariableDeclaration? variable;
  AstNode? node;
  MethodInvocation? model;
  VariableDeclaration? modelVariable;
  String? modelVariableName;
  bool isLimit = false;
  bool isAggregate = false;
  bool isCreate = false;

  @override
  String toString() {
    return "Query: $variableName($variable) Node: $node IsLimit: $isLimit $isAggregate $isCreate";
  }
}
