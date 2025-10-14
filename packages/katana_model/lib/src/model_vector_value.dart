part of "/katana_model.dart";

/// Distance measure for vector similarity calculations.
///
/// ベクトル類似度計算の距離測定方法。
enum VectorDistanceMeasure {
  /// Cosine similarity (range: -1 to 1, higher is more similar).
  ///
  /// コサイン類似度(範囲: -1〜1、高いほど類似)。
  cosine,

  /// Euclidean distance (range: 0 to infinity, lower is more similar).
  ///
  /// ユークリッド距離(範囲: 0〜無限大、低いほど類似)。
  euclidean,

  /// Dot product (range: -infinity to infinity, higher is more similar).
  ///
  /// ドット積(範囲: -無限大〜無限大、高いほど類似)。
  dotProduct,
}

/// Value for storing vector embeddings in models.
///
/// モデル内でベクトル埋め込みを保存するための値。
@immutable
class VectorValue implements Comparable<VectorValue> {
  /// Value for storing vector embeddings in models.
  ///
  /// モデル内でベクトル埋め込みを保存するための値。
  const VectorValue({
    required this.vector,
    this.measure = VectorDistanceMeasure.cosine,
  });

  /// Create a [VectorValue] from a list of numbers.
  ///
  /// 数値のリストから[VectorValue]を作成します。
  factory VectorValue.fromList(
    List<num> list, {
    VectorDistanceMeasure measure = VectorDistanceMeasure.cosine,
  }) {
    return VectorValue(
      vector: list.map((e) => e.toDouble()).toList(),
      measure: measure,
    );
  }

  /// The vector data.
  ///
  /// ベクトルデータ。
  final List<double> vector;

  /// The distance measure.
  ///
  /// 距離測定方法。
  final VectorDistanceMeasure measure;

  /// Calculate cosine similarity with another vector.
  ///
  /// Returns a value between -1 and 1, where 1 means identical direction.
  ///
  /// 他のベクトルとのコサイン類似度を計算します。
  ///
  /// -1から1の間の値を返し、1は同じ方向を意味します。
  double cosineSimilarity(VectorValue other) {
    if (vector.length != other.vector.length) {
      throw ArgumentError(
        "Vector dimensions must match: ${vector.length} != ${other.vector.length}",
      );
    }

    var dotProduct = 0.0;
    var magnitudeA = 0.0;
    var magnitudeB = 0.0;

    for (var i = 0; i < vector.length; i++) {
      dotProduct += vector[i] * other.vector[i];
      magnitudeA += vector[i] * vector[i];
      magnitudeB += other.vector[i] * other.vector[i];
    }

    if (magnitudeA == 0.0 || magnitudeB == 0.0) {
      return 0.0;
    }

    return dotProduct / (sqrt(magnitudeA) * sqrt(magnitudeB));
  }

  /// Calculate Euclidean distance with another vector.
  ///
  /// Returns a value >= 0, where 0 means identical vectors.
  ///
  /// 他のベクトルとのユークリッド距離を計算します。
  ///
  /// 0以上の値を返し、0は同じベクトルを意味します。
  double euclideanDistance(VectorValue other) {
    if (vector.length != other.vector.length) {
      throw ArgumentError(
        "Vector dimensions must match: ${vector.length} != ${other.vector.length}",
      );
    }

    var sum = 0.0;
    for (var i = 0; i < vector.length; i++) {
      final diff = vector[i] - other.vector[i];
      sum += diff * diff;
    }

    return sqrt(sum);
  }

  /// Calculate dot product with another vector.
  ///
  /// 他のベクトルとのドット積を計算します。
  double dotProduct(VectorValue other) {
    if (vector.length != other.vector.length) {
      throw ArgumentError(
        "Vector dimensions must match: ${vector.length} != ${other.vector.length}",
      );
    }

    var sum = 0.0;
    for (var i = 0; i < vector.length; i++) {
      sum += vector[i] * other.vector[i];
    }

    return sum;
  }

  /// Calculate similarity with another vector using the specified measure.
  ///
  /// For cosine and dot product, higher values indicate more similarity.
  /// For euclidean distance, lower values indicate more similarity.
  ///
  /// 指定された測定方法で他のベクトルとの類似度を計算します。
  ///
  /// コサインとドット積では、高い値がより類似していることを示します。
  /// ユークリッド距離では、低い値がより類似していることを示します。
  double similarity(
    VectorValue other, {
    VectorDistanceMeasure measure = VectorDistanceMeasure.cosine,
  }) {
    switch (measure) {
      case VectorDistanceMeasure.cosine:
        return cosineSimilarity(other);
      case VectorDistanceMeasure.euclidean:
        return -euclideanDistance(other); // Negate so higher is better
      case VectorDistanceMeasure.dotProduct:
        return dotProduct(other);
    }
  }

  @override
  int compareTo(VectorValue other) {
    // Compare by vector length first, then by first element
    if (vector.length != other.vector.length) {
      return vector.length.compareTo(other.vector.length);
    }
    if (vector.isEmpty) {
      return 0;
    }
    return vector.first.compareTo(other.vector.first);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! VectorValue) {
      return false;
    }
    if (vector.length != other.vector.length) {
      return false;
    }
    for (var i = 0; i < vector.length; i++) {
      if (vector[i] != other.vector[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(vector);

  @override
  String toString() => "VectorValue(${vector.length}D, $measure)";
}

/// [ModelFieldValue] for storing vector embeddings.
///
/// ベクトル埋め込みを保存するための[ModelFieldValue]。
@immutable
class ModelVectorValue extends ModelFieldValue<VectorValue>
    implements Comparable<ModelVectorValue> {
  /// [ModelFieldValue] for storing vector embeddings.
  ///
  /// ベクトル埋め込みを保存するための[ModelFieldValue]。
  const factory ModelVectorValue([VectorValue? value]) = _ModelVectorValue;

  /// [ModelFieldValue] for storing vector embeddings.
  ///
  /// ベクトル埋め込みを保存するための[ModelFieldValue]。
  const factory ModelVectorValue.fromList(List<double> list) =
      _ModelVectorValueFromList;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelVectorValue.fromServer([VectorValue? value]) =
      _ModelVectorValue.fromServer;

  /// Convert from [json] map to [ModelVectorValue].
  ///
  /// [json]のマップから[ModelVectorValue]に変換します。
  factory ModelVectorValue.fromJson(DynamicMap json) {
    final vector = json.getAsList(kVectorKey).whereType<num>().toList();
    final measureValue = VectorDistanceMeasure.values.firstWhereOrNull(
      (e) =>
          e.name ==
          json.get(
            kDefaultMeasureKey,
            VectorDistanceMeasure.cosine.name,
          ),
    );
    if (vector.isEmpty) {
      return const ModelVectorValue.fromServer();
    }
    return ModelVectorValue.fromServer(
      VectorValue.fromList(
        vector,
        measure: measureValue ?? VectorDistanceMeasure.cosine,
      ),
    );
  }

  const ModelVectorValue._([
    VectorValue? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelVectorValue";

  /// Key to save vector data.
  ///
  /// ベクトルデータを保存しておくキー。
  static const kVectorKey = "@vector";

  /// Key to save the default measure.
  ///
  /// デフォルトの距離測定方法を保存しておくキー。
  static const kDefaultMeasureKey = "@measure";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  VectorValue get value => _value ?? const VectorValue(vector: []);
  final VectorValue? _value;

  final ModelFieldValueSource _source;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelVectorValue.typeString,
        kVectorKey: value.vector,
        kDefaultMeasureKey: value.measure.name,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(ModelVectorValue other) {
    return value.compareTo(other.value);
  }
}

@immutable
class _ModelVectorValue extends ModelVectorValue
    with ModelFieldValueAsMapMixin<VectorValue> {
  const _ModelVectorValue([
    super.value,
  ]) : super._();
  const _ModelVectorValue.fromServer([VectorValue? value])
      : super._(value, ModelFieldValueSource.server);
}

@immutable
class _ModelVectorValueFromList extends _ModelVectorValue
    with ModelFieldValueAsMapMixin<VectorValue> {
  const _ModelVectorValueFromList(this._vector) : super();

  @override
  VectorValue get value => VectorValue(vector: _vector);

  final List<double> _vector;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => VectorValue(vector: _vector).hashCode;
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelVectorValue] as [ModelFieldValue].
///
/// [ModelVectorValue]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelVectorValueConverter
    extends ModelFieldValueConverter<ModelVectorValue> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelVectorValue] as [ModelFieldValue].
  ///
  /// [ModelVectorValue]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelVectorValueConverter();

  @override
  String get type => ModelVectorValue.typeString;

  @override
  ModelVectorValue fromJson(Map<String, Object?> map) {
    return ModelVectorValue.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelVectorValue value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelVectorValue] available to [ModelQuery.filters].
///
/// [ModelVectorValue]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelVectorValueFilter extends ModelFieldValueFilter<ModelVectorValue> {
  /// Filter class to make [ModelVectorValue] available to [ModelQuery.filters].
  ///
  /// [ModelVectorValue]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelVectorValueFilter();

  @override
  int? compare(dynamic a, dynamic b) {
    if (a is ModelVectorValue && b is ModelVectorValue) {
      return a.compareTo(b);
    }
    if (a == null && b == null) {
      return 0;
    }
    if (a == null) {
      return -1;
    }
    if (b == null) {
      return 1;
    }
    return null;
  }

  @override
  String get type => ModelVectorValue.typeString;

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.isNull:
        return source == null;
      case ModelQueryFilterType.isNotNull:
        return source != null;
      default:
        return null;
    }
  }

  bool? _hasMatch(
    dynamic source,
    dynamic target,
    bool Function(ModelVectorValue source, ModelVectorValue target) callback,
  ) {
    if (source is ModelVectorValue && target is ModelVectorValue) {
      return callback(source, target);
    }
    return null;
  }
}
