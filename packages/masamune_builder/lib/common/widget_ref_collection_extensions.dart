part of masamune_builder;

List<Parameter> _modelQueryParameters(ClassModel model) => [
      Parameter(
        (p) => p
          ..name = "key"
          ..named = true
          ..type = Reference("${model.name}Keys?"),
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
          ..type = Reference("${model.name}Keys?"),
      ),
    ];

Extension widgetRefCollectionExtensions(ClassModel model, PathModel path) {
  final parameters = _modelQueryParameters(model);
  return Extension(
    (e) => e
      ..name = "\$${model.name}WidgetRefCollectionExtensions"
      ..on = const Reference("WidgetRef")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "read${model.name}Collection"
            ..optionalParameters = ListBuilder([
              ...parameters,
              ...path.parameters.map((param) {
                return Parameter(
                  (p) => p
                    ..name = param.camelCase
                    ..required = true
                    ..named = true
                    ..type = const Reference("String"),
                );
              }),
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
              "final original = readCollectionModel(ModelQuery(\"${path.path.replaceAllMapped(RegExp(r"\{([^\}]+)\}"), (match) {
                return "\$${match.group(1)?.toCamelCase()}";
              })}\",${parameters.map((e) => e.name == "key" || e.name == "orderBy" ? "${e.name}: ${e.name}?.id" : "${e.name}: ${e.name}").join(",")}).value,listen: listen,disposable: disposable,);return ${model.name}List._(original,${model.parameters.where((param) => param.isRelation).map((param) {
                return "${param.name}: read${param.type.toString().trimString("?")}Collection( key: ${param.type.toString().trimString("?")}Keys.uid, whereIn: original.map((e) => e.get(\"${param.name}\", \"\")).removeEmpty().distinct(),listen: listen, disposable: disposable,)";
              }).join(",")});",
            ),
        ),
        Method(
          (m) => m
            ..name = "watch${model.name}Collection"
            ..optionalParameters = ListBuilder([
              ..._modelQueryParameters(model),
              ...path.parameters.map((param) {
                return Parameter(
                  (p) => p
                    ..name = param.camelCase
                    ..required = true
                    ..named = true
                    ..type = const Reference("String"),
                );
              }),
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
              "final original = watchCollectionModel(ModelQuery(\"${path.path.replaceAllMapped(RegExp(r"\{([^\}]+)\}"), (match) {
                return "\$${match.group(1)?.toCamelCase()}";
              })}\",${parameters.map((e) => e.name == "key" || e.name == "orderBy" ? "${e.name}: ${e.name}?.id" : "${e.name}: ${e.name}").join(",")}).value,listen: listen,disposable: disposable,);return ${model.name}List._(original,${model.parameters.where((param) => param.isRelation).map((param) {
                return "${param.name}: watch${param.type.toString().trimString("?")}Collection( key: ${param.type.toString().trimString("?")}Keys.uid, whereIn: original.map((e) => e.get(\"${param.name}\", \"\")).removeEmpty().distinct(),listen: listen, disposable: disposable,)";
              }).join(",")});",
            ),
        ),
      ]),
  );
}
