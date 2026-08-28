part of "/masamune_lints.dart";

class _MasamuneModelShouldShowIndicatorWhileLoading
    extends _MasamuneAnalysisRule {
  _MasamuneModelShouldShowIndicatorWhileLoading() : super(code);

  static const code = LintCode(
    "masamune_model_should_show_indicator_while_loading",
    "If the object retrieved from ref.app.model is loaded, you must use [UniversalScaffold]->[loadingFuture] or [LoadingBuilder]. Change ref to appRef to avoid this. ref.app.modelから取得したオブジェクトがloadされていた場合必ず[UniversalScaffold]->[loadingFuture]か[LoadingBuilder]を使用する必要があります。refをappRefに変更すると回避できます。",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  void run(_MasamuneRuleContext context) {
    final res = <_MasamuneModelShouldShowIndicatorWhileLoadingValue>[];
    final indicatorVariables = <String>{};

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
              (e) => e.method == parentMethodInvocationNode,
            );
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
                (e) => e.method == parentMethodInvocationNode,
              );
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
              (e) => e.variable == parentVariableDeclarationNode,
            );
            if (found != null) {
              found.isLoad = true;
              return;
            }
          }
          // 変数に入れているときかつメソッドを呼び出しているとき
          final simpleIdentifier = node.thisOrTargetOfType<SimpleIdentifier>();
          if (simpleIdentifier != null) {
            final found = res.firstWhereOrNull(
              (e) => e.variableName == simpleIdentifier.name,
            );
            found?.isLoad = true;
            return;
          }
          final methodInvocation = node.thisOrTargetOfType<MethodInvocation>();
          if (methodInvocation != null) {
            final found = res.firstWhereOrNull(
              (e) => e.method == methodInvocation,
            );
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
            (item) => item.correspondingParameter?.name == "loadingFutures",
          );
          final targetExpression =
              targetNode == null ? null : _argumentExpression(targetNode);
          if (targetExpression == null) {
            return;
          }
          for (final item in targetExpression.childEntities) {
            if (item is! ListLiteral) {
              continue;
            }
            for (final e in item.elements) {
              if (e is PropertyAccess) {
                final targetName = e.target?.toString();
                final found = res.firstWhereOrNull(
                  (element) => element.variableName == targetName,
                );
                found?.isShowIndicator = true;
                if (targetName != null) {
                  indicatorVariables.add(targetName);
                }
              } else if (e is PrefixedIdentifier) {
                final targetName = e.prefix.name;
                final found = res.firstWhereOrNull(
                  (element) => element.variableName == targetName,
                );
                found?.isShowIndicator = true;
                indicatorVariables.add(targetName);
              }
            }
          }
          break;
        case "LoadingBuilder":
          final targetNode = node.argumentList.arguments.firstWhereOrNull(
            (item) => item.correspondingParameter?.name == "futures",
          );
          final targetExpression =
              targetNode == null ? null : _argumentExpression(targetNode);
          if (targetExpression == null) {
            return;
          }
          for (final item in targetExpression.childEntities) {
            if (item is! ListLiteral) {
              continue;
            }
            for (final e in item.elements) {
              if (e is PropertyAccess) {
                final targetName = e.target?.toString();
                final found = res.firstWhereOrNull(
                  (element) => element.variableName == targetName,
                );
                found?.isShowIndicator = true;
                if (targetName != null) {
                  indicatorVariables.add(targetName);
                }
              } else if (e is PrefixedIdentifier) {
                final targetName = e.prefix.name;
                final found = res.firstWhereOrNull(
                  (element) => element.variableName == targetName,
                );
                found?.isShowIndicator = true;
                indicatorVariables.add(targetName);
              }
            }
          }
          break;
      }
    });

    // Analyzer 14 represents constructor invocations without `new` as
    // MethodInvocation nodes. Keep the same LoadingBuilder/UniversalScaffold
    // condition for Dart 3.13 and later.
    context.registry.addMethodInvocation((node) {
      final buildMethod = node.thisOrAncestorOfType<MethodDeclaration>();
      if (buildMethod == null || buildMethod.name.lexeme != "build") {
        return;
      }
      final type = node.staticType is InterfaceType
          ? node.staticType!.getDisplayString().split("<").first
          : node.target == null
              ? node.methodName.name
              : null;
      final parameterName = switch (type) {
        "UniversalScaffold" => "loadingFutures",
        "LoadingBuilder" => "futures",
        _ => null,
      };
      if (parameterName == null) {
        return;
      }
      final targetNode = node.argumentList.arguments.firstWhereOrNull(
        (item) =>
            item.correspondingParameter?.name == parameterName ||
            _namedArgumentName(item) == parameterName,
      );
      if (targetNode == null) {
        return;
      }
      final list = _argumentExpression(targetNode);
      if (list is! ListLiteral) {
        return;
      }
      final listSource = list.toSource();
      for (final value in res) {
        final variableName = value.variableName;
        if (variableName != null &&
            listSource.contains("$variableName.loading")) {
          value.isShowIndicator = true;
        }
      }
      for (final element in list.elements) {
        final targetName = switch (element) {
          PropertyAccess(:final target) => target?.toString(),
          PrefixedIdentifier(:final prefix) => prefix.name,
          _ => null,
        };
        if (targetName != null) {
          indicatorVariables.add(targetName);
          res
              .firstWhereOrNull((value) => value.variableName == targetName)
              ?.isShowIndicator = true;
        }
      }
    });

    // すべての処理が終わった後
    context.addPostRunCallback(() {
      if (res.isEmpty) {
        return;
      }
      for (final node in res) {
        final variableName = node.variableName;
        final buildSource =
            node.node?.thisOrAncestorOfType<MethodDeclaration>()?.toSource();
        if (variableName != null &&
            buildSource != null &&
            (buildSource.contains("LoadingBuilder(") ||
                buildSource.contains("UniversalScaffold(")) &&
            buildSource.contains("$variableName.loading")) {
          node.isShowIndicator = true;
        }
        if (node.isShowIndicator ||
            indicatorVariables.contains(node.variableName) ||
            !node.isLoad) {
          continue;
        }
        reportAtNode(node.node!);
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
