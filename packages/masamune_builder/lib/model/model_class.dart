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
        ..name = "\$${model.name}Extensions"
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
