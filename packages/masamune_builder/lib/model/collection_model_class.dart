part of masamune_builder;

/// The type of query method for the collection.
///
/// コレクションのクエリーメソッドのタイプ。
enum CollectionQueryType {
  /// The method of `equal`.
  ///
  /// `equal`のメソッド。
  equal,

  /// The method for `notEqual`.
  ///
  /// `notEqual`のメソッド。
  notEqual,

  /// The method  for `lessThan`.
  ///
  /// `lessThan`のメソッド。
  lessThan,

  /// The method  for `greaterThan`.
  ///
  /// `greaterThan`のメソッド。
  greaterThan,

  /// The method  for `lessThanOrEqual`.
  ///
  /// `lessThanOrEqual`のメソッド。
  lessThanOrEqual,

  /// The method  for `greaterThanOrEqual`.
  ///
  /// `greaterThanOrEqual`のメソッド。
  greaterThanOrEqual,

  /// The method  for `contains`.
  ///
  /// `contains`のメソッド。
  contains,

  /// The method  for `containsAny`.
  ///
  /// `containsAny`のメソッド。
  containsAny,

  /// The method  for `where`.
  ///
  /// `where`のメソッド。
  where,

  /// The method  for `notWhere`.
  ///
  /// `notWhere`のメソッド。
  notWhere,

  /// The method  for `isNull`.
  ///
  /// `isNull`のメソッド。
  isNull,

  /// The method  for `isNotNull`.
  ///
  /// `isNotNull`のメソッド。
  isNotNull,

  /// The method  for `geo`.
  ///
  /// `geo`のメソッド。
  geo,

  /// The method  for `orderByAsc`.
  ///
  /// `orderByAsc`のメソッド。
  orderByAsc,

  /// The method  for `orderByDesc`.
  ///
  /// `orderByDesc`のメソッド。
  orderByDesc,

  /// The method  for `limitTo`.
  ///
  /// `limitTo`のメソッド。
  limitTo;

  /// Gets the parameters for the input of the method.
  ///
  /// Specify the name of the key in [keyName].
  ///
  /// メソッドの入力用のパラメーターを取得します。
  ///
  /// [keyName]でキーの名前を指定してください。
  List<Parameter> parameters(String keyName) {
    switch (this) {
      case CollectionQueryType.equal:
      case CollectionQueryType.notEqual:
      case CollectionQueryType.contains:
        return [
          Parameter(
            (p) => p
              ..name = "key"
              ..type = Reference(keyName),
          ),
          Parameter(
            (p) => p
              ..name = "value"
              ..type = const Reference("Object"),
          ),
        ];
      case CollectionQueryType.lessThan:
      case CollectionQueryType.greaterThan:
      case CollectionQueryType.lessThanOrEqual:
      case CollectionQueryType.greaterThanOrEqual:
        return [
          Parameter(
            (p) => p
              ..name = "key"
              ..type = Reference(keyName),
          ),
          Parameter(
            (p) => p
              ..name = "value"
              ..type = const Reference("num"),
          ),
        ];
      case CollectionQueryType.containsAny:
      case CollectionQueryType.where:
      case CollectionQueryType.notWhere:
        return [
          Parameter(
            (p) => p
              ..name = "key"
              ..type = Reference(keyName),
          ),
          Parameter(
            (p) => p
              ..name = "values"
              ..type = const Reference("List<Object>"),
          ),
        ];
      case CollectionQueryType.geo:
        return [
          Parameter(
            (p) => p
              ..name = "key"
              ..type = Reference(keyName),
          ),
          Parameter(
            (p) => p
              ..name = "geoHash"
              ..type = const Reference("List<String>"),
          ),
        ];
      case CollectionQueryType.isNull:
      case CollectionQueryType.isNotNull:
      case CollectionQueryType.orderByAsc:
      case CollectionQueryType.orderByDesc:
        return [
          Parameter(
            (p) => p
              ..name = "key"
              ..type = Reference(keyName),
          ),
        ];
      case CollectionQueryType.limitTo:
        return [
          Parameter(
            (p) => p
              ..name = "value"
              ..type = const Reference("int"),
          ),
        ];
    }
  }

  /// Outputs the code for the method.
  ///
  /// メソッド用のコードを出力します。
  String get methodCode {
    switch (this) {
      case CollectionQueryType.equal:
      case CollectionQueryType.notEqual:
      case CollectionQueryType.contains:
      case CollectionQueryType.lessThan:
      case CollectionQueryType.greaterThan:
      case CollectionQueryType.lessThanOrEqual:
      case CollectionQueryType.greaterThanOrEqual:
        return "$name(key.name, value)";
      case CollectionQueryType.containsAny:
      case CollectionQueryType.where:
      case CollectionQueryType.notWhere:
        return "$name(key.name, values)";
      case CollectionQueryType.geo:
        return "$name(key.name, geoHash)";
      case CollectionQueryType.isNull:
      case CollectionQueryType.isNotNull:
      case CollectionQueryType.orderByAsc:
      case CollectionQueryType.orderByDesc:
        return "$name(key.name)";
      case CollectionQueryType.limitTo:
        return "$name(value)";
    }
  }
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
    )
  ];
}
