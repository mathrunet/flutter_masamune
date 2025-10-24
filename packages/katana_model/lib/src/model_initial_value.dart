part of "/katana_model.dart";

/// {@template model_initial_value}
/// Base class for data to be passed to various [ModelAdapter] `data`.
///
/// You can parse for Json by using [toMap].
///
/// 各種[ModelAdapter]の`data`に渡すデータの基底クラス。
///
/// [toMap]を利用することでJson用にパースすることができます。
/// {@endtemplate}
abstract class ModelInitialValue<T> {
  /// {@template model_initial_value}
  /// Base class for data to be passed to various [ModelAdapter] `data`.
  ///
  /// You can parse for Json by using [toMap].
  ///
  /// 各種[ModelAdapter]の`data`に渡すデータの基底クラス。
  ///
  /// [toMap]を利用することでJson用にパースすることができます。
  /// {@endtemplate}
  const ModelInitialValue();

  /// Path to the collection itself.
  ///
  /// コレクション自体のパス。
  String get path;

  /// Parse for Json.
  ///
  /// Json用にパースする。
  DynamicMap toMap(T value);

  /// Methods for filtering data as it is stored.
  ///
  /// Each element after being [toMap] and its corresponding [value] are passed to [rawData], so rewrite [rawData] and return it.
  ///
  /// Furthermore, the [adapter] is passed a [ModelAdapter] used for saving this data.
  ///
  /// データが保存される際にデータをフィルタリングするためのメソッド。
  ///
  /// [rawData]に[toMap]されたあとの各要素とそれに対応する[value]が渡されるので[rawData]を書き換えて返してください。
  ///
  /// また、[adapter]にはこのデータを保存する際に使用される[ModelAdapter]が渡されます。
  @mustCallSuper
  DynamicMap filterOnSave(DynamicMap rawData, T value, ModelAdapter adapter) {
    return rawData;
  }
}

/// {@template model_initial_document}
/// Data to be passed to `data` of various [ModelAdapter].
///
/// Specify the path of the document itself in [path] and a value in [value].
///
/// You can parse for Json by using [toMap].
///
/// 各種[ModelAdapter]の`data`に渡すデータ。
///
/// [path]にドキュメント自体のパスを指定し、[value]に値を指定します。
///
/// [toMap]を利用することでJson用にパースすることができます。
/// {@endtemplate}
abstract class ModelInitialDocument<T> extends ModelInitialValue<T> {
  /// {@template model_initial_document}
  /// Data to be passed to `data` of various [ModelAdapter].
  ///
  /// Specify the path of the document itself in [path] and a value in [value].
  ///
  /// You can parse for Json by using [toMap].
  ///
  /// 各種[ModelAdapter]の`data`に渡すデータ。
  ///
  /// [path]にドキュメント自体のパスを指定し、[value]に値を指定します。
  ///
  /// [toMap]を利用することでJson用にパースすることができます。
  /// {@endtemplate}
  const ModelInitialDocument(this.value);

  /// Initial value.
  ///
  /// 初期値。
  final T value;

  @override
  String toString() {
    return value.toString();
  }
}

/// {@template model_initial_collection}
/// Data to be passed to `data` of various [ModelAdapter].
///
/// Specify the path to the collection itself in [path] and the ID and value Map in [value].
///
/// You can parse for Json by using [toMap].
///
/// 各種[ModelAdapter]の`data`に渡すデータ。
///
/// [path]にコレクション自体のパスを指定し、[value]にIDと値のMapを指定します。
///
/// [toMap]を利用することでJson用にパースすることができます。
/// {@endtemplate}
abstract class ModelInitialCollection<T> extends ModelInitialValue<T> {
  /// {@template model_initial_collection}
  /// Data to be passed to `data` of various [ModelAdapter].
  ///
  /// Specify the path to the collection itself in [path] and the ID and value Map in [value].
  ///
  /// You can parse for Json by using [toMap].
  ///
  /// 各種[ModelAdapter]の`data`に渡すデータ。
  ///
  /// [path]にコレクション自体のパスを指定し、[value]にIDと値のMapを指定します。
  ///
  /// [toMap]を利用することでJson用にパースすることができます。
  /// {@endtemplate}
  const ModelInitialCollection(this.value);

  /// ID and value Map.
  ///
  /// IDと値のMap。
  final Map<String, T> value;

  @override
  String toString() {
    return value.toString();
  }
}

/// [ModelInitialDocument] using [DynamicMap].
///
/// [DynamicMap]を利用した[ModelInitialDocument]。
///
/// {@macro model_initial_document}
class DynamicModelInitialDocument extends ModelInitialDocument<DynamicMap> {
  /// [ModelInitialDocument] using [DynamicMap].
  ///
  /// [DynamicMap]を利用した[ModelInitialDocument]。
  ///
  /// {@macro model_initial_document}
  const DynamicModelInitialDocument(this.path, super.value);

  @override
  final String path;

  @override
  DynamicMap toMap(DynamicMap value) => value;
}

/// [ModelInitialCollection] using [DynamicMap].
///
/// [DynamicMap]を利用した[ModelInitialCollection]。
///
/// {@macro model_initial_collection}
class DynamicModelInitialCollection extends ModelInitialCollection<DynamicMap> {
  /// [ModelInitialCollection] using [DynamicMap].
  ///
  /// [DynamicMap]を利用した[ModelInitialCollection]。
  ///
  /// {@macro model_initial_collection}
  const DynamicModelInitialCollection(this.path, super.value);

  @override
  final String path;

  @override
  DynamicMap toMap(DynamicMap value) => value;
}
