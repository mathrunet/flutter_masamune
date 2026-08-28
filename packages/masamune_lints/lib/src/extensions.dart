part of "/masamune_lints.dart";

/// Extension method of [MethodInvocation].
///
/// [MethodInvocation]の拡張メソッド。
extension MethodInvocationExtensions on MethodInvocation {
  /// If itself is [MethodInvocation] or [PropertyAccess], casts to [T] and returns if itself or [target] is [T].
  ///
  /// 自身が[MethodInvocation]か[PropertyAccess]の場合、自身か[target]が[T]の場合、[T]にキャストして返します。
  T? thisOrTargetOfType<T>() {
    AstNode? node = this;
    while (node != null) {
      if (node is T) {
        return node as T;
      } else if (node is MethodInvocation) {
        node = node.target;
      } else if (node is PropertyAccess) {
        node = node.target;
      } else {
        return null;
      }
    }
    return null;
  }
}

// `NamedExpression` was replaced by `NamedArgument` in analyzer 14. Keep all
// rule and correction code on the common AstNode surface so the same plugin
// source works with both analyzer generations used by Dart 3.10 and 3.13.
String? _namedArgumentName(AstNode argument) {
  final match = RegExp(
    r"^\s*([A-Za-z_$][\w$]*)\s*:",
  ).firstMatch(argument.toSource());
  return match?.group(1);
}

Expression? _argumentExpression(AstNode argument) {
  if (_namedArgumentName(argument) == null && argument is Expression) {
    return argument;
  }
  return argument.childEntities.whereType<Expression>().lastOrNull;
}

SourceRange? _namedArgumentNameRange(AstNode argument) {
  final name = _namedArgumentName(argument);
  if (name == null) {
    return null;
  }
  final relativeOffset = argument.toSource().indexOf(name);
  return SourceRange(argument.offset + relativeOffset, name.length);
}
