part of "/masamune_lints.dart";

class _MasamuneShouldUseUniversalWidget extends DartLintRule {
  const _MasamuneShouldUseUniversalWidget()
      : super(
          code: _code,
        );

  static const _code = lint_codes.LintCode(
    name: "masamune_should_use_universal_widget",
    problemMessage:
        """The Masamune framework recommends using UniversalUI instead of Widgets such as Scaffold and ListView. MasamuneフレームワークではScaffoldやListViewなどのWidgetの代わりにUniversalUIを利用することを推奨しています。
下記の変換を行ってください。

- Scaffold -> UniversalScaffold
- ListView -> UniversalListView
- GridView -> UniversalGridView
- AppBar -> UniversalAppBar
- Container -> UniversalContainer
- Padding -> UniversalPadding
- Column -> UniversalColumn
""",
    errorSeverity: ErrorSeverity.WARNING,
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
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final constructorName = node.constructorName;
      final typeName = constructorName.type.name2.lexeme;

      if (_widgetSuggestions.containsKey(typeName)) {
        final suggestedWidget = _widgetSuggestions[typeName]!;

        final customCode = lint_codes.LintCode(
          name: "masamune_should_use_universal_widget",
          problemMessage:
              "Consider using $suggestedWidget instead of $typeName. $suggestedWidgetはUniversalUIの一部でより多くの機能を提供します。",
          errorSeverity: ErrorSeverity.WARNING,
        );

        reporter.atNode(node, customCode);
      } else if (_widgetOnlyTopLevelSuggestions.containsKey(typeName)) {
        if (_shouldUseUniversalContainer(node)) {
          final suggestedWidget = _widgetOnlyTopLevelSuggestions[typeName]!;

          final customCode = lint_codes.LintCode(
            name: "masamune_should_use_universal_widget",
            problemMessage:
                "Consider using $suggestedWidget instead of $typeName. $suggestedWidgetはUniversalUIの一部でより多くの機能を提供します。",
            errorSeverity: ErrorSeverity.WARNING,
          );

          reporter.atNode(node, customCode);
        }
      }
    });

    // メソッド呼び出しでのファクトリーコンストラクタも監視
    context.registry.addMethodInvocation((node) {
      final targetType = node.target?.staticType?.getDisplayString();
      final methodName = node.methodName.name;

      // ListView.builder(), GridView.count() などのファクトリーコンストラクタを検出
      if (targetType != null && _widgetSuggestions.containsKey(targetType)) {
        final suggestedWidget = _widgetSuggestions[targetType]!;

        final customCode = lint_codes.LintCode(
          name: "masamune_should_use_universal_widget",
          problemMessage:
              "Consider using $suggestedWidget.$methodName instead of $targetType.$methodName. UniversalUIウィジェットの使用を検討してください。",
          errorSeverity: ErrorSeverity.WARNING,
        );

        reporter.atNode(node, customCode);
      }
    });
  }

  /// Containerに対してUniversalContainerを推奨すべきかどうかを判定する
  bool _shouldUseUniversalContainer(InstanceCreationExpression node) {
    return _isInPageScopedWidgetBuild(node) || _isInUniversalScaffoldBody(node);
  }

  /// PageScopedWidgetのbuildメソッドの戻り値として直接返されているかどうかを判定する
  bool _isInPageScopedWidgetBuild(InstanceCreationExpression node) {
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
    if (parent is ExpressionFunctionBody) {
      final method = _findParentMethod(parent);
      if (method != null && method.name.lexeme == "build") {
        final classDeclaration = _findParentClass(method);
        if (classDeclaration != null &&
            _extendsPageScopedWidget(classDeclaration)) {
          return true;
        }
      }
    }

    return false;
  }

  /// UniversalScaffoldのbodyプロパティ直下かどうかを判定する
  bool _isInUniversalScaffoldBody(InstanceCreationExpression node) {
    final parent = node.parent;

    // body: Container() のように直接指定されている場合
    if (parent is NamedExpression && parent.name.label.name == "body") {
      // bodyプロパティの親がUniversalScaffoldのコンストラクタかチェック
      final argumentList = parent.parent;
      if (argumentList is ArgumentList) {
        final constructor = argumentList.parent;
        if (constructor is InstanceCreationExpression) {
          final typeName = constructor.constructorName.type.name2.lexeme;
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
        if (namedExpression is NamedExpression &&
            namedExpression.name.label.name == "body") {
          final argumentList = namedExpression.parent;
          if (argumentList is ArgumentList) {
            final constructor = argumentList.parent;
            if (constructor is InstanceCreationExpression) {
              final typeName = constructor.constructorName.type.name2.lexeme;
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
            if (namedExpression is NamedExpression &&
                namedExpression.name.label.name == "body") {
              final argumentList = namedExpression.parent;
              if (argumentList is ArgumentList) {
                final constructor = argumentList.parent;
                if (constructor is InstanceCreationExpression) {
                  final typeName =
                      constructor.constructorName.type.name2.lexeme;
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
      final superclassName = extendsClause.superclass.name2.lexeme;
      return superclassName == "PageScopedWidget";
    }
    return false;
  }
}
