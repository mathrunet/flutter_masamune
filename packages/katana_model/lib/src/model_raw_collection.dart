part of katana_model;

/// {@template model_raw_value_collection}
/// Data to be passed to [RuntimeModelAdapter].
///
/// Specify the path to the collection itself in [path] and the ID and value Map in [value].
///
/// You can parse for Json by using [toMap].
///
/// [RuntimeModelAdapter]に渡すデータ。
///
/// [path]にコレクション自体のパスを指定し、[value]にIDと値のMapを指定します。
///
/// [toMap]を利用することでJson用にパースすることができます。
/// {@endtemplate}
abstract class ModelRawCollection<T> {
  /// {@template model_raw_value_collection}
  /// Data to be passed to [RuntimeModelAdapter].
  ///
  /// Specify the path to the collection itself in [path] and the ID and value Map in [value].
  ///
  /// You can parse for Json by using [toMap].
  ///
  /// [RuntimeModelAdapter]に渡すデータ。
  ///
  /// [path]にコレクション自体のパスを指定し、[value]にIDと値のMapを指定します。
  ///
  /// [toMap]を利用することでJson用にパースすることができます。
  /// {@endtemplate}
  const ModelRawCollection(this.value);

  /// ID and value Map.
  ///
  /// IDと値のMap。
  final Map<String, T> value;

  /// Path to the collection itself.
  ///
  /// コレクション自体のパス。
  String get path;

  /// Parse for Json.
  ///
  /// Json用にパースする。
  Map<String, Map<String, dynamic>> toMap();

  @override
  String toString() {
    return value.toString();
  }
}

/// [ModelRawCollection] using [DynamicMap].
///
/// [DynamicMap]を利用した[ModelRawCollection]。
///
/// {@macro model_raw_value_collection}
class DynamicModelRawCollection extends ModelRawCollection<DynamicMap> {
  /// [ModelRawCollection] using [DynamicMap].
  ///
  /// [DynamicMap]を利用した[ModelRawCollection]。
  ///
  /// {@macro model_raw_value_collection}
  const DynamicModelRawCollection(this.path, super.value);

  @override
  final String path;

  @override
  Map<String, Map<String, dynamic>> toMap() {
    return value.map((key, value) => MapEntry("$path/$key", value));
  }
}
