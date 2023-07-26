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
  limitTo,

  /// The method of `reset`.
  ///
  /// `reset`のメソッド。
  reset;

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
              ..type = const Reference("Object?"),
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
              ..type = const Reference("Object?"),
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
              ..type = const Reference("List<Object>?"),
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
              ..type = const Reference("List<String>?"),
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
      case CollectionQueryType.reset:
        return [];
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
      case CollectionQueryType.reset:
        return "$name()";
    }
  }
}

/// Create a class to automatically create a collection model.
///
/// コレクションモデルを自動作成するためのクラスを作成します。
List<Spec> collectionModelClass(
  ClassValue model,
  PathValue path,
  PathValue? mirror,
) {
  final searchable = model.parameters.where((e) => e.isSearchable).toList();

  return [
    Class(
      (c) => c
        ..name = "\$${model.name}Collection"
        ..extend = Reference("CollectionBase<\$${model.name}Document>")
        ..mixins.addAll([
          Reference(
            "FilterableCollectionMixin<\$${model.name}Document, _\$_${model.name}CollectionQuery>",
          ),
          if (searchable.isNotEmpty)
            Reference("SearchableCollectionMixin<\$${model.name}Document>")
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
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "create"
              ..annotations.addAll([const Reference("override")])
              ..lambda = true
              ..returns = Reference("\$${model.name}Document")
              ..optionalParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "id"
                    ..type = const Reference("String?"),
                )
              ])
              ..body = Code("\$${model.name}Document(modelQuery.create(id))"),
          ),
          Method(
            (m) => m
              ..name = "filter"
              ..annotations.addAll([const Reference("override")])
              ..returns =
                  Reference("Future<CollectionBase<\$${model.name}Document>>")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "callback"
                    ..type = Reference(
                        "_\$_${model.name}CollectionQuery Function(_\$_${model.name}CollectionQuery source)"),
                )
              ])
              ..body = Code(
                "final query = callback.call(_\$_${model.name}CollectionQuery(modelQuery)); return replaceQuery((_) => query.modelQuery);",
              ),
          ),
        ]),
    ),
    if (mirror != null) ...[
      Class(
        (c) => c
          ..name = "\$${model.name}MirrorCollection"
          ..extend = Reference("CollectionBase<\$${model.name}MirrorDocument>")
          ..mixins.addAll([
            Reference(
              "FilterableCollectionMixin<\$${model.name}MirrorDocument, _\$_${model.name}MirrorCollectionQuery>",
            ),
            if (searchable.isNotEmpty)
              Reference(
                  "SearchableCollectionMixin<\$${model.name}MirrorDocument>")
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
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "create"
                ..annotations.addAll([const Reference("override")])
                ..lambda = true
                ..returns = Reference("\$${model.name}MirrorDocument")
                ..optionalParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "id"
                      ..type = const Reference("String?"),
                  )
                ])
                ..body = Code(
                    "\$${model.name}MirrorDocument(modelQuery.create(id))"),
            ),
            Method(
              (m) => m
                ..name = "filter"
                ..annotations.addAll([const Reference("override")])
                ..returns = Reference(
                    "Future<CollectionBase<\$${model.name}MirrorDocument>>")
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "callback"
                      ..type = Reference(
                          "_\$_${model.name}MirrorCollectionQuery Function(_\$_${model.name}MirrorCollectionQuery source)"),
                  )
                ])
                ..body = Code(
                  "final query = callback.call(_\$_${model.name}MirrorCollectionQuery(modelQuery)); return replaceQuery((_) => query.modelQuery);",
                ),
            ),
          ]),
      ),
    ],
  ];
}
