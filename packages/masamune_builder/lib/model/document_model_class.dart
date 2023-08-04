part of masamune_builder;

/// Create a class to automatically create a document model.
///
/// ドキュメントモデルを自動作成するためのクラスを作成します。
List<Spec> documentModelClass(
  ClassValue model,
  AnnotationValue annotation,
  PathValue path,
  PathValue? mirror,
) {
  final searchable = model.parameters.where((e) => e.isSearchable).toList();
  final referenceable =
      model.parameters.where((e) => e.reference.isNotEmpty).toList();

  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}Document"
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
        ..fields.addAll([
          Field(
            (f) => f
              ..name = "defaultModelAdapter"
              ..static = true
              ..modifier = FieldModifier.final$
              ..type = const Reference("ModelAdapter?")
              ..assignment = Code(
                annotation.adapter == null ? "null" : annotation.adapter!,
              ),
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
                      ..type = Reference("_\$${model.name}MirrorDocument"),
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
                      ..type = Reference("_\$${model.name}MirrorDocument"),
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
                    final doc = e.reference;
                    return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ), adapter: $doc.defaultModelAdapter,)";
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
                    final doc = e.reference;
                    return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ), adapter: $doc.defaultModelAdapter,)";
                  }
                }).join(",")}]"),
            ),
        ]),
    ),
    if (mirror != null) ...[
      Class(
        (c) => c
          ..name = "_\$${model.name}MirrorDocument"
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
          ..fields.addAll([
            Field(
              (f) => f
                ..name = "defaultModelAdapter"
                ..static = true
                ..modifier = FieldModifier.final$
                ..type = const Reference("ModelAdapter?")
                ..assignment = Code(
                  annotation.adapter == null ? "null" : annotation.adapter!,
                ),
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
                      ..type = Reference("_\$${model.name}Document"),
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
                      ..type = Reference("_\$${model.name}Document"),
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
                      final doc = e.reference;
                      return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ), adapter: $doc.defaultModelAdapter,)";
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
                      final doc = e.reference;
                      return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ), adapter: $doc.defaultModelAdapter, )";
                    }
                  }).join(",")}]"),
              ),
          ]),
      ),
    ],
  ];
}
