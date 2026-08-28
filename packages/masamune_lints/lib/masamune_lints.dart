// Copyright (c) 2025 mathru. All rights reserved.

/// Package that defines lint rules necessary for use with the Masamune framework.
///
/// To use, import `package:masamune_lints/masamune_lints.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Package imports:
import "package:analysis_server_plugin/edit/dart/correction_producer.dart";
import "package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart";
import "package:analysis_server_plugin/plugin.dart";
import "package:analysis_server_plugin/registry.dart";
import "package:analyzer/analysis_rule/analysis_rule.dart";
import "package:analyzer/analysis_rule/rule_context.dart";
import "package:analyzer/analysis_rule/rule_visitor_registry.dart";
import "package:analyzer/dart/ast/ast.dart";
import "package:analyzer/dart/ast/token.dart";
import "package:analyzer/dart/ast/visitor.dart";
import "package:analyzer/dart/element/element.dart";
import "package:analyzer/dart/element/nullability_suffix.dart";
import "package:analyzer/dart/element/type.dart";
import "package:analyzer/error/error.dart";
import "package:analyzer/source/source_range.dart";
import "package:analyzer_plugin/utilities/assist/assist.dart";
import "package:analyzer_plugin/utilities/change_builder/change_builder_core.dart";
import "package:analyzer_plugin/utilities/fixes/fixes.dart";
import "package:analyzer_plugin/utilities/range_factory.dart";

part "masamune/masamune_model_should_show_indicator_while_loading.dart";
part "masamune/masamune_model_should_load.dart";
part "masamune/masamune_collection_model_should_add_limit_query.dart";
part "masamune/masamune_scoped_query_must_pass_to_appropriate_ref.dart";

part "buttons/masamune_button_add_icon.dart";
part "buttons/masamune_button_type.dart";
part "buttons/masamune_button_remove_icon.dart";
part "buttons/masamune_button_convert.dart";

part "common/masamune_limit_if_nesting.dart";
part "common/masamune_unwrap_nullable.dart";
part "common/masamune_caught_error_should_report.dart";
part "common/masamune_expected_error_should_have_unexpected_catch.dart";
part "masamune/masamune_should_use_universal_widget.dart";
part "masamune/masamune_should_use_form_widget.dart";

part "src/extensions.dart";

/// The official analysis server plugin implementation for Masamune.
class MasamuneLintsPlugin extends Plugin {
  @override
  String get name => "Masamune Lints";

  @override
  void register(PluginRegistry registry) {
    for (final rule in createMasamuneLintRules()) {
      registry.registerWarningRule(rule);
    }
    registry.registerFixForRule(
      _MasamuneCaughtErrorShouldReport.code,
      _MasamuneCaughtErrorShouldReportFix.new,
    );
    registry.registerAssist(_MasamuneButtonAddIcon.new);
    registry.registerAssist(_MasamuneButtonRemoveIcon.new);
    for (final buttonType in _MaterialButtonType.values) {
      registry.registerAssist(
        ({required context}) =>
            _MasamuneButtonConvert(context: context, targetType: buttonType),
      );
    }
  }
}

/// Creates the ten analysis rules exposed by this plugin.
///
/// This factory is public so that plugin consumers can use the official
/// `analyzer_testing` harness without relying on implementation imports.
List<AnalysisRule> createMasamuneLintRules() => [
      _MasamuneModelShouldLoad(),
      _MasamuneModelShouldShowIndicatorWhileLoading(),
      _MasamuneCollectionModelShouldAddLimitQuery(),
      _MasamuneScopedQueryMustPassToAppropriateRef(),
      _MasamuneShouldUseUniversalWidget(),
      _MasamuneShouldUseFormWidget(),
      _MasamuneLimitIfNesting(),
      _MasamuneUnwrapNullable(),
      _MasamuneCaughtErrorShouldReport(),
      _MasamuneExpectedErrorShouldHaveUnexpectedCatch(),
    ];

abstract class _MasamuneAnalysisRule extends AnalysisRule {
  _MasamuneAnalysisRule(this._code)
      : super(name: _code.lowerCaseName, description: _code.problemMessage);

  final LintCode _code;

  @override
  LintCode get diagnosticCode => _code;

  void run(_MasamuneRuleContext context);

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final callbacks = _MasamuneRuleRegistry();
    run(_MasamuneRuleContext(callbacks));
    callbacks.register(registry, this);
  }
}

class _MasamuneRuleContext {
  _MasamuneRuleContext(this.registry);

  final _MasamuneRuleRegistry registry;

  void addPostRunCallback(void Function() callback) {
    registry.postRunCallbacks.add(callback);
  }
}

class _MasamuneRuleRegistry {
  final catchClauseCallbacks = <void Function(CatchClause)>[];
  final functionExpressionInvocationCallbacks =
      <void Function(FunctionExpressionInvocation)>[];
  final ifStatementCallbacks = <void Function(IfStatement)>[];
  final instanceCreationExpressionCallbacks =
      <void Function(InstanceCreationExpression)>[];
  final methodInvocationCallbacks = <void Function(MethodInvocation)>[];
  final postfixExpressionCallbacks = <void Function(PostfixExpression)>[];
  final tryStatementCallbacks = <void Function(TryStatement)>[];
  final postRunCallbacks = <void Function()>[];

  void addCatchClause(void Function(CatchClause) callback) =>
      catchClauseCallbacks.add(callback);
  void addFunctionExpressionInvocation(
    void Function(FunctionExpressionInvocation) callback,
  ) =>
      functionExpressionInvocationCallbacks.add(callback);
  void addIfStatement(void Function(IfStatement) callback) =>
      ifStatementCallbacks.add(callback);
  void addInstanceCreationExpression(
    void Function(InstanceCreationExpression) callback,
  ) =>
      instanceCreationExpressionCallbacks.add(callback);
  void addMethodInvocation(void Function(MethodInvocation) callback) =>
      methodInvocationCallbacks.add(callback);
  void addPostfixExpression(void Function(PostfixExpression) callback) =>
      postfixExpressionCallbacks.add(callback);
  void addTryStatement(void Function(TryStatement) callback) =>
      tryStatementCallbacks.add(callback);

  void register(RuleVisitorRegistry registry, AnalysisRule rule) {
    final visitor = _MasamuneRuleVisitor(this);
    if (catchClauseCallbacks.isNotEmpty) {
      registry.addCatchClause(rule, visitor);
    }
    if (functionExpressionInvocationCallbacks.isNotEmpty) {
      registry.addFunctionExpressionInvocation(rule, visitor);
    }
    if (ifStatementCallbacks.isNotEmpty) {
      registry.addIfStatement(rule, visitor);
    }
    if (instanceCreationExpressionCallbacks.isNotEmpty) {
      registry.addInstanceCreationExpression(rule, visitor);
    }
    if (methodInvocationCallbacks.isNotEmpty) {
      registry.addMethodInvocation(rule, visitor);
    }
    if (postfixExpressionCallbacks.isNotEmpty) {
      registry.addPostfixExpression(rule, visitor);
    }
    if (tryStatementCallbacks.isNotEmpty) {
      registry.addTryStatement(rule, visitor);
    }
    if (postRunCallbacks.isNotEmpty) {
      registry.afterLibrary(rule, () {
        for (final callback in postRunCallbacks) {
          callback();
        }
      });
    }
  }
}

class _MasamuneRuleVisitor extends SimpleAstVisitor<void> {
  _MasamuneRuleVisitor(this.registry);

  final _MasamuneRuleRegistry registry;

  @override
  void visitCatchClause(CatchClause node) {
    for (final callback in registry.catchClauseCallbacks) {
      callback(node);
    }
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    for (final callback in registry.functionExpressionInvocationCallbacks) {
      callback(node);
    }
  }

  @override
  void visitIfStatement(IfStatement node) {
    for (final callback in registry.ifStatementCallbacks) {
      callback(node);
    }
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    for (final callback in registry.instanceCreationExpressionCallbacks) {
      callback(node);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    for (final callback in registry.methodInvocationCallbacks) {
      callback(node);
    }
  }

  @override
  void visitPostfixExpression(PostfixExpression node) {
    for (final callback in registry.postfixExpressionCallbacks) {
      callback(node);
    }
  }

  @override
  void visitTryStatement(TryStatement node) {
    for (final callback in registry.tryStatementCallbacks) {
      callback(node);
    }
  }
}

T? _firstOrNull<T>(Iterable<T> values) {
  final iterator = values.iterator;
  return iterator.moveNext() ? iterator.current : null;
}

extension _IterableExtensions<T> on Iterable<T> {
  T? get firstOrNull => _firstOrNull(this);

  T? firstWhereOrNull(bool Function(T) test) {
    for (final value in this) {
      if (test(value)) {
        return value;
      }
    }
    return null;
  }
}
