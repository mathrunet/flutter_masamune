part of masamune_builder;

Extension widgetRefDocumentExtensions(ClassModel model, PathModel path) {
  return Extension(
    (e) => e
      ..name = "\$${model.name}WidgetRefDocumentExtensions"
      ..on = const Reference("WidgetRef")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "read${model.name}Document"
            ..optionalParameters = ListBuilder([
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
            ..returns = Reference(model.name.toString())
            ..body = Code(
              "final original = readDocumentModel(\"${path.path.replaceAllMapped(RegExp(r"\{([^\}]+)\}"), (match) {
                return "\$${match.group(1)?.toCamelCase()}";
              })}\",listen: listen,disposable: disposable,); return original.to${model.name}(${model.parameters.where((e) => e.isRelation).map((e) {
                return "${e.name}: read${e.type.toString().trimString("?")}Collection( key: ${e.type.toString().trimString("?")}Keys.uid,isEqualTo: original.get(\"${e.name}\", \"\")).firstOrNull";
              }).join(",")});",
            ),
        ),
        Method(
          (m) => m
            ..name = "watch${model.name}Document"
            ..optionalParameters = ListBuilder([
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
            ..returns = Reference(model.name.toString())
            ..body = Code(
              "final original = watchDocumentModel(\"${path.path.replaceAllMapped(RegExp(r"\{([^\}]+)\}"), (match) {
                return "\$${match.group(1)?.toCamelCase()}";
              })}\",listen: listen,disposable: disposable,); return original.to${model.name}(${model.parameters.where((e) => e.isRelation).map((e) {
                return "${e.name}: watch${e.type.toString().trimString("?")}Collection( key: ${e.type.toString().trimString("?")}Keys.uid,isEqualTo: original.get(\"${e.name}\", \"\")).firstOrNull";
              }).join(",")});",
            ),
        ),
      ]),
  );
}

Extension widgetRefParameterDocumentExtensions(
    ClassModel model, PathModel path) {
  return Extension(
    (e) => e
      ..name = "\$${model.name}WidgetRefDocumentExtensions"
      ..on = const Reference("WidgetRef")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "read${model.name}Document"
            ..requiredParameters = ListBuilder([
              Parameter(
                (p) => p
                  ..name = "id"
                  ..type = const Reference("String"),
              ),
            ])
            ..optionalParameters = ListBuilder([
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
            ..returns = Reference(model.name.toString())
            ..body = Code(
              "final original = readDocumentModel(\"${path.path.replaceAllMapped(RegExp(r"\{([^\}]+)\}"), (match) {
                return "\$${match.group(1)?.toCamelCase()}";
              })}/\$id\",listen: listen,disposable: disposable,); return original.to${model.name}(${model.parameters.where((e) => e.isRelation).map((e) {
                return "${e.name}: read${e.type.toString().trimString("?")}Collection( key: ${e.type.toString().trimString("?")}Keys.uid,isEqualTo: original.get(\"${e.name}\", \"\")).firstOrNull";
              }).join(",")});",
            ),
        ),
        Method(
          (m) => m
            ..name = "watch${model.name}Document"
            ..requiredParameters = ListBuilder([
              Parameter(
                (p) => p
                  ..name = "id"
                  ..type = const Reference("String"),
              ),
            ])
            ..optionalParameters = ListBuilder([
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
            ..returns = Reference(model.name.toString())
            ..body = Code(
              "final original = watchDocumentModel(\"${path.path.replaceAllMapped(RegExp(r"\{([^\}]+)\}"), (match) {
                return "\$${match.group(1)?.toCamelCase()}";
              })}/\$id\",listen: listen,disposable: disposable,); return original.to${model.name}(${model.parameters.where((e) => e.isRelation).map((e) {
                return "${e.name}: watch${e.type.toString().trimString("?")}Collection( key: ${e.type.toString().trimString("?")}Keys.uid,isEqualTo: original.get(\"${e.name}\", \"\")).firstOrNull";
              }).join(",")});",
            ),
        ),
      ]),
  );
}

Extension widgetRefCounterDocumentExtensions(ClassModel model, PathModel path) {
  final parentPath = path.path.parentPath();
  return Extension(
    (e) => e
      ..name = "\$${model.name}WidgetRefCounterDocumentExtensions"
      ..on = const Reference("WidgetRef")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "read${model.name}Counter"
            ..optionalParameters = ListBuilder([
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
            ..returns = Reference("${model.name}Counter")
            ..body = Code(
              "return ${model.name}Counter._(readDocumentModel(\"$parentPath\",listen: listen,disposable: disposable,));",
            ),
        ),
        Method(
          (m) => m
            ..name = "watch${model.name}Counter"
            ..optionalParameters = ListBuilder([
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
            ..returns = Reference("${model.name}Counter")
            ..body = Code(
              "return ${model.name}Counter._(watchDocumentModel(\"$parentPath\",listen: listen,disposable: disposable,));",
            ),
        ),
      ]),
  );
}
