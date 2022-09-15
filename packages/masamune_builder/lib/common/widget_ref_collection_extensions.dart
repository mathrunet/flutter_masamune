part of masamune_builder;

final List<Parameter> _modelQueryParameters = [
  Parameter(
    (p) => p
      ..name = "key"
      ..named = true
      ..type = const Reference("String?"),
  ),
  Parameter(
    (p) => p
      ..name = "isEqualTo"
      ..named = true
      ..type = const Reference("dynamic"),
  ),
  Parameter(
    (p) => p
      ..name = "isNotEqualTo"
      ..named = true
      ..type = const Reference("dynamic"),
  ),
  Parameter(
    (p) => p
      ..name = "isLessThanOrEqualTo"
      ..named = true
      ..type = const Reference("dynamic"),
  ),
  Parameter(
    (p) => p
      ..name = "isGreaterThanOrEqualTo"
      ..named = true
      ..type = const Reference("dynamic"),
  ),
  Parameter(
    (p) => p
      ..name = "arrayContains"
      ..named = true
      ..type = const Reference("dynamic"),
  ),
  Parameter(
    (p) => p
      ..name = "arrayContainsAny"
      ..named = true
      ..type = const Reference("List<dynamic>?"),
  ),
  Parameter(
    (p) => p
      ..name = "whereIn"
      ..named = true
      ..type = const Reference("List<dynamic>?"),
  ),
  Parameter(
    (p) => p
      ..name = "whereNotIn"
      ..named = true
      ..type = const Reference("List<dynamic>?"),
  ),
  Parameter(
    (p) => p
      ..name = "geoHash"
      ..named = true
      ..type = const Reference("List<String>?"),
  ),
  Parameter(
    (p) => p
      ..name = "order"
      ..named = true
      ..defaultTo = const Code("ModelQueryOrder.asc")
      ..type = const Reference("ModelQueryOrder"),
  ),
  Parameter(
    (p) => p
      ..name = "limit"
      ..named = true
      ..type = const Reference("int?"),
  ),
  Parameter(
    (p) => p
      ..name = "orderBy"
      ..named = true
      ..type = const Reference("String?"),
  ),
];

Extension widgetRefCollectionExtensions(ClassModel model) {
  return Extension(
    (e) => e
      ..name = "\$${model.name}WidgetRefCollectionExtensions"
      ..on = const Reference("WidgetRef")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "read${model.name}Collection"
            ..optionalParameters = ListBuilder([
              ..._modelQueryParameters,
              Parameter(
                (p) => p
                  ..name = "listen"
                  ..named = true
                  ..defaultTo = const Code("true")
                  ..type = const Reference("bool"),
              ),
              Parameter(
                (p) => p
                  ..name = "disposable"
                  ..named = true
                  ..defaultTo = const Code("true")
                  ..type = const Reference("bool"),
              ),
            ])
            ..returns = Reference("${model.name}List")
            ..body = Code(
              "return ${model.name}List._(readCollectionModel(ModelQuery(_${model.name.toCamelCase()}Path,key: key,isEqualTo: isEqualTo,isNotEqualTo: isNotEqualTo,isLessThanOrEqualTo: isLessThanOrEqualTo,isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,arrayContains: arrayContains,arrayContainsAny: arrayContainsAny,whereIn: whereIn,whereNotIn: whereNotIn,geoHash: geoHash,order: order,limit: limit,orderBy: orderBy,).value,listen: listen,disposable: disposable,),);",
            ),
        ),
        Method(
          (m) => m
            ..name = "watch${model.name}Collection"
            ..optionalParameters = ListBuilder([
              ..._modelQueryParameters,
              Parameter(
                (p) => p
                  ..name = "listen"
                  ..named = true
                  ..defaultTo = const Code("true")
                  ..type = const Reference("bool"),
              ),
              Parameter(
                (p) => p
                  ..name = "disposable"
                  ..named = true
                  ..defaultTo = const Code("true")
                  ..type = const Reference("bool"),
              ),
            ])
            ..returns = Reference("${model.name}List")
            ..body = Code(
              "return ${model.name}List._(watchCollectionModel(ModelQuery(_${model.name.toCamelCase()}Path,key: key,isEqualTo: isEqualTo,isNotEqualTo: isNotEqualTo,isLessThanOrEqualTo: isLessThanOrEqualTo,isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,arrayContains: arrayContains,arrayContainsAny: arrayContainsAny,whereIn: whereIn,whereNotIn: whereNotIn,geoHash: geoHash,order: order,limit: limit,orderBy: orderBy,).value,listen: listen,disposable: disposable,),);",
            ),
        ),
      ]),
  );
}
