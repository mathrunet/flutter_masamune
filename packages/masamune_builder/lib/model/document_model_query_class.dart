part of masamune_builder;

/// Create a class to automatically create document model queries.
///
/// ドキュメントモデルクエリを自動作成するためのクラスを作成します。
List<Spec> documentModelQueryClass(
  ClassValue model,
  AnnotationValue annotation,
  PathValue path,
  PathValue? mirror,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}DocumentQuery"
        ..annotations.addAll([const Reference("immutable")])
        ..constructors.addAll([
          Constructor(
            (c) => c..constant = true,
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "call"
              ..annotations.addAll([const Reference("useResult")])
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
                Parameter(
                  (p) => p
                    ..name = "adapter"
                    ..named = true
                    ..type = const Reference("ModelAdapter?"),
                ),
              ])
              ..returns = Reference("_\$_${model.name}DocumentQuery")
              ..body = Code(
                "return _\$_${model.name}DocumentQuery(DocumentModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter ?? \$${model.name}Document.defaultModelAdapter,));",
              ),
          ),
          if (mirror != null)
            Method(
              (m) => m
                ..name = "mirror"
                ..type = MethodType.getter
                ..returns = Reference("_\$${model.name}MirrorDocumentQuery")
                ..lambda = true
                ..body = Code("_\$${model.name}MirrorDocumentQuery()"),
            ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$_${model.name}DocumentQuery"
        ..annotations.addAll([const Reference("immutable")])
        ..extend = Reference("ModelQueryBase<\$${model.name}Document>")
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..constant = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "modelQuery"
                    ..toThis = true,
                )
              ]),
          )
        ])
        ..fields.addAll([
          Field(
            (f) => f
              ..name = "modelQuery"
              ..modifier = FieldModifier.final$
              ..type = const Reference("DocumentModelQuery"),
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "call"
              ..lambda = true
              ..annotations.addAll([const Reference("override")])
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "ref"
                    ..type = const Reference("Ref"),
                )
              ])
              ..returns = Reference("\$${model.name}Document Function()")
              ..body = Code(
                "() => \$${model.name}Document(modelQuery)",
              ),
          ),
          Method(
            (m) => m
              ..name = "name"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("String")
              ..body = const Code("modelQuery.toString()"),
          ),
        ]),
    ),
    if (mirror != null) ...[
      Class(
        (c) => c
          ..name = "_\$${model.name}MirrorDocumentQuery"
          ..annotations.addAll([const Reference("immutable")])
          ..constructors.addAll([
            Constructor(
              (c) => c..constant = true,
            )
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "call"
                ..annotations.addAll([const Reference("useResult")])
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
                  Parameter(
                    (p) => p
                      ..name = "adapter"
                      ..named = true
                      ..type = const Reference("ModelAdapter?"),
                  ),
                ])
                ..returns = Reference("_\$_${model.name}MirrorDocumentQuery")
                ..body = Code(
                  "return _\$_${model.name}MirrorDocumentQuery(DocumentModelQuery(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter ?? \$${model.name}Document.defaultModelAdapter,));",
                ),
            )
          ]),
      ),
      Class(
        (c) => c
          ..name = "_\$_${model.name}MirrorDocumentQuery"
          ..annotations.addAll([const Reference("immutable")])
          ..extend = Reference("ModelQueryBase<\$${model.name}MirrorDocument>")
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..constant = true
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "modelQuery"
                      ..toThis = true,
                  )
                ]),
            )
          ])
          ..fields.addAll([
            Field(
              (f) => f
                ..name = "modelQuery"
                ..modifier = FieldModifier.final$
                ..type = const Reference("DocumentModelQuery"),
            )
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "call"
                ..lambda = true
                ..annotations.addAll([const Reference("override")])
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "ref"
                      ..type = const Reference("Ref"),
                  )
                ])
                ..returns =
                    Reference("\$${model.name}MirrorDocument Function()")
                ..body = Code(
                  "() => \$${model.name}MirrorDocument(modelQuery)",
                ),
            ),
            Method(
              (m) => m
                ..name = "name"
                ..lambda = true
                ..type = MethodType.getter
                ..annotations.addAll([const Reference("override")])
                ..returns = const Reference("String")
                ..body = const Code("modelQuery.toString()"),
            ),
          ]),
      ),
    ],
  ];
}
