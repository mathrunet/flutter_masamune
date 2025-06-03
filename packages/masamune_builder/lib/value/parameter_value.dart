part of "/masamune_builder.dart";

const _searchParamChecker = TypeChecker.fromRuntime(SearchParam);
const _refParamChecker = TypeChecker.fromRuntime(RefParam);
const _jsonParamChecker = TypeChecker.fromRuntime(JsonParam);
const _jsonKeyChecker = TypeChecker.fromRuntime(JsonKey);
const _commentChecker = TypeChecker.fromRuntime(ParamComment);

/// Parameter Value.
///
/// Specify the parameter element in [element].
///
/// パラメーターの値。
///
/// [element]にパラメーターエレメントを指定します。
class ParamaterValue {
  /// Parameter Value.
  ///
  /// Specify the parameter element in [element].
  ///
  /// パラメーターの値。
  ///
  /// [element]にパラメーターエレメントを指定します。
  ParamaterValue(this.element) {
    name = element.displayName;
    type = element.type as InterfaceType;
    required = element.isRequired;
    isSearchable = _searchParamChecker.hasAnnotationOfExact(element);
    if (_refParamChecker.hasAnnotationOfExact(element)) {
      reference = _parseReferenceValue(element, type);
    } else {
      reference = null;
    }

    isJsonSerializable = _jsonParamChecker.hasAnnotationOfExact(element);
    if (isJsonSerializable) {
      jsonKey = _jsonParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("name")
              ?.toStringValue() ??
          _jsonKeyChecker
              .firstAnnotationOfExact(element)
              ?.getField("name")
              ?.toStringValue() ??
          name;
    } else {
      jsonKey = _jsonKeyChecker
              .firstAnnotationOfExact(element)
              ?.getField("name")
              ?.toStringValue() ??
          name;
    }

    comment = _commentChecker
        .firstAnnotationOfExact(element)
        ?.getField("comment")
        ?.toStringValue();

    deprecated = _deprecatedChecker
        .firstAnnotationOfExact(element)
        ?.getField("message")
        ?.toStringValue();
  }

  static final _adapterRegExp = RegExp(r"adapter\s*:\s*([^,\)]+),?");

  ReferenceValue? _parseReferenceValue(
      ParameterElement element, InterfaceType type) {
    String? referenceAdapter;
    for (final meta in element.metadata) {
      final source = meta.toSource();
      final adapterMatch = _adapterRegExp.firstMatch(source);
      if (adapterMatch != null) {
        final match = adapterMatch.group(1)?.trim().trimString(",").trim();
        if (match.isNotEmpty) {
          referenceAdapter = match!.trimString("'").trimString('"');
        } else {
          referenceAdapter = null;
        }
      }
    }
    // List
    if (type.isDartCoreList) {
      final baseType = type.typeArguments.first as InterfaceType;
      final modelType = baseType.typeArguments.first as InterfaceType;
      final modelTypeString = modelType.toString();
      final referenceModel = _refParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("modelType")
              ?.toStringValue() ??
          modelTypeString;
      final referenceDoc = _refParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("documentType")
              ?.toStringValue() ??
          "${referenceModel}Document";
      if (referenceModel.isEmpty || referenceDoc.isEmpty) {
        return null;
      }
      return ReferenceValue(
        modelType: referenceModel,
        documentType: referenceDoc,
        adapter: referenceAdapter,
        type: ReferenceValueType.list,
      );
      // Map
    } else if (type.isDartCoreMap) {
      final baseType = type.typeArguments[1] as InterfaceType;
      final modelType = baseType.typeArguments.first as InterfaceType;
      final modelTypeString = modelType.toString();
      final referenceModel = _refParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("modelType")
              ?.toStringValue() ??
          modelTypeString;
      final referenceDoc = _refParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("documentType")
              ?.toStringValue() ??
          "${referenceModel}Document";
      if (referenceModel.isEmpty || referenceDoc.isEmpty) {
        return null;
      }
      return ReferenceValue(
        modelType: referenceModel,
        documentType: referenceDoc,
        adapter: referenceAdapter,
        type: ReferenceValueType.map,
      );
      // Single
    } else {
      final modelType = type.typeArguments.first as InterfaceType;
      final modelTypeString = modelType.toString();
      final referenceModel = _refParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("modelType")
              ?.toStringValue() ??
          modelTypeString;
      final referenceDoc = _refParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("documentType")
              ?.toStringValue() ??
          "${referenceModel}Document";
      if (referenceModel.isEmpty || referenceDoc.isEmpty) {
        return null;
      }
      return ReferenceValue(
        modelType: referenceModel,
        documentType: referenceDoc,
        adapter: referenceAdapter,
        type: ReferenceValueType.single,
      );
    }
  }

  /// Parameter Element.
  ///
  /// パラメーターエレメント。
  final ParameterElement element;

  /// Parameter Type.
  ///
  /// パラメーターのタイプ。
  late final InterfaceType type;

  /// Name of parameter.
  ///
  /// パラメーターの名前。
  late final String name;

  /// True if Required.
  ///
  /// Requiredな場合true.
  late final bool required;

  /// True if search target.
  ///
  /// 検索対象の場合true.
  late final bool isSearchable;

  /// If another document is referenced, the class name of that document is entered. If it does not reference any other document, [Null] is entered.
  ///
  /// 他のドキュメントを参照している場合、そのドキュメントのクラス名が入ります。参照していない場合は[Null]が入ります。
  late final ReferenceValue? reference;

  /// True if serializable to Json.
  ///
  /// Jsonにシリアライズ可能な場合true.
  late final bool isJsonSerializable;

  /// Name of the key if [isJsonSerializable] is true.
  ///
  /// [isJsonSerializable]がtrueな場合のキーの名前。
  late final String? jsonKey;

  /// Comment assigned to the field.
  ///
  /// フィールドに付与されたコメント。
  late final String? comment;

  /// If it is deprecated, the reason is described.
  ///
  /// 非推奨になっている場合はその理由が記述されます。
  late final String? deprecated;

  @override
  String toString() {
    return "$name($type)";
  }
}

/// Definition class for `ModelRef`.
///
/// `ModelRef`用の定義クラス。
class ReferenceValue {
  /// Definition class for `ModelRef`.
  ///
  /// `ModelRef`用の定義クラス。
  const ReferenceValue({
    required this.modelType,
    required this.documentType,
    required this.type,
    this.adapter,
  });

  /// Value Type.
  ///
  /// 値のタイプ。
  final String modelType;

  /// Document Type.
  ///
  /// ドキュメントのタイプ。
  final String documentType;

  /// Value Type.
  ///
  /// 値のタイプ。
  final ReferenceValueType type;

  /// Model adapter.
  ///
  /// モデルアダプター。
  final String? adapter;

  @override
  String toString() {
    return "$modelType($documentType, $type)";
  }
}

/// Type of [ReferenceValue] value.
///
/// [ReferenceValue]の値のタイプ。
enum ReferenceValueType {
  /// Single.
  ///
  /// シングル。
  single,

  /// List.
  ///
  /// リスト。
  list,

  /// Map.
  ///
  /// マップ。
  map;
}
