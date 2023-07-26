part of masamune_builder;

final _regExpModelRef = RegExp(r"ModelRef(Base)?<([^>]+)>");
final _regExpRef = RegExp(r"(.+)Ref");

/// Create document and collection models.
///
/// ドキュメントモデルやコレクションモデルを作成します。
List<Spec> modelClass(
  ClassValue model,
  PathValue path,
  PathValue? mirror,
) {
  final searchable = model.parameters.where((e) => e.isSearchable).toList();
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
    Class(
      (c) => c
        ..name = "${model.name}RawCollection"
        ..extend = Reference("ModelRawCollection<${model.name}>")
        ..mixins.addAll([
          if (searchable.isNotEmpty)
            Reference("SearchableRawCollectionMixin<${model.name}>"),
        ])
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..constant = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..toSuper = true,
                )
              ])
              ..optionalParameters.addAll([
                ...path.parameters.map((param) {
                  return Parameter(
                    (p) => p
                      ..name = param.camelCase
                      ..named = true
                      ..required = true
                      ..type = const Reference("String"),
                  );
                }),
              ])
              ..initializers.addAll([
                ...path.parameters.map((param) {
                  return Code("_${param.camelCase} = ${param.camelCase}");
                }),
              ]),
          ),
        ])
        ..fields.addAll([
          ...path.parameters.map((param) {
            return Field(
              (f) => f
                ..name = "_${param.camelCase}"
                ..modifier = FieldModifier.final$
                ..type = const Reference("String"),
            );
          }),
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "path"
              ..annotations.addAll([
                const Reference("override"),
              ])
              ..type = MethodType.getter
              ..lambda = true
              ..returns = const Reference("String")
              ..body = Code(
                "\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$_${m.group(1)?.toCamelCase() ?? ""}")}\"",
              ),
          ),
          Method(
            (m) => m
              ..name = "toMap"
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = Reference(model.name),
                )
              ])
              ..annotations.addAll([
                const Reference("override"),
              ])
              ..returns = const Reference("DynamicMap")
              ..lambda = true
              ..body = const Code("value.rawValue"),
          ),
          Method(
            (m) => m
              ..name = "ref"
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "key"
                    ..type = const Reference("String"),
                ),
              ])
              ..optionalParameters.addAll([
                ...path.parameters.map((param) {
                  return Parameter(
                    (p) => p
                      ..name = param.camelCase
                      ..named = true
                      ..required = true
                      ..type = const Reference("String"),
                  );
                }),
              ])
              ..static = true
              ..returns = Reference("ModelRefBase<${model.name}>")
              ..lambda = true
              ..body = Code(
                "ModelRefBase<${model.name}>.fromPath(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$key\")",
              ),
          ),
          if (searchable.isNotEmpty)
            Method(
              (m) => m
                ..name = "buildSearchText"
                ..lambda = true
                ..returns = const Reference("String")
                ..annotations.addAll([const Reference("override")])
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "value"
                      ..type = Reference(model.name),
                  )
                ])
                ..body = Code(
                  searchable.map((e) {
                    if (e.type.toString().endsWith("?")) {
                      return "(value.${e.name}?.toString() ?? \"\")";
                    } else {
                      return "value.${e.name}.toString()";
                    }
                  }).join(" + "),
                ),
            ),
        ]),
    ),
    if (mirror != null) ...[
      Class(
        (c) => c
          ..name = "${model.name}MirrorRawCollection"
          ..extend = Reference("ModelRawCollection<${model.name}>")
          ..mixins.addAll([
            if (searchable.isNotEmpty)
              Reference("SearchableRawCollectionMixin<${model.name}>"),
          ])
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..constant = true
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "value"
                      ..toSuper = true,
                  )
                ])
                ..optionalParameters.addAll([
                  ...mirror.parameters.map((param) {
                    return Parameter(
                      (p) => p
                        ..name = param.camelCase
                        ..named = true
                        ..required = true
                        ..type = const Reference("String"),
                    );
                  }),
                ])
                ..initializers.addAll([
                  ...mirror.parameters.map((param) {
                    return Code("_${param.camelCase} = ${param.camelCase}");
                  }),
                ]),
            ),
          ])
          ..fields.addAll([
            ...mirror.parameters.map((param) {
              return Field(
                (f) => f
                  ..name = "_${param.camelCase}"
                  ..modifier = FieldModifier.final$
                  ..type = const Reference("String"),
              );
            }),
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "path"
                ..annotations.addAll([
                  const Reference("override"),
                ])
                ..type = MethodType.getter
                ..lambda = true
                ..returns = const Reference("String")
                ..body = Code(
                  "\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$_${m.group(1)?.toCamelCase() ?? ""}")}\"",
                ),
            ),
            Method(
              (m) => m
                ..name = "toMap"
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "value"
                      ..type = Reference(model.name),
                  )
                ])
                ..annotations.addAll([
                  const Reference("override"),
                ])
                ..returns = const Reference("DynamicMap")
                ..lambda = true
                ..body = const Code("value.rawValue"),
            ),
            Method(
              (m) => m
                ..name = "ref"
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "key"
                      ..type = const Reference("String"),
                  ),
                ])
                ..optionalParameters.addAll([
                  ...mirror.parameters.map((param) {
                    return Parameter(
                      (p) => p
                        ..name = param.camelCase
                        ..named = true
                        ..required = true
                        ..type = const Reference("String"),
                    );
                  }),
                ])
                ..static = true
                ..returns = Reference("ModelRefBase<${model.name}>")
                ..lambda = true
                ..body = Code(
                  "ModelRefBase<${model.name}>.fromPath(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$key\")",
                ),
            ),
            if (searchable.isNotEmpty)
              Method(
                (m) => m
                  ..name = "buildSearchText"
                  ..lambda = true
                  ..returns = const Reference("String")
                  ..annotations.addAll([const Reference("override")])
                  ..requiredParameters.addAll([
                    Parameter(
                      (p) => p
                        ..name = "value"
                        ..type = Reference(model.name),
                    )
                  ])
                  ..body = Code(
                    searchable.map((e) {
                      if (e.type.toString().endsWith("?")) {
                        return "(value.${e.name}?.toString() ?? \"\")";
                      } else {
                        return "value.${e.name}.toString()";
                      }
                    }).join(" + "),
                  ),
              ),
          ]),
      ),
    ],
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
