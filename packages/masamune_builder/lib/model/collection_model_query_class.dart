part of '/masamune_builder.dart';

String _querySelectorClass(ParamaterValue param, String queryClass) {
  if (param.type.isDartCoreString) {
    return "StringModelQuerySelector<$queryClass>";
  } else if (param.type.isDartCoreDouble || param.type.isDartCoreInt) {
    return "NumModelQuerySelector<$queryClass>";
  } else if (param.type.isDartCoreBool) {
    return "BooleanModelQuerySelector<$queryClass>";
  } else if (param.type.isDartCoreEnum || param.type.element is EnumElement) {
    final typeName = param.type.aliasName.trimStringRight("?");
    return "ValueModelQuerySelector<$typeName, $queryClass>";
  } else if (param.type.isDartCoreList) {
    final generics = RegExp("List<([^>]+)>")
            .firstMatch(param.type.aliasName)
            ?.group(1)
            ?.trim() ??
        "dynamic";
    return "ListModelQuerySelector<$generics, $queryClass>";
  } else if (param.type.isDartCoreMap) {
    final generics = RegExp("Map<([^>]+),([^>]+)>")
            .firstMatch(param.type.aliasName)
            ?.group(2)
            ?.trim() ??
        "dynamic";
    return "MapModelQuerySelector<$generics, $queryClass>";
  } else if (param.reference.isNotEmpty) {
    if (param.type.aliasName.endsWith("Ref")) {
      final match = _regExpRef.firstMatch(param.type.aliasName);
      if (match == null) {
        throw Exception(
          "@refParam can only be given to ModelRef<T> / ModelRefBase<T>? / XXXRef types. \r\n\r\n${param.type.aliasName} ${param.name}",
        );
      }
      return "ModelRefModelQuerySelector<${match.group(1)}, $queryClass>";
    } else {
      if (!param.type.aliasName.endsWith("?")) {
        throw Exception(
          "ModelRefBase<T> must be nullable. \r\n\r\n${param.type.aliasName} ${param.name}",
        );
      }
      final match = _regExpModelRef.firstMatch(param.type.aliasName);
      if (match == null) {
        throw Exception(
          "@refParam can only be given to ModelRef<T> / ModelRefBase<T>? / XXXRef types. \r\n\r\n${param.type} ${param.name}",
        );
      }
      return "ModelRefModelQuerySelector<${match.group(2)}, $queryClass>";
    }
  } else {
    final typeName = param.type.aliasName.trimStringRight("?");
    switch (typeName) {
      case "ModelCounter":
      case "ModelTimestamp":
      case "ModelGeoValue":
      case "ModelLocale":
      case "ModelLocalizedValue":
      case "ModelSearch":
      case "ModelToken":
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
  ModelAnnotationValue annotation,
  PathValue path,
  PathValue? mirror,
  GoogleSpreadSheetValue googleSpreadSheetValue,
) {
  final searchable = model.parameters.where((e) => e.isSearchable).toList();

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
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "uid"
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
                  "return DocumentModelQuery( \"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$_${m.group(1)?.toCamelCase() ?? ""}")}/\${path.trimQuery().trimString(\"/\")}\", adapter: adapter, );",
                ),
            )
          ],
        ),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}InitialCollection"
        ..annotations.addAll([const Reference("immutable")])
        ..extend = Reference("ModelInitialCollection<${model.name}>")
        ..mixins.addAll([
          if (searchable.isNotEmpty)
            Reference("SearchableInitialCollectionMixin<${model.name}>"),
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
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "_id"
                    ..type = const Reference("Object"),
                ),
              ])
              ..returns = Reference("_\$_${model.name}DocumentQuery")
              ..body = Code(
                "return _\$_${model.name}DocumentQuery(DocumentModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$_id\", adapter: adapter ?? _\$${model.name}Document.defaultModelAdapter, accessQuery: accessQuery ?? _\$${model.name}Document.defaultModelAccessQuery, validationQueries: permissionQueries?.toValidationQueries(\"${path.path}\") ?? _\$${model.name}Document.defaultPermissionAccessQueries?.toValidationQueries(\"${path.path}\"), ));",
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
              ..returns = Reference("_\$_${model.name}CollectionQuery")
              ..body = Code(
                "return _\$_${model.name}CollectionQuery(CollectionModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter ?? _\$${model.name}Collection.defaultModelAdapter, accessQuery: accessQuery ?? _\$${model.name}Collection.defaultModelAccessQuery, validationQueries: permissionQueries?.toValidationQueries(\"${path.path}\") ?? _\$${model.name}Collection.defaultPermissionAccessQueries?.toValidationQueries(\"${path.path}\"), ));",
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
        ..extend = Reference("ModelQueryBase<_\$${model.name}Collection>")
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
              ..returns = Reference("_\$${model.name}Collection Function()")
              ..body = Code(
                "() => _\$${model.name}Collection(modelQuery)",
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
              ..name = "collectionGroup"
              ..lambda = true
              ..returns = Reference("_\$_${model.name}CollectionQuery")
              ..body = Code(
                  "_\$_${model.name}CollectionQuery(modelQuery.collectionGroup())"),
          ),
          Method(
            (m) => m
              ..name = "reset"
              ..lambda = true
              ..returns = Reference("_\$_${model.name}CollectionQuery")
              ..body =
                  Code("_\$_${model.name}CollectionQuery(modelQuery.reset())"),
          ),
          Method(
            (m) => m
              ..name = "uid"
              ..type = MethodType.getter
              ..lambda = true
              ..returns = Reference(
                "StringModelQuerySelector<_\$_${model.name}CollectionQuery>",
              )
              ..body = Code(
                "StringModelQuerySelector<_\$_${model.name}CollectionQuery>(key: \"@uid\", toQuery: _toQuery, modelQuery: modelQuery)",
              ),
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
                  "${_querySelectorClass(param, "_\$_${model.name}CollectionQuery")}(key: \"${param.jsonKey}\", toQuery: _toQuery, modelQuery: modelQuery)",
                ),
            );
          }),
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
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "uid"
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
                    "return DocumentModelQuery( \"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$_${m.group(1)?.toCamelCase() ?? ""}")}/\${path.trimQuery().trimString(\"/\")}\", adapter: adapter, );",
                  ),
              )
            ],
          ),
      ),
      Class(
        (c) => c
          ..name = "_\$${model.name}MirrorInitialCollection"
          ..annotations.addAll([const Reference("immutable")])
          ..extend = Reference("ModelInitialCollection<${model.name}>")
          ..mixins.addAll([
            if (searchable.isNotEmpty)
              Reference("SearchableInitialCollectionMixin<${model.name}>"),
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
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "_id"
                      ..type = const Reference("Object"),
                  ),
                ])
                ..returns = Reference("_\$_${model.name}MirrorDocumentQuery")
                ..body = Code(
                  "return _\$_${model.name}MirrorDocumentQuery(DocumentModelQuery(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$_id\", adapter: adapter ?? _\$${model.name}Document.defaultModelAdapter, accessQuery: accessQuery ?? _\$${model.name}Document.defaultModelAccessQuery, validationQueries: permissionQueries?.toValidationQueries(\"${mirror.path}\") ?? _\$${model.name}Document.defaultPermissionAccessQueries?.toValidationQueries(\"${mirror.path}\"), ));",
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
                ..returns = Reference("_\$_${model.name}MirrorCollectionQuery")
                ..body = Code(
                  "return _\$_${model.name}MirrorCollectionQuery(CollectionModelQuery(\"${mirror.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", adapter: adapter ?? _\$${model.name}Collection.defaultModelAdapter, accessQuery: accessQuery ?? _\$${model.name}Collection.defaultModelAccessQuery, validationQueries: permissionQueries?.toValidationQueries(\"${mirror.path}\") ?? _\$${model.name}Collection.defaultPermissionAccessQueries?.toValidationQueries(\"${mirror.path}\"), ));",
                ),
            )
          ]),
      ),
      Class(
        (c) => c
          ..name = "_\$_${model.name}MirrorCollectionQuery"
          ..annotations.addAll([const Reference("immutable")])
          ..extend =
              Reference("ModelQueryBase<_\$${model.name}MirrorCollection>")
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
                    Reference("_\$${model.name}MirrorCollection Function()")
                ..body = Code(
                  "() => _\$${model.name}MirrorCollection(modelQuery)",
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
                ..name = "collectionGroup"
                ..lambda = true
                ..returns = Reference("_\$_${model.name}MirrorCollectionQuery")
                ..body = Code(
                    "_\$_${model.name}MirrorCollectionQuery(modelQuery.collectionGroup())"),
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
            Method(
              (m) => m
                ..name = "uid"
                ..type = MethodType.getter
                ..lambda = true
                ..returns = Reference(
                  "StringModelQuerySelector<_\$_${model.name}MirrorCollectionQuery>",
                )
                ..body = Code(
                  "StringModelQuerySelector<_\$_${model.name}MirrorCollectionQuery>(key: \"@uid\", toQuery: _toQuery, modelQuery: modelQuery)",
                ),
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
                    "${_querySelectorClass(param, "_\$_${model.name}MirrorCollectionQuery")}(key: \"${param.jsonKey}\", toQuery: _toQuery, modelQuery: modelQuery)",
                  ),
              );
            }),
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
          ..name = "_\$${model.name}MirrorInitialCollection"
          ..definition = Reference("_\$${model.name}InitialCollection"),
      )
    ],
  ];
}
