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
  final referenceable = model.parameters.where((e) => e.isReference).toList();
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
        ..name = "\$${model.name}Document"
        ..extend = Reference("DocumentBase<${model.name}>")
        ..mixins.addAll([
          Reference("ModelRefMixin<${model.name}>"),
          if (searchable.isNotEmpty)
            Reference("SearchableDocumentMixin<${model.name}>"),
          if (referenceable.isNotEmpty)
            Reference("ModelRefLoaderMixin<${model.name}>")
        ])
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "modelQuery"
                    ..toSuper = true,
                )
              ]),
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "fromMap"
              ..lambda = true
              ..returns = Reference(model.name)
              ..annotations.addAll([const Reference("override")])
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "map"
                    ..type = const Reference("DynamicMap"),
                )
              ])
              ..body = Code("${model.name}.fromJson(map)"),
          ),
          Method(
            (m) => m
              ..name = "toMap"
              ..returns = const Reference("DynamicMap")
              ..lambda = true
              ..annotations.addAll([const Reference("override")])
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = Reference(model.name),
                )
              ])
              ..body = const Code("value.rawValue"),
          ),
          if (mirror != null) ...[
            Method(
              (m) => m
                ..name = "saveSync"
                ..returns = const Reference("Future<void>")
                ..modifier = MethodModifier.async
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "mirror"
                      ..type = Reference("\$${model.name}MirrorDocument"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "newValue"
                      ..type = Reference(model.name),
                  ),
                ])
                ..optionalParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "onSave"
                      ..named = true
                      ..type = const Reference(
                          "Future<void> Function(ModelTransactionRef ref)?"),
                  ),
                ])
                ..body = const Code(
                    "final tr = transaction(); await tr.call((ref, doc) async { final mdoc = ref.read(mirror); await onSave?.call(ref); doc.save(newValue); mdoc.save(newValue); });"),
            ),
            Method(
              (m) => m
                ..name = "deleteSync"
                ..returns = const Reference("Future<void>")
                ..modifier = MethodModifier.async
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "mirror"
                      ..type = Reference("\$${model.name}MirrorDocument"),
                  )
                ])
                ..optionalParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "onDelete"
                      ..named = true
                      ..type = const Reference(
                          "Future<void> Function(ModelTransactionRef ref)?"),
                  ),
                ])
                ..body = const Code(
                    "final tr = transaction(); await tr.call((ref, doc) async { final mdoc = ref.read(mirror); await onDelete?.call(ref); doc.delete(); mdoc.delete(); });"),
            ),
          ],
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
          if (referenceable.isNotEmpty)
            Method(
              (m) => m
                ..name = "builder"
                ..lambda = true
                ..type = MethodType.getter
                ..returns =
                    Reference("List<ModelRefBuilderBase<${model.name}>>")
                ..annotations.addAll([const Reference("override")])
                ..body = Code("[${referenceable.map((e) {
                  if (e.type.toString().endsWith("Ref")) {
                    final match = _regExpRef.firstMatch(e.type.toString());
                    if (match == null) {
                      throw Exception(
                        "@refParam can only be given to ModelRef<T> / ModelRefBase<T>? / XXXRef types. \r\n\r\n${e.type} ${e.name}",
                      );
                    }
                    final doc = "\$${match.group(1)}Document";
                    return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ),)";
                  } else {
                    if (!e.type.toString().endsWith("?")) {
                      throw Exception(
                        "ModelRefBase<T> must be nullable. \r\n\r\n${e.type} ${e.name}",
                      );
                    }
                    final match = _regExpModelRef.firstMatch(e.type.toString());
                    if (match == null) {
                      throw Exception(
                        "@refParam can only be given to ModelRef<T> / ModelRefBase<T>? / XXXRef types. \r\n\r\n${e.type} ${e.name}",
                      );
                    }
                    final doc = "\$${match.group(2)}Document";
                    return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ),)";
                  }
                }).join(",")}]"),
            ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "\$${model.name}Collection"
        ..extend = Reference("CollectionBase<\$${model.name}Document>")
        ..mixins.addAll([
          Reference(
            "FilterableCollectionMixin<\$${model.name}Document, _\$_${model.name}CollectionQuery>",
          ),
          if (searchable.isNotEmpty)
            Reference("SearchableCollectionMixin<\$${model.name}Document>")
        ])
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "modelQuery"
                    ..toSuper = true,
                )
              ]),
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "create"
              ..annotations.addAll([const Reference("override")])
              ..lambda = true
              ..returns = Reference("\$${model.name}Document")
              ..optionalParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "id"
                    ..type = const Reference("String?"),
                )
              ])
              ..body = Code("\$${model.name}Document(modelQuery.create(id))"),
          ),
          Method(
            (m) => m
              ..name = "filter"
              ..annotations.addAll([const Reference("override")])
              ..returns =
                  Reference("Future<CollectionBase<\$${model.name}Document>>")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "callback"
                    ..type = Reference(
                        "_\$_${model.name}CollectionQuery Function(_\$_${model.name}CollectionQuery source)"),
                )
              ])
              ..body = Code(
                "final query = callback.call(_\$_${model.name}CollectionQuery(modelQuery)); return replaceQuery((_) => query.modelQuery);",
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
          ..name = "\$${model.name}MirrorDocument"
          ..extend = Reference("DocumentBase<${model.name}>")
          ..mixins.addAll([
            Reference("ModelRefMixin<${model.name}>"),
            if (searchable.isNotEmpty)
              Reference("SearchableDocumentMixin<${model.name}>"),
            if (referenceable.isNotEmpty)
              Reference("ModelRefLoaderMixin<${model.name}>")
          ])
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "modelQuery"
                      ..toSuper = true,
                  )
                ]),
            )
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "fromMap"
                ..lambda = true
                ..returns = Reference(model.name)
                ..annotations.addAll([const Reference("override")])
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "map"
                      ..type = const Reference("DynamicMap"),
                  )
                ])
                ..body = Code("${model.name}.fromJson(map)"),
            ),
            Method(
              (m) => m
                ..name = "toMap"
                ..lambda = true
                ..returns = const Reference("DynamicMap")
                ..annotations.addAll([const Reference("override")])
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "value"
                      ..type = Reference(model.name),
                  )
                ])
                ..body = const Code("value.toJson()"),
            ),
            Method(
              (m) => m
                ..name = "saveSync"
                ..returns = const Reference("Future<void>")
                ..modifier = MethodModifier.async
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "mirror"
                      ..type = Reference("\$${model.name}Document"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "newValue"
                      ..type = Reference(model.name),
                  )
                ])
                ..optionalParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "onSave"
                      ..named = true
                      ..type = const Reference(
                          "Future<void> Function(ModelTransactionRef ref)?"),
                  ),
                ])
                ..body = const Code(
                    "final tr = transaction(); await tr.call((ref, doc) async { final mdoc = ref.read(mirror); await onSave?.call(ref); doc.save(newValue); mdoc.save(newValue); });"),
            ),
            Method(
              (m) => m
                ..name = "deleteSync"
                ..returns = const Reference("Future<void>")
                ..modifier = MethodModifier.async
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "mirror"
                      ..type = Reference("\$${model.name}Document"),
                  )
                ])
                ..optionalParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "onDelete"
                      ..named = true
                      ..type = const Reference(
                          "Future<void> Function(ModelTransactionRef ref)?"),
                  ),
                ])
                ..body = const Code(
                    "final tr = transaction(); await tr.call((ref, doc) async { final mdoc = ref.read(mirror); await onDelete?.call(ref); doc.delete(); mdoc.delete(); });"),
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
            if (referenceable.isNotEmpty)
              Method(
                (m) => m
                  ..name = "builder"
                  ..lambda = true
                  ..type = MethodType.getter
                  ..returns =
                      Reference("List<ModelRefBuilderBase<${model.name}>>")
                  ..annotations.addAll([const Reference("override")])
                  ..body = Code("[${referenceable.map((e) {
                    if (e.type.toString().endsWith("Ref")) {
                      final match = _regExpRef.firstMatch(e.type.toString());
                      if (match == null) {
                        throw Exception(
                          "@refParam can only be given to ModelRef<T> / ModelRefBase<T>? / XXXRef types. \r\n\r\n${e.type} ${e.name}",
                        );
                      }
                      final doc = "\$${match.group(1)}Document";
                      return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ),)";
                    } else {
                      if (!e.type.toString().endsWith("?")) {
                        throw Exception(
                          "ModelRefBase<T> must be nullable. \r\n\r\n${e.type} ${e.name}",
                        );
                      }
                      final match =
                          _regExpModelRef.firstMatch(e.type.toString());
                      if (match == null) {
                        throw Exception(
                          "@refParam can only be given to ModelRef<T> / ModelRefBase<T>? / XXXRef types. \r\n\r\n${e.type} ${e.name}",
                        );
                      }
                      final doc = "\$${match.group(2)}Document";
                      return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ),)";
                    }
                  }).join(",")}]"),
              ),
          ]),
      ),
      Class(
        (c) => c
          ..name = "\$${model.name}MirrorCollection"
          ..extend = Reference("CollectionBase<\$${model.name}MirrorDocument>")
          ..mixins.addAll([
            Reference(
              "FilterableCollectionMixin<\$${model.name}MirrorDocument, _\$_${model.name}MirrorCollectionQuery>",
            ),
            if (searchable.isNotEmpty)
              Reference(
                  "SearchableCollectionMixin<\$${model.name}MirrorDocument>")
          ])
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "modelQuery"
                      ..toSuper = true,
                  )
                ]),
            )
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "create"
                ..annotations.addAll([const Reference("override")])
                ..lambda = true
                ..returns = Reference("\$${model.name}MirrorDocument")
                ..optionalParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "id"
                      ..type = const Reference("String?"),
                  )
                ])
                ..body = Code(
                    "\$${model.name}MirrorDocument(modelQuery.create(id))"),
            ),
            Method(
              (m) => m
                ..name = "filter"
                ..annotations.addAll([const Reference("override")])
                ..returns = Reference(
                    "Future<CollectionBase<\$${model.name}MirrorDocument>>")
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "callback"
                      ..type = Reference(
                          "_\$_${model.name}MirrorCollectionQuery Function(_\$_${model.name}MirrorCollectionQuery source)"),
                  )
                ])
                ..body = Code(
                  "final query = callback.call(_\$_${model.name}MirrorCollectionQuery(modelQuery)); return replaceQuery((_) => query.modelQuery);",
                ),
            ),
          ]),
      ),
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
