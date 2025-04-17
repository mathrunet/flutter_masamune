part of '/katana_model.dart';

/// Define the field as an image URI.
///
/// The base value is given as [value]. An empty [Uri] is defined.
///
/// Use [ModelImageUri] if you want to be sure to define the image as an image URI.
///
/// フィールドを画像URIとして定義します。
///
/// ベースの値を[value]として与えます。空の[Uri]が定義されます。
///
/// 必ず画像URIとしての定義を行いたい場合は[ModelImageUri]を利用してください。
@immutable
class ModelImageUri extends ModelFieldValue<Uri>
    implements Comparable<ModelImageUri> {
  /// Define the field as an image URI.
  ///
  /// The base value is given as [value]. An empty [Uri] is defined.
  ///
  /// Use [ModelImageUri] if you want to be sure to define the image as an image URI.
  ///
  /// フィールドを画像URIとして定義します。
  ///
  /// ベースの値を[value]として与えます。空の[Uri]が定義されます。
  ///
  /// 必ず画像URIとしての定義を行いたい場合は[ModelImageUri]を利用してください。
  const factory ModelImageUri([Uri? value]) = _ModelImageUri;

  /// Define the field as an image URI.
  ///
  /// The base value is given as [value]. An empty [Uri] is defined.
  ///
  /// Use [ModelImageUri] if you want to be sure to define the image as an image URI.
  ///
  /// フィールドを画像URIとして定義します。
  ///
  /// ベースの値を[value]として与えます。空の[Uri]が定義されます。
  ///
  /// 必ず画像URIとしての定義を行いたい場合は[ModelImageUri]を利用してください。
  const factory ModelImageUri.parse([String? value]) = _ModelImageUriWithUri;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelImageUri.fromServer([Uri? value]) =
      _ModelImageUri.fromServer;

  /// Convert from [json] map to [ModelImageUri].
  ///
  /// [json]のマップから[ModelImageUri]に変換します。
  factory ModelImageUri.fromJson(DynamicMap json) {
    final uri = json.get(kUriKey, "");
    return ModelImageUri.fromServer(
      Uri.tryParse(uri),
    );
  }

  const ModelImageUri._([
    Uri? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelImageUri";

  /// Key to save time.
  ///
  /// 時間を保存しておくキー。
  static const kUriKey = "@uri";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  Uri get value => _value ?? Uri();
  final Uri? _value;

  final ModelFieldValueSource _source;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelImageUri.typeString,
        kUriKey: value.toString(),
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(ModelImageUri other) {
    return value.toString().compareTo(other.value.toString());
  }
}

@immutable
class _ModelImageUriWithUri extends _ModelImageUri {
  const _ModelImageUriWithUri([this._path]) : super();

  final String? _path;

  @override
  Uri? get _value {
    if (_path == null) {
      return null;
    }
    return Uri.parse(_path!);
  }
}

@immutable
class _ModelImageUri extends ModelImageUri with ModelFieldValueAsMapMixin<Uri> {
  const _ModelImageUri([
    super.value,
  ]) : super._();
  const _ModelImageUri.fromServer([Uri? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelImageUri] as [ModelFieldValue].
///
/// [ModelImageUri]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelImageUriConverter extends ModelFieldValueConverter<ModelImageUri> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelImageUri] as [ModelFieldValue].
  ///
  /// [ModelImageUri]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelImageUriConverter();

  @override
  String get type => ModelImageUri.typeString;

  @override
  ModelImageUri fromJson(Map<String, Object?> map) {
    return ModelImageUri.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelImageUri value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelImageUri] available to [ModelQuery.filters].
///
/// [ModelImageUri]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelImageUriFilter extends ModelFieldValueFilter<ModelImageUri> {
  /// Filter class to make [ModelImageUri] available to [ModelQuery.filters].
  ///
  /// [ModelImageUri]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelImageUriFilter();

  @override
  String get type => ModelImageUri.typeString;

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.toString().compareTo(b.toString()));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.lessThan:
      case ModelQueryFilterType.greaterThan:
      case ModelQueryFilterType.lessThanOrEqualTo:
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return null;
      case ModelQueryFilterType.arrayContains:
        if (source is List) {
          if (source.any((s) =>
              _hasMatch(s, target, (source, target) => source == target) ??
              false)) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.arrayContainsAny:
        if (source is List && target is List && target.isNotEmpty) {
          if (source.any((s) => target.any((t) =>
              _hasMatch(s, t, (source, target) => source == target) ??
              false))) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.whereIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return matches.any((element) => element);
          }
        }
        break;
      case ModelQueryFilterType.whereNotIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return !matches.any((element) => element);
          }
        }
        break;
      default:
        return null;
    }
    return null;
  }

  T? _hasMatch<T>(
    dynamic source,
    dynamic target,
    T Function(Uri source, Uri target) filter,
  ) {
    if (source is ModelImageUri && target is ModelImageUri) {
      return filter(source.value, target.value);
    } else if (source is ModelImageUri && target is Uri) {
      return filter(source.value, target);
    } else if (source is Uri && target is ModelImageUri) {
      return filter(source, target.value);
    } else if (source is ModelImageUri && target is String) {
      final uri = Uri.tryParse(target);
      if (uri == null) {
        return null;
      }
      return filter(source.value, uri);
    } else if (source is String && target is ModelImageUri) {
      final uri = Uri.tryParse(source);
      if (uri == null) {
        return null;
      }
      return filter(uri, target.value);
    } else if (source is ModelImageUri &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelImageUri.typeString) {
      return filter(source.value, ModelImageUri.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelImageUri &&
        source.get(kTypeFieldKey, "") == ModelImageUri.typeString) {
      return filter(ModelImageUri.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelImageUri.typeString &&
        target.get(kTypeFieldKey, "") == ModelImageUri.typeString) {
      return filter(ModelImageUri.fromJson(source).value,
          ModelImageUri.fromJson(target).value);
    }
    return null;
  }
}

/// Define the field as a video URI.
///
/// The base value is given as [value]. An empty [Uri] is defined.
///
/// Use [ModelVideoUri] if you want to be sure to define it as a video URI.
///
/// フィールドを映像URIとして定義します。
///
/// ベースの値を[value]として与えます。空の[Uri]が定義されます。
///
/// 必ず映像URIとしての定義を行いたい場合は[ModelVideoUri]を利用してください。
@immutable
class ModelVideoUri extends ModelFieldValue<Uri>
    implements Comparable<ModelVideoUri> {
  /// Define the field as a video URI.
  ///
  /// The base value is given as [value]. An empty [Uri] is defined.
  ///
  /// Use [ModelVideoUri] if you want to be sure to define it as a video URI.
  ///
  /// フィールドを映像URIとして定義します。
  ///
  /// ベースの値を[value]として与えます。空の[Uri]が定義されます。
  ///
  /// 必ず映像URIとしての定義を行いたい場合は[ModelVideoUri]を利用してください。
  const factory ModelVideoUri([Uri? value]) = _ModelVideoUri;

  /// Define the field as a video URI.
  ///
  /// The base value is given as [value]. An empty [Uri] is defined.
  ///
  /// Use [ModelVideoUri] if you want to be sure to define it as a video URI.
  ///
  /// フィールドを映像URIとして定義します。
  ///
  /// ベースの値を[value]として与えます。空の[Uri]が定義されます。
  ///
  /// 必ず映像URIとしての定義を行いたい場合は[ModelVideoUri]を利用してください。
  const factory ModelVideoUri.parse([String? value]) = _ModelVideoUriWithUri;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelVideoUri.fromServer([Uri? value]) =
      _ModelVideoUri.fromServer;

  /// Convert from [json] map to [ModelVideoUri].
  ///
  /// [json]のマップから[ModelVideoUri]に変換します。
  factory ModelVideoUri.fromJson(DynamicMap json) {
    final uri = json.get(kUriKey, "");
    return ModelVideoUri.fromServer(
      Uri.tryParse(uri),
    );
  }

  const ModelVideoUri._([
    Uri? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelVideoUri";

  /// Key to save time.
  ///
  /// 時間を保存しておくキー。
  static const kUriKey = "@uri";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  Uri get value => _value ?? Uri();
  final Uri? _value;

  final ModelFieldValueSource _source;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelVideoUri.typeString,
        kUriKey: value.toString(),
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(ModelVideoUri other) {
    return value.toString().compareTo(other.value.toString());
  }
}

@immutable
class _ModelVideoUriWithUri extends _ModelVideoUri {
  const _ModelVideoUriWithUri([this._path]) : super();

  final String? _path;

  @override
  Uri? get _value {
    if (_path == null) {
      return null;
    }
    return Uri.parse(_path!);
  }
}

@immutable
class _ModelVideoUri extends ModelVideoUri with ModelFieldValueAsMapMixin<Uri> {
  const _ModelVideoUri([
    super.value,
  ]) : super._();
  const _ModelVideoUri.fromServer([Uri? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelVideoUri] as [ModelFieldValue].
///
/// [ModelVideoUri]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelVideoUriConverter extends ModelFieldValueConverter<ModelVideoUri> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelVideoUri] as [ModelFieldValue].
  ///
  /// [ModelVideoUri]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelVideoUriConverter();

  @override
  String get type => ModelVideoUri.typeString;

  @override
  ModelVideoUri fromJson(Map<String, Object?> map) {
    return ModelVideoUri.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelVideoUri value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelVideoUri] available to [ModelQuery.filters].
///
/// [ModelVideoUri]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelVideoUriFilter extends ModelFieldValueFilter<ModelVideoUri> {
  /// Filter class to make [ModelVideoUri] available to [ModelQuery.filters].
  ///
  /// [ModelVideoUri]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelVideoUriFilter();

  @override
  String get type => ModelVideoUri.typeString;

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.toString().compareTo(b.toString()));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.lessThan:
      case ModelQueryFilterType.greaterThan:
      case ModelQueryFilterType.lessThanOrEqualTo:
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return null;
      case ModelQueryFilterType.arrayContains:
        if (source is List) {
          if (source.any((s) =>
              _hasMatch(s, target, (source, target) => source == target) ??
              false)) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.arrayContainsAny:
        if (source is List && target is List && target.isNotEmpty) {
          if (source.any((s) => target.any((t) =>
              _hasMatch(s, t, (source, target) => source == target) ??
              false))) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.whereIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return matches.any((element) => element);
          }
        }
        break;
      case ModelQueryFilterType.whereNotIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return !matches.any((element) => element);
          }
        }
        break;
      default:
        return null;
    }
    return null;
  }

  T? _hasMatch<T>(
    dynamic source,
    dynamic target,
    T Function(Uri source, Uri target) filter,
  ) {
    if (source is ModelVideoUri && target is ModelVideoUri) {
      return filter(source.value, target.value);
    } else if (source is ModelVideoUri && target is Uri) {
      return filter(source.value, target);
    } else if (source is Uri && target is ModelVideoUri) {
      return filter(source, target.value);
    } else if (source is ModelVideoUri && target is String) {
      final uri = Uri.tryParse(target);
      if (uri == null) {
        return null;
      }
      return filter(source.value, uri);
    } else if (source is String && target is ModelVideoUri) {
      final uri = Uri.tryParse(source);
      if (uri == null) {
        return null;
      }
      return filter(uri, target.value);
    } else if (source is ModelVideoUri &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelVideoUri.typeString) {
      return filter(source.value, ModelVideoUri.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelVideoUri &&
        source.get(kTypeFieldKey, "") == ModelVideoUri.typeString) {
      return filter(ModelVideoUri.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelVideoUri.typeString &&
        target.get(kTypeFieldKey, "") == ModelVideoUri.typeString) {
      return filter(ModelVideoUri.fromJson(source).value,
          ModelVideoUri.fromJson(target).value);
    }
    return null;
  }
}

/// Define the field as a URI.
///
/// The base value is given as [value]. An empty [Uri] is defined.
///
/// Use [ModelUri] if you want to be sure to define it as a URI.
///
/// フィールドをURIとして定義します。
///
/// ベースの値を[value]として与えます。空の[Uri]が定義されます。
///
/// 必ずURIとしての定義を行いたい場合は[ModelUri]を利用してください。
@immutable
class ModelUri extends ModelFieldValue<Uri> implements Comparable<ModelUri> {
  /// Define the field as a URI.
  ///
  /// The base value is given as [value]. An empty [Uri] is defined.
  ///
  /// Use [ModelUri] if you want to be sure to define it as a URI.
  ///
  /// フィールドをURIとして定義します。
  ///
  /// ベースの値を[value]として与えます。空の[Uri]が定義されます。
  ///
  /// 必ずURIとしての定義を行いたい場合は[ModelUri]を利用してください。
  const factory ModelUri([Uri? value]) = _ModelUri;

  /// Define the field as a URI.
  ///
  /// The base value is given as [value]. An empty [Uri] is defined.
  ///
  /// Use [ModelUri] if you want to be sure to define it as a URI.
  ///
  /// フィールドをURIとして定義します。
  ///
  /// ベースの値を[value]として与えます。空の[Uri]が定義されます。
  ///
  /// 必ずURIとしての定義を行いたい場合は[ModelUri]を利用してください。
  const factory ModelUri.parse([String? value]) = _ModelUriWithUri;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelUri.fromServer([Uri? value]) = _ModelUri.fromServer;

  /// Convert from [json] map to [ModelUri].
  ///
  /// [json]のマップから[ModelUri]に変換します。
  factory ModelUri.fromJson(DynamicMap json) {
    final uri = json.get(kUriKey, "");
    return ModelUri.fromServer(
      Uri.tryParse(uri),
    );
  }

  const ModelUri._([
    Uri? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelUri";

  /// Key to save time.
  ///
  /// 時間を保存しておくキー。
  static const kUriKey = "@uri";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  Uri get value => _value ?? Uri();
  final Uri? _value;

  final ModelFieldValueSource _source;

  /// Convert to [ModelImageUri].
  ///
  /// [ModelImageUri]に変換します。
  ModelImageUri toImageUri() {
    return ModelImageUri(value);
  }

  /// Convert to [ModelVideoUri].
  ///
  /// [ModelVideoUri]に変換します。

  ModelVideoUri toVideoUri() {
    return ModelVideoUri(value);
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelUri.typeString,
        kUriKey: value.toString(),
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(ModelUri other) {
    return value.toString().compareTo(other.value.toString());
  }
}

@immutable
class _ModelUriWithUri extends _ModelUri {
  const _ModelUriWithUri([this._path]) : super();

  final String? _path;

  @override
  Uri? get _value {
    if (_path == null) {
      return null;
    }
    return Uri.parse(_path!);
  }
}

@immutable
class _ModelUri extends ModelUri with ModelFieldValueAsMapMixin<Uri> {
  const _ModelUri([
    super.value,
  ]) : super._();
  const _ModelUri.fromServer([Uri? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelUri] as [ModelFieldValue].
///
/// [ModelUri]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelUriConverter extends ModelFieldValueConverter<ModelUri> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelUri] as [ModelFieldValue].
  ///
  /// [ModelUri]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelUriConverter();

  @override
  String get type => ModelUri.typeString;

  @override
  ModelUri fromJson(Map<String, Object?> map) {
    return ModelUri.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelUri value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelUri] available to [ModelQuery.filters].
///
/// [ModelUri]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelUriFilter extends ModelFieldValueFilter<ModelUri> {
  /// Filter class to make [ModelUri] available to [ModelQuery.filters].
  ///
  /// [ModelUri]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelUriFilter();

  @override
  String get type => ModelUri.typeString;

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.toString().compareTo(b.toString()));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.lessThan:
      case ModelQueryFilterType.greaterThan:
      case ModelQueryFilterType.lessThanOrEqualTo:
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return null;
      case ModelQueryFilterType.arrayContains:
        if (source is List) {
          if (source.any((s) =>
              _hasMatch(s, target, (source, target) => source == target) ??
              false)) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.arrayContainsAny:
        if (source is List && target is List && target.isNotEmpty) {
          if (source.any((s) => target.any((t) =>
              _hasMatch(s, t, (source, target) => source == target) ??
              false))) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.whereIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return matches.any((element) => element);
          }
        }
        break;
      case ModelQueryFilterType.whereNotIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return !matches.any((element) => element);
          }
        }
        break;
      default:
        return null;
    }
    return null;
  }

  T? _hasMatch<T>(
    dynamic source,
    dynamic target,
    T Function(Uri source, Uri target) filter,
  ) {
    if (source is ModelUri && target is ModelUri) {
      return filter(source.value, target.value);
    } else if (source is ModelUri && target is Uri) {
      return filter(source.value, target);
    } else if (source is Uri && target is ModelUri) {
      return filter(source, target.value);
    } else if (source is ModelUri && target is String) {
      final uri = Uri.tryParse(target);
      if (uri == null) {
        return null;
      }
      return filter(source.value, uri);
    } else if (source is String && target is ModelUri) {
      final uri = Uri.tryParse(source);
      if (uri == null) {
        return null;
      }
      return filter(uri, target.value);
    } else if (source is ModelUri &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelUri.typeString) {
      return filter(source.value, ModelUri.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelUri &&
        source.get(kTypeFieldKey, "") == ModelUri.typeString) {
      return filter(ModelUri.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelUri.typeString &&
        target.get(kTypeFieldKey, "") == ModelUri.typeString) {
      return filter(
          ModelUri.fromJson(source).value, ModelUri.fromJson(target).value);
    }
    return null;
  }
}
