part of "/masamune_builder.dart";

/// Create document and collection models.
///
/// ドキュメントモデルやコレクションモデルを作成します。
List<Spec> modelClass(
  ClassValue model,
  ModelAnnotationValue annotation,
  PathValue path,
  PathValue? mirror,
  GoogleSpreadSheetValue googleSpreadSheetValue,
) {
  final jsonSerarizable =
      model.parameters.where((e) => e.isJsonSerializable).toList();
  return [
    Extension(
      (e) => e
        ..on = Reference(model.name)
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "rawValue"
              ..type = MethodType.getter
              ..returns = const Reference("Map<String, dynamic>")
              ..body = Code(
                jsonSerarizable.isEmpty
                    ? "return toJson();"
                    : "final map = toJson(); return { ...map, ${jsonSerarizable.map((e) => "\"${e.jsonKey}\": ${_jsonValue(name: e.name, type: e.type)}").join(",")}};",
              ),
          ),
        ]),
    ),
    Enum(
      (e) => e
        ..name = "_\$${model.name}Keys"
        ..values.addAll([
          ...model.parameters.map((param) {
            return EnumValue(
              (v) => v..name = param.name,
            );
          }),
        ]),
    ),
  ];
}

String _jsonValue({
  required String name,
  required InterfaceType type,
}) {
  if (type.isDartCoreMap) {
    final found = type.typeArguments.firstWhereOrNull((e) =>
        e.isDartCoreIterable ||
        e.isDartCoreMap ||
        e.isDartCoreList ||
        e.isDartCoreSet);
    if (found != null) {
      if (type.aliasName.endsWith("?")) {
        return "$name?.map((k, v) => MapEntry(k, ${_jsonValue(name: "v", type: found as InterfaceType)}))";
      } else {
        return "$name.map((k, v) => MapEntry(k, ${_jsonValue(name: "v", type: found as InterfaceType)}))";
      }
    }
    if (type.aliasName.endsWith("?")) {
      return "$name?.map((k, v) => MapEntry(k, v.toJson()))";
    } else {
      return "$name.map((k, v) => MapEntry(k, v.toJson()))";
    }
  } else if (type.isDartCoreList ||
      type.isDartCoreSet ||
      type.isDartCoreIterable) {
    final found = type.typeArguments.firstWhereOrNull((e) =>
        e.isDartCoreIterable ||
        e.isDartCoreList ||
        e.isDartCoreSet ||
        e.isDartCoreMap);
    if (found != null) {
      if (type.aliasName.endsWith("?")) {
        return "$name?.map((e) => e.map((e) => ${_jsonValue(name: "e", type: found as InterfaceType)}).toList()).toList()";
      } else {
        return "$name.map((e) => e.map((e) => ${_jsonValue(name: "e", type: found as InterfaceType)}).toList()).toList()";
      }
    }
    if (type.aliasName.endsWith("?")) {
      return "$name?.map((e) => e.toJson()).toList()";
    } else {
      return "$name.map((e) => e.toJson()).toList()";
    }
  } else {
    if (type.aliasName.endsWith("?")) {
      return "$name?.toJson()";
    } else {
      return "$name.toJson()";
    }
  }
}
