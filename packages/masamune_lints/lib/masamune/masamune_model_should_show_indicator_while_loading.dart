part of '/masamune_lints.dart';

class _MasamuneModelShouldShowIndicatorWhileLoading extends DartLintRule {
  const _MasamuneModelShouldShowIndicatorWhileLoading() : super(code: _code);

  static const _code = LintCode(
    name: "masamune_model_should_show_indicator_while_loading",
    problemMessage:
        "If the object retrieved from ref.app.model is loaded, you must use [UniversalScaffold]->[loadingFuture] or [LoadingBuilder]. Change ref to appRef to avoid this. ref.app.modelから取得したオブジェクトがloadされていた場合必ず[UniversalScaffold]->[loadingFuture]か[LoadingBuilder]を使用する必要があります。refをappRefに変更すると回避できます。",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final res = <_MasamuneModelShouldShowIndicatorWhileLoadingValue>[];

    // メソッドの実行時
    context.registry.addMethodInvocation((node) {
      final buildMethod = node.thisOrAncestorOfType<MethodDeclaration>();
      if (buildMethod == null || buildMethod.name.lexeme != "build") {
        return;
      }
      final functionName = node.methodName.name;
      switch (functionName) {
        case "model":
          final targetType = node.target?.staticType.toString();
          if (targetType != "PageRef" && targetType != "WidgetRef") {
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
              _MasamuneModelShouldShowIndicatorWhileLoadingValue()
                ..method = node
                ..node = node,
            );
          } else {
            res.add(
              _MasamuneModelShouldShowIndicatorWhileLoadingValue()
                ..variableName = variable.name.lexeme
                ..variable = variable
                ..method = node
                ..node = node,
            );
          }
          break;
        case "load":
        case "reload":
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
                _MasamuneModelShouldShowIndicatorWhileLoadingValue()
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
                  _MasamuneModelShouldShowIndicatorWhileLoadingValue()
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
                _MasamuneModelShouldShowIndicatorWhileLoadingValue()
                  ..method = methodInvocation
                  ..node = methodInvocation,
              );
            }
          }
          break;
      }
    });

    // クラスのインスタンス化時
    context.registry.addInstanceCreationExpression((node) {
      final buildMethod = node.thisOrAncestorOfType<MethodDeclaration>();
      if (buildMethod == null || buildMethod.name.lexeme != "build") {
        return;
      }
      final type = node.staticType.toString();
      switch (type) {
        case "UniversalScaffold":
          final targetNode = node.argumentList.arguments.firstWhereOrNull(
            (item) => item.staticParameterElement?.name == "loadingFutures",
          );
          if (targetNode is! NamedExpression) {
            return;
          }
          for (final item in targetNode.childEntities) {
            if (item is! ListLiteral) {
              continue;
            }
            for (final e in item.elements) {
              if (e is PropertyAccess) {
                final targetName = e.target?.toString();
                final found = res.firstWhereOrNull(
                    (element) => element.variableName == targetName);
                found?.isShowIndicator = true;
              } else if (e is PrefixedIdentifier) {
                final targetName = e.prefix.name;
                final found = res.firstWhereOrNull(
                    (element) => element.variableName == targetName);
                found?.isShowIndicator = true;
              }
            }
          }
          break;
        case "LoadingBuilder":
          final targetNode = node.argumentList.arguments.firstWhereOrNull(
            (item) => item.staticParameterElement?.name == "futures",
          );
          if (targetNode is! NamedExpression) {
            return;
          }
          for (final item in targetNode.childEntities) {
            if (item is! ListLiteral) {
              continue;
            }
            for (final e in item.elements) {
              if (e is PropertyAccess) {
                final targetName = e.target?.toString();
                final found = res.firstWhereOrNull(
                    (element) => element.variableName == targetName);
                found?.isShowIndicator = true;
              } else if (e is PrefixedIdentifier) {
                final targetName = e.prefix.name;
                final found = res.firstWhereOrNull(
                    (element) => element.variableName == targetName);
                found?.isShowIndicator = true;
              }
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
        if (node.isShowIndicator || !node.isLoad) {
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

class _MasamuneModelShouldShowIndicatorWhileLoadingValue {
  String? variableName;
  VariableDeclaration? variable;
  MethodInvocation? method;
  AstNode? node;
  bool isLoad = false;
  bool isShowIndicator = false;

  @override
  String toString() {
    return "Variable: $variableName($variable) Node: $node IsLoad: $isLoad isShowIndicator: $isShowIndicator";
  }
}
