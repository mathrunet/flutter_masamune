part of masamune_builder;

/// Keys for querying the collection.
///
/// The type of the key in [type]. [defaultValue] is the initial value of the key.
///
/// コレクションのクエリー用のキー。
///
/// [type]にキーのタイプ。[defaultValue]にキーの初期値を記述します。
enum CollectionQueryKey {
  /// Query Key.
  ///
  /// クエリーキー。
  key(),

  /// The key of `equalTo`.
  ///
  /// `equalTo`のキー。
  isEqualTo("dynamic"),

  /// Key for `notEqualTo`.
  ///
  /// `notEqualTo`のキー。
  isNotEqualTo("dynamic"),

  /// Key for `lessThanOrEqualTo`.
  ///
  /// `lessThanOrEqualTo`のキー。
  isLessThanOrEqualTo("dynamic"),

  /// Key for `greaterThanOrEqualTo`.
  ///
  /// `greaterThanOrEqualTo`のキー。
  isGreaterThanOrEqualTo("dynamic"),

  /// Key for `arrayContains`.
  ///
  /// `arrayContains`のキー。
  arrayContains("dynamic"),

  /// Key for `arrayContainsAny`.
  ///
  /// `arrayContainsAny`のキー。
  arrayContainsAny("List<dynamic>?"),

  /// Key for `whereIn`.
  ///
  /// `whereIn`のキー。
  whereIn("List<dynamic>?"),

  /// Key for `whereNotIn`.
  ///
  /// `whereNotIn`のキー。
  whereNotIn("List<dynamic>?"),

  /// Key for `geoHash`.
  ///
  /// `geoHash`のキー。
  geoHash("List<String>?"),

  /// Key for `order`.
  ///
  /// `order`のキー。
  order("ModelQueryOrder", "ModelQueryOrder.asc"),

  /// Key for `limit`.
  ///
  /// `limit`のキー。
  limit("int?"),

  /// Key for `orderBy`.
  ///
  /// `orderBy`のキー。
  orderBy("String?");

  /// Keys for querying the collection.
  ///
  /// The type of the key in [type]. [defaultValue] is the initial value of the key.
  ///
  /// コレクションのクエリー用のキー。
  ///
  /// [type]にキーのタイプ。[defaultValue]にキーの初期値を記述します。
  const CollectionQueryKey([this.type, this.defaultValue]);

  /// Key Type.
  ///
  /// キーのタイプ。
  final String? type;

  /// Initial value of the key.
  ///
  /// キーの初期値。
  final String? defaultValue;
}

/// Create a class to automatically create a collection model.
///
/// コレクションモデルを自動作成するためのクラスを作成します。
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
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "_id"
                    ..type = const Reference("Object"),
                ),
              ])
              ..returns = Reference("_\$_${model.name}DocumentQuery")
              ..body = Code(
                "return _\$_${model.name}DocumentQuery(DocumentModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}/\$_id\"));",
              ),
          )
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
              ..returns = Reference("\$${model.name}Document Function(Ref ref)")
              ..body = Code(
                "(ref) => \$${model.name}Document(modelQuery)",
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
                "return _\$_${model.name}CollectionQuery(CollectionModelQuery(\"${path.path.replaceAllMapped(_pathRegExp, (m) => "\$${m.group(1)?.toCamelCase() ?? ""}")}\", ${CollectionQueryKey.values.map((key) => "${key.name}:${key.type == null ? "${key.name}?.name" : key.name}").join(",")}));",
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
              ..returns =
                  Reference("_\$${model.name}Collection Function(Ref ref)")
              ..body = Code(
                "(ref) => _\$${model.name}Collection(modelQuery)",
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
