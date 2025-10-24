part of "/katana_model.dart";

/// Types of vector value storage.
///
/// ベクトル値の保存タイプ。
enum VectorValueStoreType {
  /// Store as vector data.
  ///
  /// ベクトルデータとして保存。
  vectorValue,

  /// Store as index data.
  ///
  /// インデックスデータとして保存。
  indexValue;
}

/// A converter that passes data through without performing any conversion.
///
/// Throws an [UnsupportedError] if a conversion is attempted.
///
/// 変換を行わずにそのまま通過させるコンバーター。
///
/// 変換を行おうとした場合、[UnsupportedError]をスローします。
class PassVectorConverter extends VectorConverter {
  /// A converter that passes data through without performing any conversion.
  ///
  /// Throws an [UnsupportedError] if a conversion is attempted.
  ///
  /// 変換を行わずにそのまま通過させるコンバーター。
  ///
  /// 変換を行おうとした場合、[UnsupportedError]をスローします。
  const PassVectorConverter();

  @override
  VectorValueStoreType get storeType => VectorValueStoreType.vectorValue;

  @override
  FutureOr<List<double>> toVector(String value) {
    throw UnsupportedError(
      "PassVectorConverter does not support conversion.",
    );
  }

  @override
  Future<List<MapEntry<String, DynamicMap>>> sortByNearest(
    List<MapEntry<String, DynamicMap>> values,
    String key,
    String searchText,
  ) {
    throw UnsupportedError(
      "PassVectorConverter does not support sorting.",
    );
  }

  @override
  FutureOr<int?> seekIndex(
    List<MapEntry<String, DynamicMap>> sorted,
    DynamicMap data,
    String key,
    String searchText,
  ) {
    throw UnsupportedError(
      "PassVectorConverter does not support seeking index.",
    );
  }
}

/// A converter for easy, runtime vector conversion.
///
/// It generates vectors using Bigram hash values and sorts them by proximity based on cosine similarity.
///
/// ランタイム上で簡易的にベクトル変換を行うコンバーター。
///
/// Bigramのハッシュ値を用いてベクトルを生成し、コサイン類似度に基づいて近い順に並び替えを行います。
class RuntimeVectorConverter extends SyncedVectorConverter {
  /// A converter for easy, runtime vector conversion.
  ///
  /// It generates vectors using Bigram hash values and sorts them by proximity based on cosine similarity.
  ///
  /// ランタイム上で簡易的にベクトル変換を行うコンバーター。
  ///
  /// Bigramのハッシュ値を用いてベクトルを生成し、コサイン類似度に基づいて近い順に並び替えを行います。
  const RuntimeVectorConverter({
    this.dimensions = 10000000,
  });

  /// Vector dimension.
  ///
  /// ベクトルの次元数。
  final int dimensions;

  @override
  VectorValueStoreType get storeType => VectorValueStoreType.indexValue;

  @override
  List<double> toVector(String value) {
    final indexes = <double>[];
    final ngrams = value
        .toLowerCase()
        .toHankakuNumericAndAlphabet()
        .toZenkakuKatakana()
        .toKatakana()
        .removeOnlyEmoji()
        .toFirestoreMapKey()
        .splitByCharacterAndBigram()
        .distinct();
    for (final ngram in ngrams) {
      final index = _getConsistentHashCode(ngram) % dimensions;
      indexes.add(index.toDouble());
    }
    return indexes;
  }

  @override
  Future<List<MapEntry<String, DynamicMap>>> sortByNearest(
    List<MapEntry<String, DynamicMap>> values,
    String key,
    String searchText,
  ) async {
    final queryVector = toVector(searchText);
    final entries = <MapEntry<String, DynamicMap>>[];
    for (final entry in values) {
      final vector = entry.value
          .getAsList<num>(key)
          .map(
            (e) => e.toDouble(),
          )
          .toList();
      entries.add(
        MapEntry(
          entry.key,
          {
            ...entry.value,
            distanceFieldKey: _sparseCosineSimilarity(vector, queryVector),
          },
        ),
      );
    }
    entries.sort((a, b) {
      final distanceA = a.value.getAsDouble(distanceFieldKey);
      final distanceB = b.value.getAsDouble(distanceFieldKey);
      return distanceB.compareTo(distanceA);
    });
    return entries;
  }

  @override
  FutureOr<int?> seekIndex(
    List<MapEntry<String, DynamicMap>> sorted,
    DynamicMap data,
    String key,
    String searchText,
  ) {
    final queryVector = toVector(searchText);
    final distance = _sparseCosineSimilarity(
      data.getAsList<num>(key).map((e) => e.toDouble()).toList(),
      queryVector,
    );
    for (var i = 0; i < sorted.length; i++) {
      final p = i - 1;
      if (i == 0) {
        if (sorted[i].value[key] == null) {
          continue;
        }
        final a = _sparseCosineSimilarity(
          sorted[i].value.getAsList<num>(key).map((e) => e.toDouble()).toList(),
          queryVector,
        );
        if (a <= distance) {
          return i;
        }
      } else {
        if (sorted[i].value[key] == null || sorted[p].value[key] == null) {
          continue;
        }
        final a = _sparseCosineSimilarity(
          sorted[i].value.getAsList<num>(key).map((e) => e.toDouble()).toList(),
          queryVector,
        );
        final b = _sparseCosineSimilarity(
          sorted[p].value.getAsList<num>(key).map((e) => e.toDouble()).toList(),
          queryVector,
        );
        if (a <= distance && b > distance) {
          return i;
        }
      }
    }
    return sorted.length;
  }

  int _getConsistentHashCode(String text) {
    var hash = 0;

    for (final rune in text.runes) {
      hash = (hash << 5) - hash + rune;
      hash = hash & 0xFFFFFFFF;
    }
    return hash.abs();
  }

  double _sparseCosineSimilarity(List<double> a, List<double> b) {
    final setA = a.map((e) => e.toInt()).toSet();
    final setB = b.map((e) => e.toInt()).toSet();

    final intersection = setA.intersection(setB).length;
    if (intersection == 0) {
      return 0.0;
    }

    final magnitudeA = sqrt(a.length);
    final magnitudeB = sqrt(b.length);

    // Jaccard係数とほぼ同じ計算式（コサイン類似度）
    return intersection / (magnitudeA * magnitudeB);
  }
}

/// A synchronous vector value converter.
///
/// 同期的なベクトル値のコンバーター。
abstract class SyncedVectorConverter extends VectorConverter {
  /// A synchronous vector value converter.
  ///
  /// 同期的なベクトル値のコンバーター。
  const SyncedVectorConverter();

  @override
  List<double> toVector(String value);
}

/// An asynchronous vector value converter.
///
/// 非同期的なベクトル値のコンバーター。
abstract class AsyncVectorConverter extends VectorConverter {
  /// An asynchronous vector value converter.
  ///
  /// 非同期的なベクトル値のコンバーター。
  const AsyncVectorConverter();

  @override
  Future<List<double>> toVector(String value);
}

/// A vector value converter.
///
/// Performs conversion from a string to a vector using [toVector]. Generative AI-based embedding generation, etc., can be performed here.
///
/// [storeType] specifies the vector storage type. If generative AI-based embedding generation is used, specify [VectorValueStoreType.vectorValue]. If a unique indexing logic is used, specify [VectorValueStoreType.indexValue].
///
/// [sortByNearest] implements logic to sort by proximity to a given vector. If generative AI-based embedding generation is used, sorting by proximity is performed using cosine similarity, etc.
////
/// ベクトル値のコンバーター。
///
/// [toVector]で文字列からベクトルへの変換を行います。ここで生成AIによるEmbedding生成などを行うことができます。
///
/// [storeType]ではベクトルの保存タイプを指定します。生成AIによるEmbedding生成を用いた場合には[VectorValueStoreType.vectorValue]を指定し、独自のインデックス生成ロジックを用いる場合には[VectorValueStoreType.indexValue]を指定します。
///
/// [sortByNearest]では、指定されたベクトルに近い順に並び替えるロジックを実装します。生成AIによるEmbedding生成を用いた場合にはコサイン類似度などを用いて近い順に並び替えを行います。
abstract class VectorConverter {
  /// A vector value converter.
  ///
  /// Performs conversion from a string to a vector using [toVector]. Generative AI-based embedding generation, etc., can be performed here.
  ///
  /// [storeType] specifies the vector storage type. If generative AI-based embedding generation is used, specify [VectorValueStoreType.vectorValue]. If a unique indexing logic is used, specify [VectorValueStoreType.indexValue].
  ///
  /// [sortByNearest] implements logic to sort by proximity to a given vector. If generative AI-based embedding generation is used, sorting by proximity is performed using cosine similarity, etc.
////
  /// ベクトル値のコンバーター。
  ///
  /// [toVector]で文字列からベクトルへの変換を行います。ここで生成AIによるEmbedding生成などを行うことができます。
  ///
  /// [storeType]ではベクトルの保存タイプを指定します。生成AIによるEmbedding生成を用いた場合には[VectorValueStoreType.vectorValue]を指定し、独自のインデックス生成ロジックを用いる場合には[VectorValueStoreType.indexValue]を指定します。
  ///
  /// [sortByNearest]では、指定されたベクトルに近い順に並び替えるロジックを実装します。生成AIによるEmbedding生成を用いた場合にはコサイン類似度などを用いて近い順に並び替えを行います。
  const VectorConverter();

  /// Field key for distance.
  ///
  /// 距離用のフィールドキー。
  String get distanceFieldKey => "@vectorDistance";

  /// Converts a string to a vector.
  ///
  /// Generative AI-based embedding generation, etc., can be performed here.
  ///
  /// 文字列からベクトルへの変換を行います。
  ///
  /// ここで生成AIによるEmbedding生成などを行うことができます。
  FutureOr<List<double>> toVector(String value);

  /// The vector storage type.
  ///
  /// ベクトルの保存タイプ。
  VectorValueStoreType get storeType;

  /// Sorts the data by proximity to the specified vector.
  ///
  /// [values] contains all the retrieved data. [key] is the field key where the vector data is stored. [searchText] is the text used as the sorting criterion.
  ///
  /// 指定されたベクトルに近い順に並び替えます。
  ///
  /// [values]には取得されたすべてのデータが渡されます。[key]にはベクトルデータが格納されているフィールドキーが渡されます。[searchText]には並び替えの基準となるテキストが渡されます。
  Future<List<MapEntry<String, DynamicMap>>> sortByNearest(
    List<MapEntry<String, DynamicMap>> values,
    String key,
    String searchText,
  );

  /// Finds the index of the data closest to the specified vector.
  ///
  /// [sorted] is the list of data sorted by proximity. [data] is the data to be searched. [key] is the field key where the vector data is stored. [searchText] is the text used as the search criterion.
  ///
  /// Returns the index of the closest data, or null if not found.
  ///
  /// 指定されたベクトルに最も近いデータのインデックスを探します。
  ///
  /// [sorted]は近い順に並び替えられたデータのリストです。[data]は検索対象のデータです。[key]にはベクトルデータが格納されているフィールドキーが渡されます。[searchText]には検索の基準となるテキストが渡されます。
  ///
  /// 最も近いデータのインデックスを返すか、見つからなかった場合はnullを返します。
  FutureOr<int?> seekIndex(
    List<MapEntry<String, DynamicMap>> sorted,
    DynamicMap data,
    String key,
    String searchText,
  );
}
