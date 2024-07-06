part of '/masamune_builder.dart';

/// Create a class to automatically create a document model.
///
/// ドキュメントモデルを自動作成するためのクラスを作成します。
List<Spec> documentModelClass(
  ClassValue model,
  ModelAnnotationValue annotation,
  PathValue path,
  PathValue? mirror,
  GoogleSpreadSheetValue googleSpreadSheetValue,
) {
  final searchable = model.parameters.where((e) => e.isSearchable).toList();
  final referenceable =
      model.parameters.where((e) => e.reference != null).toList();

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
              ..name = "defaultModelAccessQuery"
              ..static = true
              ..modifier = FieldModifier.constant
              ..type = const Reference("ModelAccessQuery?")
              ..assignment = Code(
                annotation.endpoint.isEmpty
                    ? "null"
                    : "ModelAccessQuery(endpoint:\"${annotation.endpoint}\")",
              ),
          ),
          Field(
            (f) => f
              ..name = "defaultValidationQueries"
              ..static = true
              ..modifier = FieldModifier.constant
              ..type = const Reference("List<ModelValidationQuery>?")
              ..assignment = Code(
                annotation.permission == null
                    ? "null"
                    : "[${annotation.permission!.map((e) => e.toValidationQueryString(path)).where((e) => e.isNotEmpty).join(",")}]",
              ),
          ),
          if (googleSpreadSheetValue.source.isEmpty)
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
          else
            Field(
              (f) => f
                ..name = "defaultModelAdapter"
                ..static = true
                ..modifier = FieldModifier.constant
                ..type = const Reference("ModelAdapter?")
                ..assignment = Code(googleSpreadSheetValue.toCode()),
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
                    "final tr = transaction(); await tr.call((ref, doc) async { final docTr = ref.read(doc); final mdocTr = ref.read(mirror); await onSave?.call(ref); docTr.save(newValue); mdocTr.save(newValue); });"),
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
                    "final tr = transaction(); await tr.call((ref, doc) async { final docTr = ref.read(doc); final mdocTr = ref.read(mirror); await onDelete?.call(ref); docTr.delete(); mdocTr.delete(); });"),
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
                    if (e.type.aliasName.endsWith("?")) {
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
                ..body = Code("[${referenceable.mapAndRemoveEmpty((e) {
                  final doc = e.reference?.documentType;
                  if (doc.isEmpty) {
                    return null;
                  }
                  switch (e.reference!.type) {
                    case ReferenceValueType.single:
                      return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ), adapter: ${e.reference?.adapter.isNotEmpty ?? false ? e.reference?.adapter : "$doc.defaultModelAdapter"}, accessQuery: $doc.defaultModelAccessQuery, validationQueries: $doc.defaultValidationQueries, )";
                    case ReferenceValueType.list:
                      return "ModelRefListBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, docs) => value.copyWith( ${e.name}: docs ), adapter: ${e.reference?.adapter.isNotEmpty ?? false ? e.reference?.adapter : "$doc.defaultModelAdapter"}, accessQuery: $doc.defaultModelAccessQuery, validationQueries: $doc.defaultValidationQueries, )";
                    case ReferenceValueType.map:
                      return "ModelRefMapBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, docs) => value.copyWith( ${e.name}: docs ), adapter: ${e.reference?.adapter.isNotEmpty ?? false ? e.reference?.adapter : "$doc.defaultModelAdapter"}, accessQuery: $doc.defaultModelAccessQuery, validationQueries: $doc.defaultValidationQueries, )";
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
                ..name = "defaultModelAccessQuery"
                ..static = true
                ..modifier = FieldModifier.constant
                ..type = const Reference("ModelAccessQuery?")
                ..assignment = Code(
                  annotation.endpoint.isEmpty
                      ? "null"
                      : "ModelAccessQuery(endpoint:\"${annotation.endpoint}\")",
                ),
            ),
            Field(
              (f) => f
                ..name = "defaultValidationQueries"
                ..static = true
                ..modifier = FieldModifier.constant
                ..type = const Reference("List<ModelValidationQuery>?")
                ..assignment = Code(
                  annotation.mirrorPermission == null
                      ? "null"
                      : "[${annotation.mirrorPermission!.map((e) => e.toValidationQueryString(mirror)).where((e) => e.isNotEmpty).join(",")}]",
                ),
            ),
            if (googleSpreadSheetValue.source.isEmpty)
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
            else
              Field(
                (f) => f
                  ..name = "defaultModelAdapter"
                  ..static = true
                  ..modifier = FieldModifier.constant
                  ..type = const Reference("ModelAdapter?")
                  ..assignment = Code(googleSpreadSheetValue.toCode()),
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
                ..body = const Code("value.rawValue"),
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
                    "final tr = transaction(); await tr.call((ref, doc) async { final docTr = ref.read(doc); final mdocTr = ref.read(mirror); await onSave?.call(ref); docTr.save(newValue); mdocTr.save(newValue); });"),
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
                    "final tr = transaction(); await tr.call((ref, doc) async { final docTr = ref.read(doc); final mdocTr = ref.read(mirror); await onDelete?.call(ref); docTr.delete(); mdocTr.delete(); });"),
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
                      if (e.type.aliasName.endsWith("?")) {
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
                  ..body = Code("[${referenceable.mapAndRemoveEmpty((e) {
                    final doc = e.reference?.documentType;
                    if (doc.isEmpty) {
                      return null;
                    }
                    switch (e.reference!.type) {
                      case ReferenceValueType.single:
                        return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc ), adapter: $doc.defaultModelAdapter, accessQuery: $doc.defaultModelAccessQuery, validationQueries: $doc.defaultValidationQueries, )";
                      case ReferenceValueType.list:
                        return "ModelRefListBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, docs) => value.copyWith( ${e.name}: docs ), adapter: $doc.defaultModelAdapter, accessQuery: $doc.defaultModelAccessQuery, validationQueries: $doc.defaultValidationQueries, )";
                      case ReferenceValueType.map:
                        return "ModelRefMapBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, docs) => value.copyWith( ${e.name}: docs ), adapter: $doc.defaultModelAdapter, accessQuery: $doc.defaultModelAccessQuery, validationQueries: $doc.defaultValidationQueries, )";
                    }
                  }).join(",")}]"),
              ),
          ]),
      ),
    ] else ...[
      TypeDef(
        (t) => t
          ..name = "_\$${model.name}MirrorDocument"
          ..definition = Reference("_\$${model.name}Document"),
      ),
    ],
  ];
}
