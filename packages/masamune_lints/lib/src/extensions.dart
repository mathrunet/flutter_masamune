part of '/masamune_lints.dart';

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
