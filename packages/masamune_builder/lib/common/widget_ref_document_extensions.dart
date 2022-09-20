part of masamune_builder;

Extension widgetRefDocumentExtensions(ClassModel model) {
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
              "return readDocumentModel(\"\$_${model.name.toCamelCase()}Path\",listen: listen,disposable: disposable,).to${model.name}();",
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
              "return watchDocumentModel(\"\$_${model.name.toCamelCase()}Path\",listen: listen,disposable: disposable,).to${model.name}();",
            ),
        ),
      ]),
  );
}

Extension widgetRefParameterDocumentExtensions(ClassModel model) {
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
              "return readDocumentModel(\"\$_${model.name.toCamelCase()}Path/\$id\",listen: listen,disposable: disposable,).to${model.name}();",
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
              "return watchDocumentModel(\"\$_${model.name.toCamelCase()}Path/\$id\",listen: listen,disposable: disposable,).to${model.name}();",
            ),
        ),
      ]),
  );
}

Extension widgetRefCounterDocumentExtensions(ClassModel model, String path) {
  final parentPath = path.parentPath();
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
