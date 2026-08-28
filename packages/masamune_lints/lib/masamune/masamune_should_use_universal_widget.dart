part of "/masamune_lints.dart";

class _MasamuneShouldUseUniversalWidget extends _MasamuneAnalysisRule {
  _MasamuneShouldUseUniversalWidget() : super(code);

  static const code = LintCode(
    "masamune_should_use_universal_widget",
    "Consider using {0} instead of {1}. {2}",
    severity: DiagnosticSeverity.WARNING,
  );

  static const Map<String, String> _widgetSuggestions = {
    "AppBar": "UniversalAppBar",
    "Scaffold": "UniversalScaffold",
  };
  static const Map<String, String> _widgetOnlyTopLevelSuggestions = {
    "Container": "UniversalContainer",
    "Padding": "UniversalPadding",
    "Column": "UniversalColumn",
    "ListView": "UniversalListView",
    "GridView": "UniversalGridView",
  };

  @override
  void run(_MasamuneRuleContext context) {
    context.registry.addInstanceCreationExpression((node) {
      final constructorName = node.constructorName;
      final typeName = constructorName.type.name.lexeme;

      if (_widgetSuggestions.containsKey(typeName)) {
        final suggestedWidget = _widgetSuggestions[typeName]!;

        reportAtNode(
          node,
          arguments: [
            suggestedWidget,
            typeName,
            "$suggestedWidgetはUniversalUIの一部でより多くの機能を提供します。",
          ],
        );
      } else if (_widgetOnlyTopLevelSuggestions.containsKey(typeName)) {
        if (_shouldUseUniversalContainer(node)) {
          final suggestedWidget = _widgetOnlyTopLevelSuggestions[typeName]!;

          reportAtNode(
            node,
            arguments: [
              suggestedWidget,
              typeName,
              "$suggestedWidgetはUniversalUIの一部でより多くの機能を提供します。",
            ],
          );
        }
      }
    });

    // メソッド呼び出しでのファクトリーコンストラクタも監視
    context.registry.addMethodInvocation((node) {
      if (node.target == null && node.staticType is InterfaceType) {
        final typeName = node.staticType!.getDisplayString().split("<").first;
        final suggestedWidget = _widgetSuggestions[typeName];
        if (suggestedWidget != null) {
          reportAtNode(
            node,
            arguments: [
              suggestedWidget,
              typeName,
              "$suggestedWidgetはUniversalUIの一部でより多くの機能を提供します。",
            ],
          );
          return;
        }
        final topLevelSuggestion = _widgetOnlyTopLevelSuggestions[typeName];
        if (topLevelSuggestion != null && _shouldUseUniversalContainer(node)) {
          reportAtNode(
            node,
            arguments: [
              topLevelSuggestion,
              typeName,
              "$topLevelSuggestionはUniversalUIの一部でより多くの機能を提供します。",
            ],
          );
          return;
        }
      }
      final targetType = node.target?.staticType?.getDisplayString();
      final methodName = node.methodName.name;

      // ListView.builder(), GridView.count() などのファクトリーコンストラクタを検出
      if (targetType != null && _widgetSuggestions.containsKey(targetType)) {
        final suggestedWidget = _widgetSuggestions[targetType]!;

        reportAtNode(
          node,
          arguments: [
            "$suggestedWidget.$methodName",
            "$targetType.$methodName",
            "UniversalUIウィジェットの使用を検討してください。",
          ],
        );
      }
    });
  }

  /// Containerに対してUniversalContainerを推奨すべきかどうかを判定する
  bool _shouldUseUniversalContainer(AstNode node) {
    return _isInPageScopedWidgetBuild(node) || _isInUniversalScaffoldBody(node);
  }

  /// PageScopedWidgetのbuildメソッドの戻り値として直接返されているかどうかを判定する
  bool _isInPageScopedWidgetBuild(AstNode node) {
    final parent = node.parent;

    // return Container(); のように直接返されている場合
    if (parent is ReturnStatement) {
      final method = _findParentMethod(parent);
      if (method != null && method.name.lexeme == "build") {
        final classDeclaration = _findParentClass(method);
        if (classDeclaration != null &&
            _extendsPageScopedWidget(classDeclaration)) {
          return true;
        }
      }
    }

    // Widget build(BuildContext context) => Container(); のような場合
    // ここは必要なし
    // if (parent is ExpressionFunctionBody) {
    //   final method = _findParentMethod(parent);
    //   if (method != null && method.name.lexeme == "build") {
    //     final classDeclaration = _findParentClass(method);
    //     if (classDeclaration != null &&
    //         _extendsPageScopedWidget(classDeclaration)) {
    //       return true;
    //     }
    //   }
    // }

    return false;
  }

  /// UniversalScaffoldのbodyプロパティ直下かどうかを判定する
  bool _isInUniversalScaffoldBody(AstNode node) {
    final parent = node.parent;

    // body: Container() のように直接指定されている場合
    if (parent != null && _namedArgumentName(parent) == "body") {
      // bodyプロパティの親がUniversalScaffoldのコンストラクタかチェック
      final argumentList = parent.parent;
      if (argumentList is ArgumentList) {
        final constructor = argumentList.parent;
        final typeName = _constructorTypeName(constructor);
        if (typeName != null) {
          return typeName == "UniversalScaffold" || typeName == "Scaffold";
        }
      }
      return true;
    }

    // body: () => Container() のようにクロージャー内で返されている場合も直下とみなす
    if (parent is ExpressionFunctionBody) {
      final function = parent.parent;
      if (function is FunctionExpression) {
        final namedExpression = function.parent;
        if (namedExpression != null &&
            _namedArgumentName(namedExpression) == "body") {
          final argumentList = namedExpression.parent;
          if (argumentList is ArgumentList) {
            final constructor = argumentList.parent;
            final typeName = _constructorTypeName(constructor);
            if (typeName != null) {
              return typeName == "UniversalScaffold" || typeName == "Scaffold";
            }
          }
          return true;
        }
      }
    }

    // body: () { return Container(); } のようにブロック内で返されている場合も直下とみなす
    if (parent is ReturnStatement) {
      final block = parent.parent;
      if (block is Block) {
        final function = block.parent;
        if (function is BlockFunctionBody) {
          final functionExpression = function.parent;
          if (functionExpression is FunctionExpression) {
            final namedExpression = functionExpression.parent;
            if (namedExpression != null &&
                _namedArgumentName(namedExpression) == "body") {
              final argumentList = namedExpression.parent;
              if (argumentList is ArgumentList) {
                final constructor = argumentList.parent;
                final typeName = _constructorTypeName(constructor);
                if (typeName != null) {
                  return typeName == "UniversalScaffold" ||
                      typeName == "Scaffold";
                }
              }
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  String? _constructorTypeName(AstNode? node) => switch (node) {
    InstanceCreationExpression(:final constructorName) =>
      constructorName.type.name.lexeme,
    MethodInvocation(:final staticType) when staticType is InterfaceType =>
      staticType.getDisplayString().split("<").first,
    _ => null,
  };

  /// 親メソッドを取得する
  MethodDeclaration? _findParentMethod(AstNode node) {
    AstNode? current = node.parent;
    while (current != null) {
      if (current is MethodDeclaration) {
        return current;
      }
      current = current.parent;
    }
    return null;
  }

  /// 親クラスを取得する
  ClassDeclaration? _findParentClass(AstNode node) {
    AstNode? current = node.parent;
    while (current != null) {
      if (current is ClassDeclaration) {
        return current;
      }
      current = current.parent;
    }
    return null;
  }

  /// PageScopedWidgetを継承しているかどうかを判定する
  bool _extendsPageScopedWidget(ClassDeclaration classDeclaration) {
    final extendsClause = classDeclaration.extendsClause;
    if (extendsClause != null) {
      final superclassName = extendsClause.superclass.name.lexeme;
      return superclassName == "PageScopedWidget";
    }
    return false;
  }
}
