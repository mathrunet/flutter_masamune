part of "/katana.dart";

/// Provides Json extension methods for [DynamicList].
///
/// [DynamicList]用のJson拡張メソッドを提供します。
extension JsonDynamicListExtensions on DynamicList {
  /// Convert the contents of [DynamicList] to a Json [String].
  ///
  /// [DynamicList]の内容をJsonの[String]に変換します。
  String toJsonString() {
    return jsonEncode(this);
  }
}

/// Provides Json extension methods for [DynamicMap].
///
/// [DynamicMap]用のJson拡張メソッドを提供します。
extension JsonDynamicMapExtensions on DynamicMap {
  /// Convert the contents of [DynamicMap] to a Json [String].
  ///
  /// [DynamicMap]の内容をJsonの[String]に変換します。
  String toJsonString() {
    return jsonEncode(this);
  }
}
