part of "/masamune_lints.dart";

enum _MasamuneScopedType {
  any,
  app,
  page,
  widget;

  String get label {
    switch (this) {
      case _MasamuneScopedType.any:
        return "Any";
      case _MasamuneScopedType.app:
        return "App";
      case _MasamuneScopedType.page:
        return "Page";
      case _MasamuneScopedType.widget:
        return "Widget";
    }
  }
}

_MasamuneScopedType _getScopedQueryType(InterfaceType? type) {
  if (type == null) {
    return _MasamuneScopedType.any;
  }
  final typeString = type.toString();
  if (typeString.startsWith("AppScopedQuery<") ||
      typeString.startsWith("ChangeNotifierAppScopedQuery<")) {
    return _MasamuneScopedType.app;
  }
  if (typeString.startsWith("PageScopedQuery<") ||
      typeString.startsWith("ChangeNotifierPageScopedQuery<")) {
    return _MasamuneScopedType.page;
  }
  if (typeString.startsWith("WidgetScopedQuery<") ||
      typeString.startsWith("ChangeNotifierWidgetScopedQuery<")) {
    return _MasamuneScopedType.widget;
  }
  return _MasamuneScopedType.any;
}

_MasamuneScopedType _getRefType(InterfaceType? type) {
  if (type == null) {
    return _MasamuneScopedType.any;
  }
  final typeString = type.toString();
  if (typeString == "AppRef" || typeString == "AppScopedValueRef") {
    return _MasamuneScopedType.app;
  }
  if (typeString == "PageScopedValueRef") {
    return _MasamuneScopedType.page;
  }
  if (typeString == "WidgetScopedValueRef") {
    return _MasamuneScopedType.widget;
  }
  if (typeString.startsWith("QueryScopedValueRef<")) {
    final argType = type.typeArguments.firstOrNull;
    if (argType == null || argType is! InterfaceType) {
      return _MasamuneScopedType.any;
    }
    return _getRefType(argType);
  }
  return _MasamuneScopedType.any;
}

class _MasamuneScopedQueryMustPassToAppropriateRef extends DartLintRule {
  const _MasamuneScopedQueryMustPassToAppropriateRef() : super(code: _code);

  static const _code = lint_codes.LintCode(
    name: "masamune_scoped_query_must_pass_to_appropriate_ref",
    problemMessage:
        "ScopedQuery must be passed to the appropriate Ref. ScopedQueryは適切なRefに渡す必要があります。",
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // メソッドの実行時
    context.registry.addMethodInvocation((node) {
      final functionName = node.methodName.name;
      switch (functionName) {
        case "query":
          final targetType = node.target?.staticType as InterfaceType?;
          final argument = node.argumentList.arguments.firstOrNull;
          if (argument == null || targetType == null) {
            return;
          }
          final argumentType = (argument.staticType as InterfaceType?);
          if (argumentType == null) {
            return;
          }
          final scopedType = _getScopedQueryType(argumentType);
          if (scopedType == _MasamuneScopedType.any) {
            return;
          }
          final buildMethod = node.thisOrAncestorOfType<MethodDeclaration>();
          if (buildMethod != null && buildMethod.name.lexeme == "build") {
            final type = _getRefType(targetType);
            switch (type) {
              case _MasamuneScopedType.app:
                if (type != scopedType) {
                  reporter.atNode(
                    node,
                    lint_codes.LintCode(
                      name: _code.name,
                      problemMessage:
                          "${_code.problemMessage} Ref/${type.label} != ScopedQuery/${scopedType.label}",
                      errorSeverity: _code.errorSeverity,
                    ),
                  );
                }
                break;
              case _MasamuneScopedType.page:
                final scopedType = _getScopedQueryType(argumentType);
                if (scopedType == _MasamuneScopedType.any) {
                  return;
                }
                if (type != scopedType) {
                  reporter.atNode(
                    node,
                    lint_codes.LintCode(
                      name: _code.name,
                      problemMessage:
                          "${_code.problemMessage} Ref/${type.label} != ScopedQuery/${scopedType.label}",
                      errorSeverity: _code.errorSeverity,
                    ),
                  );
                }
                break;
              case _MasamuneScopedType.widget:
                final scopedType = _getScopedQueryType(argumentType);
                if (scopedType == _MasamuneScopedType.any) {
                  return;
                }
                if (type != scopedType) {
                  reporter.atNode(
                    node,
                    lint_codes.LintCode(
                      name: _code.name,
                      problemMessage:
                          "${_code.problemMessage} Ref/${type.label} != ScopedQuery/${scopedType.label}",
                      errorSeverity: _code.errorSeverity,
                    ),
                  );
                }
                break;
              default:
                break;
            }
            return;
          }
          final function =
              node.parent?.thisOrAncestorOfType<FunctionExpression>();
          if (function != null) {
            final ancestor = function.parent
                ?.thisOrAncestorOfType<InstanceCreationExpression>();
            if (ancestor == null) {
              return;
            }
            final elementType =
                function.parameters?.parameterElements.firstOrNull?.type;
            if (elementType == null || elementType is! InterfaceType) {
              return;
            }
            final type = _getRefType(elementType);
            if (type == _MasamuneScopedType.any) {
              return;
            }
            if (scopedType != type) {
              reporter.atNode(
                node,
                lint_codes.LintCode(
                  name: _code.name,
                  problemMessage:
                      "${_code.problemMessage} Ref/${type.label} != ScopedQuery/${type.label}",
                  errorSeverity: _code.errorSeverity,
                ),
              );
            }

            return;
          }
          break;
      }
    });
  }
}
