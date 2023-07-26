part of masamune_builder;

/// Create a class to automatically create collection model queries.
///
/// コレクションモデルクエリを自動作成するためのクラスを作成します。
List<Spec> collectionModelQueryClass(
  ClassValue model,
  PathValue path,
  PathValue? mirror,
) {
  return [
    Enum(
      (e) => e
        ..name = "${model.name}CollectionKey"
        ..values.addAll([
          ...model.parameters.map((param) {
            return EnumValue(
              (v) => v..name = param.name,
            );
          }),
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
              ])
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "_id"
                    ..type = const Reference("Object"),
                ),
              ])
              ..returns = Reference("_\$_${model.name}DocumentQuery")
              ..body = Code(
                "return _\$_${model.name}DocumentQuery(DocumentModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$_id\", adapter: adapter,));",
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
    Class(
      (c) => c
        ..name = "_\$${model.name}CollectionQuery"
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
              ..returns = Reference("_\$_${model.name}CollectionQuery")
              ..body = Code(
                "return _\$_${model.name}CollectionQuery(CollectionModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter,));",
              ),
          ),
          if (mirror != null)
            Method(
              (m) => m
                ..name = "mirror"
                ..type = MethodType.getter
                ..returns = Reference("_\$${model.name}MirrorCollectionQuery")
                ..lambda = true
                ..body = Code("_\$${model.name}MirrorCollectionQuery()"),
            ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$_${model.name}CollectionQuery"
        ..annotations.addAll([const Reference("immutable")])
        ..extend = Reference("ModelQueryBase<\$${model.name}Collection>")
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
              ..type = const Reference("CollectionModelQuery"),
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
              ..returns = Reference("\$${model.name}Collection Function()")
              ..body = Code(
                "() => \$${model.name}Collection(modelQuery)",
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
          ...CollectionQueryType.values.map((queryType) {
            return Method(
              (m) => m
                ..name = queryType.name
                ..returns = Reference("_\$_${model.name}CollectionQuery")
                ..requiredParameters.addAll(
                    [...queryType.parameters("${model.name}CollectionKey")])
                ..body = Code(
                  "return _\$_${model.name}CollectionQuery(modelQuery.${queryType.methodCode});",
                ),
            );
          }),
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
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "_id"
                      ..type = const Reference("Object"),
                  ),
                ])
                ..returns = Reference("_\$_${model.name}MirrorDocumentQuery")
                ..body = Code(
                  "return _\$_${model.name}MirrorDocumentQuery(DocumentModelQuery(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$_id\", adapter: adapter,));",
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
      Class(
        (c) => c
          ..name = "_\$${model.name}MirrorCollectionQuery"
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
                ..returns = Reference("_\$_${model.name}MirrorCollectionQuery")
                ..body = Code(
                  "return _\$_${model.name}MirrorCollectionQuery(CollectionModelQuery(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter,));",
                ),
            )
          ]),
      ),
      Class(
        (c) => c
          ..name = "_\$_${model.name}MirrorCollectionQuery"
          ..annotations.addAll([const Reference("immutable")])
          ..extend =
              Reference("ModelQueryBase<\$${model.name}MirrorCollection>")
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
                ..type = const Reference("CollectionModelQuery"),
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
                    Reference("\$${model.name}MirrorCollection Function()")
                ..body = Code(
                  "() => \$${model.name}MirrorCollection(modelQuery)",
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
            ...CollectionQueryType.values.map((queryType) {
              return Method(
                (m) => m
                  ..name = queryType.name
                  ..returns =
                      Reference("_\$_${model.name}MirrorCollectionQuery")
                  ..requiredParameters.addAll(
                      [...queryType.parameters("${model.name}CollectionKey")])
                  ..body = Code(
                    "return _\$_${model.name}MirrorCollectionQuery(modelQuery.${queryType.methodCode});",
                  ),
              );
            }),
          ]),
      ),
    ],
  ];
}
