part of '/masamune_builder.dart';

/// Create a class to automatically create document model queries.
///
/// ドキュメントモデルクエリを自動作成するためのクラスを作成します。
List<Spec> documentModelQueryClass(
  ClassValue model,
  ModelAnnotationValue annotation,
  PathValue path,
  PathValue? mirror,
  GoogleSpreadSheetValue googleSpreadSheetValue,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}RefPath"
        ..extend = Reference("ModelRefPath<${model.name}>")
        ..annotations.addAll([const Reference("immutable")])
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..constant = true
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
                const Code("super(\"\")"),
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
        ..methods.addAll(
          [
            Method(
              (m) => m
                ..name = "modelQuery"
                ..annotations.addAll([
                  const Reference("override"),
                ])
                ..returns = const Reference("DocumentModelQuery")
                ..type = MethodType.getter
                ..body = Code(
                  "return DocumentModelQuery( \"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$_${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter, );",
                ),
            )
          ],
        ),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}InitialDocument"
        ..annotations.addAll([const Reference("immutable")])
        ..extend = Reference("ModelInitialDocument<${model.name}>")
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
        ]),
    ),
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
                Parameter(
                  (p) => p
                    ..name = "accessQuery"
                    ..named = true
                    ..type = const Reference("ModelAccessQuery?"),
                ),
                Parameter(
                  (p) => p
                    ..name = "permissionQueries"
                    ..named = true
                    ..type = const Reference("List<ModelPermissionQuery>?"),
                ),
              ])
              ..returns = Reference("_\$_${model.name}DocumentQuery")
              ..body = Code(
                "return _\$_${model.name}DocumentQuery(DocumentModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter ?? _\$${model.name}Document.defaultModelAdapter, accessQuery: accessQuery ?? _\$${model.name}Document.defaultModelAccessQuery, validationQueries: permissionQueries?.toValidationQueries(\"${path.path}\") ?? _\$${model.name}Document.defaultPermissionAccessQueries?.toValidationQueries(\"${path.path}\"), ));",
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
        ..extend = Reference("ModelQueryBase<_\$${model.name}Document>")
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
              ..returns = Reference("_\$${model.name}Document Function()")
              ..body = Code(
                "() => _\$${model.name}Document(modelQuery)",
              ),
          ),
          Method(
            (m) => m
              ..name = "queryName"
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
          ..name = "_\$${model.name}MirrorRefPath"
          ..annotations.addAll([const Reference("immutable")])
          ..extend = Reference("ModelRefPath<${model.name}>")
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..constant = true
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
                  const Code("super(\"\")"),
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
          ..methods.addAll(
            [
              Method(
                (m) => m
                  ..name = "modelQuery"
                  ..annotations.addAll([
                    const Reference("override"),
                  ])
                  ..returns = const Reference("DocumentModelQuery")
                  ..type = MethodType.getter
                  ..body = Code(
                    "return DocumentModelQuery( \"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$_${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter, );",
                  ),
              )
            ],
          ),
      ),
      Class(
        (c) => c
          ..name = "_\$${model.name}MirrorInitialDocument"
          ..annotations.addAll([const Reference("immutable")])
          ..extend = Reference("ModelInitialDocument<${model.name}>")
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
          ]),
      ),
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
                  Parameter(
                    (p) => p
                      ..name = "accessQuery"
                      ..named = true
                      ..type = const Reference("ModelAccessQuery?"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "permissionQueries"
                      ..named = true
                      ..type = const Reference("List<ModelPermissionQuery>?"),
                  ),
                ])
                ..returns = Reference("_\$_${model.name}MirrorDocumentQuery")
                ..body = Code(
                  "return _\$_${model.name}MirrorDocumentQuery(DocumentModelQuery(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter ?? _\$${model.name}Document.defaultModelAdapter, accessQuery: accessQuery ?? _\$${model.name}Document.defaultModelAccessQuery, validationQueries: permissionQueries?.toValidationQueries(\"${mirror.path}\") ?? _\$${model.name}Document.defaultPermissionAccessQueries?.toValidationQueries(\"${mirror.path}\"), ));",
                ),
            )
          ]),
      ),
      Class(
        (c) => c
          ..name = "_\$_${model.name}MirrorDocumentQuery"
          ..annotations.addAll([const Reference("immutable")])
          ..extend = Reference("ModelQueryBase<_\$${model.name}MirrorDocument>")
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
                    Reference("_\$${model.name}MirrorDocument Function()")
                ..body = Code(
                  "() => _\$${model.name}MirrorDocument(modelQuery)",
                ),
            ),
            Method(
              (m) => m
                ..name = "queryName"
                ..lambda = true
                ..type = MethodType.getter
                ..annotations.addAll([const Reference("override")])
                ..returns = const Reference("String")
                ..body = const Code("modelQuery.toString()"),
            ),
          ]),
      ),
    ] else ...[
      TypeDef(
        (t) => t
          ..name = "_\$${model.name}MirrorRefPath"
          ..definition = Reference("_\$${model.name}RefPath"),
      ),
      TypeDef(
        (t) => t
          ..name = "_\$${model.name}MirrorInitialDocument"
          ..definition = Reference("_\$${model.name}InitialDocument"),
      )
    ],
  ];
}
