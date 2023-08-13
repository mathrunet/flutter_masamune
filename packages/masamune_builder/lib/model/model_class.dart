part of masamune_builder;

final _regExpModelRef = RegExp(r"ModelRef(Base)?<([^>]+)>");
final _regExpRef = RegExp(r"(.+)Ref");

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
                    : "final map = toJson(); return { ...map, ${jsonSerarizable.map((e) => "\"${e.jsonKey}\": ${_jsonValue(e)}").join(",")}};",
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

String _jsonValue(ParamaterValue param) {
  if (param.type.isDartCoreList) {
    if (param.type.toString().endsWith("?")) {
      return "${param.name}?.map((e) => e.toJson()).toList()";
    } else {
      return "${param.name}.map((e) => e.toJson()).toList()";
    }
  } else if (param.type.isDartCoreMap) {
    if (param.type.toString().endsWith("?")) {
      return "${param.name}?.map((k, v) => MapEntry(k, v.toJson()))";
    } else {
      return "${param.name}.map((k, v) => MapEntry(k, v.toJson()))";
    }
  } else {
    if (param.type.toString().endsWith("?")) {
      return "${param.name}?.toJson()";
    } else {
      return "${param.name}.toJson()";
    }
  }
}
