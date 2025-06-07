part of "/katana_model.dart";

/// Define commands to work with the server.
///
/// Basically, do not use it directly, but inherit it and define [command] to use it.
///
/// サーバーと連携するためのコマンドを定義します。
///
/// 基本的には直接利用せず継承して[command]を定義して利用してください。
@immutable
class ModelServerCommandBase extends ModelFieldValue<String>
    implements Comparable<ModelServerCommandBase> {
  /// Define commands to work with the server.
  ///
  /// Basically, do not use it directly, but inherit it and define [command] to use it.
  ///
  /// サーバーと連携するためのコマンドを定義します。
  ///
  /// 基本的には直接利用せず継承して[command]を定義して利用してください。
  const ModelServerCommandBase(
    String command, {
    DynamicMap publicParameters = const {},
    DynamicMap privateParameters = const {},
  })  : _command = command,
        _publicParameters = publicParameters,
        _privateParameters = privateParameters,
        _source = ModelFieldValueSource.user;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelServerCommandBase.fromServer(
    String command, {
    DynamicMap publicParameters,
    DynamicMap privateParameters,
  }) = _ModelServerCommandBase.fromServer;

  final String _command;

  /// Public parameters for the command.
  ///
  /// The values are copied to the document.
  ///
  /// コマンド用の公開パラメーター。
  ///
  /// ドキュメントに値がコピーされます。
  DynamicMap get publicParameters => _publicParameters;
  final DynamicMap _publicParameters;

  /// Private parameters for the command.
  ///
  /// コマンド用の非公開パラメーター。
  DynamicMap get privateParameters => _privateParameters;
  final DynamicMap _privateParameters;

  /// Convert from [json] map to [ModelServerCommandBase].
  ///
  /// [json]のマップから[ModelServerCommandBase]に変換します。
  factory ModelServerCommandBase.fromJson(DynamicMap json) {
    return ModelServerCommandBase.fromServer(
      json.get(kCommandKey, ""),
      publicParameters:
          _fromJsonForCondition(json.getAsMap(kPublicParametersKey, {})),
      privateParameters:
          _fromJsonForCondition(json.getAsMap(kPrivateParametersKey, {})),
    );
  }

  const ModelServerCommandBase._(
    String command,
    DynamicMap publicParameters,
    DynamicMap privateParameters, [
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _command = command,
        _publicParameters = publicParameters,
        _privateParameters = privateParameters,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelServerCommandBase";

  /// Command key.
  ///
  /// コマンドのキー。
  static const kCommandKey = "@command";

  /// Key for public parameters.
  ///
  /// 公開パラメーターのキー。
  static const kPublicParametersKey = "@public";

  /// Non-public parameter key.
  ///
  /// 非公開パラメーターのキー。
  static const kPrivateParametersKey = "@private";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  final ModelFieldValueSource _source;

  @override
  String get value => _command;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelServerCommandBase.typeString,
        kCommandKey: _command,
        kPublicParametersKey: _toJsonForCondition(publicParameters),
        kPrivateParametersKey: _toJsonForCondition(privateParameters),
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _command.hashCode;

  @override
  int compareTo(ModelServerCommandBase other) {
    return value.compareTo(other.value);
  }

  static DynamicMap _fromJsonForCondition(DynamicMap json) {
    final res = <String, Object?>{};
    for (final entry in json.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is List) {
        res[key] = value.mapAndRemoveEmpty((e) {
          if (e is Map) {
            return _fromJsonForCondition(
              e
                  .map((k, v) => MapEntry(k.toString(), v))
                  .cast<String, dynamic>(),
            );
          }
          return e;
        });
      } else if (value is Map) {
        final type = value.get(kTypeFieldKey, "");
        if (type == ModelServerCommandCondition.typeString) {
          res[key] = ModelServerCommandCondition.fromJson(
            value
                .map((k, v) => MapEntry(k.toString(), v))
                .cast<String, dynamic>(),
          );
        } else {
          res[key] = _fromJsonForCondition(
            value
                .map((k, v) => MapEntry(k.toString(), v))
                .cast<String, dynamic>(),
          );
        }
      } else {
        res[key] = value;
      }
    }
    return res;
  }

  static DynamicMap _toJsonForCondition(DynamicMap json) {
    final res = <String, Object?>{};
    for (final entry in json.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is List) {
        res[key] = value.mapAndRemoveEmpty((e) {
          if (e is Map) {
            return _fromJsonForCondition(
              e
                  .map((k, v) => MapEntry(k.toString(), v))
                  .cast<String, dynamic>(),
            );
          }
          return e;
        });
      } else if (value is Map) {
        res[key] = _toJsonForCondition(
          value
              .map((k, v) => MapEntry(k.toString(), v))
              .cast<String, dynamic>(),
        );
      } else if (value is ModelServerCommandCondition) {
        res[key] = value.toJson();
      } else {
        res[key] = value;
      }
    }
    return res;
  }
}

@immutable
class _ModelServerCommandBase extends ModelServerCommandBase
    with ModelFieldValueAsMapMixin<String> {
  const _ModelServerCommandBase(
    String command, {
    DynamicMap publicParameters = const {},
    DynamicMap privateParameters = const {},
    ModelFieldValueSource source = ModelFieldValueSource.user,
  }) : super._(command, publicParameters, privateParameters, source);
  const _ModelServerCommandBase.fromServer(
    String command, {
    DynamicMap publicParameters = const {},
    DynamicMap privateParameters = const {},
  }) : super._(command, publicParameters, privateParameters,
            ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelServerCommandBase] as [ModelFieldValue].
///
/// [ModelServerCommandBase]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelServerCommandBaseConverter
    extends ModelFieldValueConverter<ModelServerCommandBase> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelServerCommandBase] as [ModelFieldValue].
  ///
  /// [ModelServerCommandBase]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelServerCommandBaseConverter();

  @override
  String get type => ModelServerCommandBase.typeString;

  @override
  ModelServerCommandBase fromJson(Map<String, Object?> map) {
    return ModelServerCommandBase.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelServerCommandBase value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelServerCommandBase] available to [ModelQuery.filters].
///
/// [ModelServerCommandBase]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelServerCommandBaseFilter
    extends ModelFieldValueFilter<ModelServerCommandBase> {
  /// Filter class to make [ModelServerCommandBase] available to [ModelQuery.filters].
  ///
  /// [ModelServerCommandBase]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelServerCommandBaseFilter();

  @override
  String get type => ModelServerCommandBase.typeString;

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.compareTo(b));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
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
    T Function(String source, String target) filter,
  ) {
    if (source is ModelServerCommandBase && target is ModelServerCommandBase) {
      return filter(source.value, target.value);
    } else if (source is ModelServerCommandBase && target is String) {
      return filter(source.value, target);
    } else if (source is String && target is ModelServerCommandBase) {
      return filter(source, target.value);
    } else if (source is ModelServerCommandBase &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelServerCommandBase.typeString) {
      return filter(
          source.value, ModelServerCommandBase.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelServerCommandBase &&
        source.get(kTypeFieldKey, "") == ModelServerCommandBase.typeString) {
      return filter(
          ModelServerCommandBase.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelServerCommandBase.typeString &&
        target.get(kTypeFieldKey, "") == ModelServerCommandBase.typeString) {
      return filter(ModelServerCommandBase.fromJson(source).value,
          ModelServerCommandBase.fromJson(target).value);
    }
    return null;
  }
}

/// Condition class used in [ModelServerCommandBase].
///
/// [ModelServerCommandBase]で用いる条件クラス。
@immutable
class ModelServerCommandCondition {
  /// Condition class used in [ModelServerCommandBase].
  ///
  /// [ModelServerCommandBase]で用いる条件クラス。
  const ModelServerCommandCondition({
    required this.key,
    this.type,
    this.value,
  });

  /// Convert from [json] map to [ModelServerCommandCondition].
  ///
  /// [json]のマップから[ModelServerCommandCondition]に変換します。
  factory ModelServerCommandCondition.fromJson(DynamicMap json) {
    return ModelServerCommandCondition(
      type: ModelQueryFilterType.values
              .firstWhereOrNull((e) => e.name == json.get(kTypeKey, "")) ??
          ModelQueryFilterType.equalTo,
      key: json.get(kKeyKey, ""),
      value: _fromJsonForValue(json[kValueKey]),
    );
  }

  /// Object type key.
  ///
  /// オブジェクトタイプのキー。
  static const typeString = "ModelServerCommandCondition";

  /// Type key.
  ///
  /// タイプのキー。
  static const kTypeKey = "type";

  /// Key key.
  ///
  /// キーのキー。
  static const kKeyKey = "key";

  /// Value key.
  ///
  /// 値のキー。
  static const kValueKey = "value";

  /// Condition type.
  ///
  /// 条件のタイプ。
  final ModelQueryFilterType? type;

  /// Key Terms.
  ///
  /// 条件のキー。
  final String key;

  /// Condition Value.
  ///
  /// 条件の値。
  final Object? value;

  /// Methods for Json serialization.
  ///
  /// Used to convert [ModelServerCommandCondition] values to Json in the json_serializable package.
  ///
  /// Jsonシリアライズを行うためのメソッド。
  ///
  /// json_serializableのパッケージで[ModelServerCommandCondition]の値をJsonに変換する際に利用します。
  DynamicMap toJson() => {
        kTypeFieldKey: ModelServerCommandCondition.typeString,
        kTypeKey: type?.name,
        kKeyKey: key,
        kValueKey: _toJsonForValue(value),
      };

  @override
  String toString() {
    return "Condition(${type?.name} $key:$value)";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => type.hashCode ^ key.hashCode ^ value.hashCode;

  static Object? _fromJsonForValue(Object? value) {
    if (value is Map) {
      final type = value.get(kTypeFieldKey, "");
      if (type == ModelServerCommandCondition.typeString) {
        return ModelServerCommandCondition.fromJson(
          value
              .map((k, v) => MapEntry(k.toString(), v))
              .cast<String, dynamic>(),
        );
      }
      return null;
    } else if (value is List) {
      return value.mapAndRemoveEmpty(_fromJsonForValue);
    }
    return value;
  }

  static Object? _toJsonForValue(Object? value) {
    if (value is Map) {
      return null;
    } else if (value is ModelServerCommandCondition) {
      return value.toJson();
    } else if (value is List) {
      return value.mapAndRemoveEmpty(_toJsonForValue);
    }
    return value;
  }
}

/// Field specification class used in [ModelServerCommandBase].
///
/// [ModelServerCommandBase]で用いるフィールド指定クラス。
@immutable
class ModelServerCommandField {
  /// Field specification class used in [ModelServerCommandBase].
  ///
  /// [ModelServerCommandBase]で用いるフィールド指定クラス。
  const ModelServerCommandField({
    required this.key,
    this.reference,
  });

  /// Convert from [json] map to [ModelServerCommandField].
  ///
  /// [json]のマップから[ModelServerCommandField]に変換します。
  factory ModelServerCommandField.fromJson(DynamicMap json) {
    return ModelServerCommandField(
      key: json.get(kKeyKey, ""),
      reference: _fromJsonForValue(json[kReferenceKey]),
    );
  }

  /// Object type key.
  ///
  /// オブジェクトタイプのキー。
  static const typeString = "ModelServerCommandField";

  /// Key key.
  ///
  /// キーのキー。
  static const kKeyKey = "key";

  /// Key for reference.
  ///
  /// リファレンス用のキー。
  static const kReferenceKey = "value";

  /// Key Terms.
  ///
  /// キーの名前。
  final String key;

  /// [ModelServerCommandField] for reference.
  ///
  /// リファレンス用の[ModelServerCommandField]。
  final ModelServerCommandField? reference;

  /// Methods for Json serialization.
  ///
  /// Used to convert [ModelServerCommandField] values to Json in the json_serializable package.
  ///
  /// Jsonシリアライズを行うためのメソッド。
  ///
  /// json_serializableのパッケージで[ModelServerCommandField]の値をJsonに変換する際に利用します。
  DynamicMap toJson() => {
        kTypeFieldKey: ModelServerCommandField.typeString,
        kKeyKey: key,
        kReferenceKey: reference?.toJson(),
      };

  @override
  String toString() {
    return "Field(key: $key, ref: $reference)";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => key.hashCode ^ reference.hashCode;

  static ModelServerCommandField? _fromJsonForValue(Object? value) {
    if (value is Map) {
      final type = value.get(kTypeFieldKey, "");
      if (type == ModelServerCommandField.typeString) {
        return ModelServerCommandField.fromJson(
          value
              .map((k, v) => MapEntry(k.toString(), v))
              .cast<String, dynamic>(),
        );
      }
      return null;
    }
    return null;
  }
}
