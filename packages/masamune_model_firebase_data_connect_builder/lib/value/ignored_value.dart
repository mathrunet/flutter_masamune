part of '/masamune_model_firebase_data_connect_builder.dart';

/// Name of the variable to exclude.
///
/// 除外する変数名。
enum IgnoredValue {
  /// uid.
  ///
  /// uid。
  uid;

  /// Get the label.
  ///
  /// ラベルを取得します。
  String get label {
    switch (this) {
      case IgnoredValue.uid:
        return "uid";
    }
  }

  /// Gets whether [value] is the value of the exclusion.
  ///
  /// [value]が除外の値かどうかを取得します。
  static bool contains(String value) {
    for (final item in IgnoredValue.values) {
      if (item.label == value) {
        return true;
      }
    }
    return false;
  }
}
