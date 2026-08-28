part of "/masamune_lints.dart";

class _MasamuneCollectionModelShouldAddLimitQuery
    extends _MasamuneAnalysisRule {
  _MasamuneCollectionModelShouldAddLimitQuery() : super(code);

  static const code = LintCode(
    "masamune_model_should_add_limit_query",
    "When querying in the collection model, [limitTo] must be used to limit the number of queries. Conversely, [limitTo] must not be specified when using [aggregate]. コレクションモデルでクエリする場合は[limitTo]で数の制限をする必要があります。[aggregate]を用いる場合は逆に[limitTo]を指定してはいけません。",
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  void run(_MasamuneRuleContext context) {
    final uses = <_CollectionQueryUse>[];
    final limitedVariables = <String>{};

    context.registry.addFunctionExpressionInvocation((node) {
      if (!_isInBuild(node)) {
        return;
      }
      final function = node.function;
      if (!_isCollectionQueryType(_expressionDeclaredType(function)) &&
          !_isCollectionQueryType(function.staticType)) {
        return;
      }
      final source = function.toSource();
      uses.add(
        _CollectionQueryUse(
          node: node,
          variableName: _rootIdentifier(function),
          hasLimit: _containsLimitQuery(source),
          isAggregate: source.contains(".aggregate("),
        ),
      );
    });

    context.registry.addMethodInvocation((node) {
      if (!_isInBuild(node)) {
        return;
      }
      final functionName = node.methodName.name;
      if (functionName == "limitTo" || functionName.endsWith("Query")) {
        final root = _rootIdentifier(node.target);
        if (root != null) {
          limitedVariables.add(root);
        }
      }

      // Analyzer 14 represents `query()` for a callable local variable as a
      // MethodInvocation rather than a FunctionExpressionInvocation.
      final declaredType = _elementType(node.methodName.element);
      if (node.target == null && _isCollectionQueryType(declaredType)) {
        uses.add(
          _CollectionQueryUse(
            node: node,
            variableName: node.methodName.name,
            hasLimit: false,
            isAggregate: false,
          ),
        );
      }
    });

    context.addPostRunCallback(() {
      for (final use in uses) {
        final hasLimit =
            use.hasLimit ||
            (use.variableName != null &&
                limitedVariables.contains(use.variableName));
        if ((use.isAggregate && hasLimit) || (!use.isAggregate && !hasLimit)) {
          reportAtNode(use.node);
        }
      }
    });
  }

  bool _isInBuild(AstNode node) =>
      node.thisOrAncestorOfType<MethodDeclaration>()?.name.lexeme == "build";

  bool _isCollectionQueryType(DartType? type) =>
      type is InterfaceType &&
      type.getDisplayString().endsWith("ModelCollectionQuery");

  DartType? _elementType(Element? element) => switch (element) {
    VariableElement(:final type) => type,
    GetterElement(:final returnType) => returnType,
    _ => null,
  };

  DartType? _expressionDeclaredType(
    Expression expression,
  ) => switch (expression) {
    SimpleIdentifier(:final element) => _elementType(element),
    PropertyAccess(:final propertyName) => _elementType(propertyName.element),
    PrefixedIdentifier(:final identifier) => _elementType(identifier.element),
    _ => null,
  };

  String? _rootIdentifier(AstNode? node) {
    var current = node;
    while (current != null) {
      switch (current) {
        case SimpleIdentifier(:final name):
          return name;
        case PrefixedIdentifier(:final prefix):
          current = prefix;
        case PropertyAccess(:final target):
          current = target;
        case MethodInvocation(:final target):
          current = target;
        default:
          return null;
      }
    }
    return null;
  }

  bool _containsLimitQuery(String source) {
    if (source.contains(".limitTo(")) {
      return true;
    }
    return RegExp(r"\.[A-Za-z0-9_]+Query\(").hasMatch(source);
  }
}

class _CollectionQueryUse {
  const _CollectionQueryUse({
    required this.node,
    required this.variableName,
    required this.hasLimit,
    required this.isAggregate,
  });

  final AstNode node;
  final String? variableName;
  final bool hasLimit;
  final bool isAggregate;
}
