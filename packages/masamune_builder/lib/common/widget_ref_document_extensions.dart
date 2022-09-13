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
              "return readDocumentModel(\"\$_path/\$id\",listen: listen,disposable: disposable,).to${model.name}();",
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
              "return watchDocumentModel(\"\$_path/\$id\",listen: listen,disposable: disposable,).to${model.name}();",
            ),
        ),
      ]),
  );
}
