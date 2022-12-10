part of masamune_builder;

enum CollectionQueryKey {
  key(),
  isEqualTo("dynamic"),
  isNotEqualTo("dynamic"),
  isLessThanOrEqualTo("dynamic"),
  isGreaterThanOrEqualTo("dynamic"),
  arrayContains("dynamic"),
  arrayContainsAny("List<dynamic>?"),
  whereIn("List<dynamic>?"),
  whereNotIn("List<dynamic>?"),
  geoHash("List<String>?"),
  order("ModelQueryOrder", "ModelQueryOrder.asc"),
  limit("int?"),
  orderBy("String?");

  const CollectionQueryKey([this.type, this.defaultValue]);

  final String? type;
  final String? defaultValue;
}

List<Spec> collectionModelClass(
  ClassValue model,
  PathValue path,
) {
  return [
    ...modelClass(model, path),
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
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "id"
                    ..type = const Reference("Object"),
                ),
              ])
              ..returns = Reference("_\$_${model.name}DocumentQuery")
              ..body = Code(
                "return _\$_${model.name}DocumentQuery(DocumentModelQuery(\"${path.path}/\$id\"));",
              ),
          )
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
              ..returns = Reference("_\$${model.name}Document Function()")
              ..body = Code(
                "() => _\$${model.name}Document(modelQuery)",
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
                ...CollectionQueryKey.values.map((key) {
                  return Parameter(
                    (p) => p
                      ..name = key.name
                      ..named = true
                      ..type =
                          Reference(key.type ?? "${model.name}CollectionKey?")
                      ..defaultTo = key.defaultValue == null
                          ? null
                          : Code(key.defaultValue!),
                  );
                })
              ])
              ..returns = Reference("_\$_${model.name}CollectionQuery")
              ..body = Code(
                "return _\$_${model.name}CollectionQuery(CollectionModelQuery(\"${path.path}\", ${CollectionQueryKey.values.map((key) => "${key.name}:${key.type == null ? "${key.name}?.name" : key.name}").join(",")}));",
              ),
          )
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
              ..returns = Reference("_\$${model.name}Collection Function()")
              ..body = Code(
                "() => _\$${model.name}Collection(modelQuery)",
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
    )
  ];
}
