part of masamune_builder;

String _querySelectorClass(ParamaterValue param, String queryClass) {
  if (param.type.isDartCoreString) {
    return "StringModelQuerySelector<$queryClass>";
  } else if (param.type.isDartCoreDouble || param.type.isDartCoreInt) {
    return "NumModelQuerySelector<$queryClass>";
  } else if (param.type.isDartCoreBool) {
    return "BooleanModelQuerySelector<$queryClass>";
  } else if (param.type.isDartCoreEnum) {
    final typeName = param.type.toString().trimStringRight("?");
    return "ValueModelQuerySelector<$typeName, $queryClass>";
  } else if (param.isReference) {
    if (param.type.toString().endsWith("Ref")) {
      final match = _regExpRef.firstMatch(param.type.toString());
      if (match == null) {
        throw Exception(
          "@refParam can only be given to ModelRef<T> / ModelRefBase<T>? / XXXRef types. \r\n\r\n${param.type.toString()} ${param.name}",
        );
      }
      return "ModelRefModelQuerySelector<${match.group(1)}, $queryClass>";
    } else {
      if (!param.type.toString().endsWith("?")) {
        throw Exception(
          "ModelRefBase<T> must be nullable. \r\n\r\n${param.type.toString()} ${param.name}",
        );
      }
      final match = _regExpModelRef.firstMatch(param.type.toString());
      if (match == null) {
        throw Exception(
          "@refParam can only be given to ModelRef<T> / ModelRefBase<T>? / XXXRef types. \r\n\r\n${param.type} ${param.name}",
        );
      }
      return "ModelRefModelQuerySelector<${match.group(2)}, $queryClass>";
    }
  } else {
    final typeName = param.type.toString().trimStringRight("?");
    switch (typeName) {
      case "ModelCounter":
      case "ModelTimestamp":
      case "ModelGeoValue":
      case "ModelLocale":
      case "ModelLocalizedValue":
      case "ModelSearch":
      case "ModelUri":
      case "ModelImageUri":
      case "ModelVideoUri":
        return "${typeName}ModelQuerySelector<$queryClass>";
      default:
        return "ValueModelQuerySelector<$typeName, $queryClass>";
    }
  }
}

/// Create a class to automatically create collection model queries.
///
/// コレクションモデルクエリを自動作成するためのクラスを作成します。
List<Spec> collectionModelQueryClass(
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
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "_id"
                    ..type = const Reference("Object"),
                ),
              ])
              ..returns = Reference("_\$_${model.name}DocumentQuery")
              ..body = Code(
                "return _\$_${model.name}DocumentQuery(DocumentModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$_id\", adapter: adapter ?? \$${model.name}Document.defaultModelAdapter,));",
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
              ..name = "queryName"
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
                "return _\$_${model.name}CollectionQuery(CollectionModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter ?? \$${model.name}Collection.defaultModelAdapter,));",
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
              ..name = "queryName"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("String")
              ..body = const Code("modelQuery.toString()"),
          ),
          Method(
            (m) => m
              ..name = "_toQuery"
              ..static = true
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "query"
                    ..type = const Reference("CollectionModelQuery"),
                )
              ])
              ..returns = Reference("_\$_${model.name}CollectionQuery")
              ..body = Code("_\$_${model.name}CollectionQuery(query)"),
          ),
          Method(
            (m) => m
              ..name = "limitTo"
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = const Reference("int"),
                )
              ])
              ..returns = Reference("_\$_${model.name}CollectionQuery")
              ..body = Code(
                  "_\$_${model.name}CollectionQuery(modelQuery.limitTo(value))"),
          ),
          Method(
            (m) => m
              ..name = "reset"
              ..lambda = true
              ..returns = Reference("_\$_${model.name}CollectionQuery")
              ..body =
                  Code("_\$_${model.name}CollectionQuery(modelQuery.reset())"),
          ),
          ...model.parameters.map((param) {
            return Method(
              (m) => m
                ..name = param.name
                ..type = MethodType.getter
                ..lambda = true
                ..returns = Reference(
                  _querySelectorClass(
                    param,
                    "_\$_${model.name}CollectionQuery",
                  ),
                )
                ..body = Code(
                    "${_querySelectorClass(param, "_\$_${model.name}CollectionQuery")}(key: \"${param.jsonKey}\", toQuery: _toQuery, modelQuery: modelQuery)"),
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
                  "return _\$_${model.name}MirrorDocumentQuery(DocumentModelQuery(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$_id\", adapter: adapter ?? \$${model.name}Document.defaultModelAdapter,));",
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
                ..name = "queryName"
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
                  "return _\$_${model.name}MirrorCollectionQuery(CollectionModelQuery(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter ?? \$${model.name}Collection.defaultModelAdapter,));",
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
                ..name = "queryName"
                ..lambda = true
                ..type = MethodType.getter
                ..annotations.addAll([const Reference("override")])
                ..returns = const Reference("String")
                ..body = const Code("modelQuery.toString()"),
            ),
            Method(
              (m) => m
                ..name = "_toQuery"
                ..static = true
                ..lambda = true
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "query"
                      ..type = const Reference("CollectionModelQuery"),
                  )
                ])
                ..returns = Reference("_\$_${model.name}MirrorCollectionQuery")
                ..body = Code("_\$_${model.name}MirrorCollectionQuery(query)"),
            ),
            Method(
              (m) => m
                ..name = "limitTo"
                ..lambda = true
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "value"
                      ..type = const Reference("int"),
                  )
                ])
                ..returns = Reference("_\$_${model.name}MirrorCollectionQuery")
                ..body = Code(
                    "_\$_${model.name}MirrorCollectionQuery(modelQuery.limitTo(value))"),
            ),
            Method(
              (m) => m
                ..name = "reset"
                ..lambda = true
                ..returns = Reference("_\$_${model.name}MirrorCollectionQuery")
                ..body = Code(
                    "_\$_${model.name}MirrorCollectionQuery(modelQuery.reset())"),
            ),
            ...model.parameters.map((param) {
              return Method(
                (m) => m
                  ..name = param.name
                  ..type = MethodType.getter
                  ..lambda = true
                  ..returns = Reference(
                    _querySelectorClass(
                      param,
                      "_\$_${model.name}MirrorCollectionQuery",
                    ),
                  )
                  ..body = Code(
                      "${_querySelectorClass(param, "_\$_${model.name}MirrorCollectionQuery")}(key: \"${param.jsonKey}\", toQuery: _toQuery, modelQuery: modelQuery)"),
              );
            }),
          ]),
      ),
    ],
  ];
}
