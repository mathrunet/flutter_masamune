part of katana;

/// Provides extended methods for [DynamicMap].
///
/// [DynamicMap]用の拡張メソッドを提供します。
extension DynamicMapExtensions on Map<String, dynamic> {
  /// Converts a [DynamicMap] with a key of [String] in the path structure to a [DynamicMap] in the tree structure.
  ///
  /// Keys are divided by `/` and assigned to keys in the respective tree structure.
  ///
  /// The `value` of [DynamicMap] is stored at the end of the node.
  ///
  /// [keyBuilder] can be specified to convert keys in each tree structure.
  ///
  /// If the folder name for each path is empty, that folder will be skipped.
  ///
  /// ```dart
  /// "/aaa//ccc" => "/aaa/ccc"
  /// ```
  ///
  /// パス構造の[String]のキーを持つ[DynamicMap]をツリー構造の[DynamicMap]に変換します。
  ///
  /// キーは`/`で分割され、それぞれのツリー構造のキーに割り当てられます。
  ///
  /// ノードの最後に[DynamicMap]の`value`が格納されます。
  ///
  /// [keyBuilder]を指定すると各ツリー構造のキーを変換することが可能です。
  ///
  /// 各パスのフォルダ名が空になった場合、そのフォルダはスキップされます。
  ///
  /// ```dart
  /// "/aaa//ccc" => "/aaa/ccc"
  /// ```
  /// 
  ///
  /// ```dart
  /// final test = {
  ///   "/aaa/bbb/ccc": "ccc",
  ///   "/aaa/ddd": "ddd",
  /// };
  /// final tree = test.toTreeMap();
  /// // {
  /// //   "aaa": {
  /// //     "bbb": {
  /// //       "ccc": "ccc",
  /// //     },
  /// //     "ddd": "ddd",
  /// //   },
  /// // },
  /// ```
  Map<String, dynamic> toTreeMap([String Function(String key)? keyBuilder]) {
    final converted = map((key, value) {
      return MapEntry(
        key
            .trimQuery()
            .trimString("/")
            .split("/")
            .map((k) => keyBuilder?.call(k) ?? k)
            .where((e) => e.isNotEmpty)
            .toList(),
        value,
      );
    });
    var res = <String, dynamic>{};
    for (final map in converted.entries) {
      res = _toTreeMap(res, map.key, map.value, 0);
    }
    return res;
  }

  static Map<String, dynamic> _toTreeMap(
    Map<String, dynamic> data,
    List<String> keys,
    dynamic value,
    int index,
  ) {
    if (keys.length <= index) {
      return data;
    }
    final key = keys[index];
    if (keys.length - 1 == index) {
      data[key] = value;
      return data;
    } else {
      if (data.containsKey(key)) {
        if (data[key] is! Map<String, dynamic>) {
          throw Exception(
            "${keys.join("/")} is trying to save to a path that already exists.",
          );
        }
        data[key] = _toTreeMap(
          data[key],
          keys,
          value,
          index + 1,
        );
        return data;
      } else {
        data[key] = _toTreeMap(
          {},
          keys,
          value,
          index + 1,
        );
        return data;
      }
    }
  }
}
