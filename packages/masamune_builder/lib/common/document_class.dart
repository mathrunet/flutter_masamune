part of masamune_builder;

List<Class> documentClass(ClassModel model) {
  return [
    // _Class
    Class(
      (c) => c
        ..name = "_${model.name}"
        ..extend = Reference(model.name.toString())
        ..mixins = ListBuilder([
          const Reference("ChangeNotifier"),
        ])
        ..constructors = ListBuilder([
          Constructor(
            (c) => c
              ..factory = true
              ..optionalParameters = ListBuilder([
                ...model.parameters.map((param) {
                  return Parameter(
                    (p) => p
                      ..name = param.name
                      ..named = true
                      ..type = Reference(
                        "${param.type.toString().trimString("?")}?",
                      ),
                  );
                }),
              ])
              ..lambda = true
              ..body = Code(
                "_${model.name}._(_${model.name.toCamelCase()}Convert(${model.parameters.map((e) => "${e.name}:${e.name}").join(",")}),${model.parameters.where((e) => e.isRelation).map((e) => "${e.name}:${e.name}").join(",")})",
              ),
          ),
          Constructor(
            (c) => c
              ..name = "_"
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = const Reference("Map<String, dynamic>"),
                )
              ])
              ..optionalParameters = ListBuilder([
                ...model.parameters
                    .where((param) => param.isRelation)
                    .map((param) {
                  return Parameter(
                    (p) => p
                      ..name = param.name
                      ..named = true
                      ..type = Reference(
                        "${param.type.toString().trimString("?")}?",
                      ),
                  );
                }),
              ])
              ..initializers = ListBuilder([
                const Code("_value = value"),
                const Code("super._()"),
              ])
              ..body = Code(
                "${model.parameters.where((e) => e.isRelation).map((e) => "_${e.name} = ${e.name};").join()}if (_value is Listenable) {(_value as Listenable).addListener(notifyListeners);}${model.parameters.where((param) => param.isRelation).map((param) {
                  return Code(
                    "_${param.name}?.addListener(notifyListeners);",
                  );
                }).join()}",
              ),
          )
        ])
        ..fields = ListBuilder([
          Field(
            (f) => f
              ..name = "_value"
              ..modifier = FieldModifier.final$
              ..annotations = ListBuilder([const Reference("override")])
              ..type = const Reference("Map<String, dynamic>"),
          ),
        ])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "fetch"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..optionalParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "listen"
                    ..type = const Reference("bool")
                    ..defaultTo = const Code("true"),
                ),
              ])
              ..returns = const Reference("Future<void>")
              ..body = const Code("_valueDocument().fetch(listen)"),
          ),
          Method(
            (m) => m
              ..name = "reload"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("Future<void>")
              ..body = const Code("_valueDocument().reload()"),
          ),
          Method(
            (m) => m
              ..name = "save"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("Future<void>")
              ..body = const Code("_valueDocument().save()"),
          ),
          Method(
            (m) => m
              ..name = "delete"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("Future<void>")
              ..body = const Code("_valueDocument().delete()"),
          ),
          Method(
            (m) => m
              ..name = "transaction"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("DocumentTransactionBuilder")
              ..body = const Code("_valueDocument().transaction()"),
          ),
          Method(
            (m) => m
              ..name = "loading"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("Future<void>?")
              ..body = Code(
                "wait([_valueDocument().loading, ${model.parameters.where((e) => e.isRelation).map((e) => "_${e.name}?.loading").join(",")}])",
              ),
          ),
          Method(
            (m) => m
              ..name = "saving"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("Future<void>?")
              ..body = const Code("_valueDocument().saving"),
          ),
          Method(
            (m) => m
              ..name = "dispose"
              ..returns = const Reference("void")
              ..annotations = ListBuilder([
                const Reference("override"),
                const Reference("mustCallSuper"),
              ])
              ..body = Code(
                "super.dispose();if (_value is Listenable) {(_value as Listenable).removeListener(notifyListeners);}${model.parameters.where((param) => param.isRelation).map((param) {
                  return Code(
                    "_${param.name}?.removeListener(notifyListeners);",
                  );
                }).join()}",
              ),
          ),
        ]),
    ),
    // _$Class
    Class(
      (c) => c
        ..name = "_\$${model.name}"
        ..implements = ListBuilder([
          const Reference("ChangeNotifier"),
          const Reference("BuiltDocumentBase"),
        ])
        ..abstract = true
        ..fields = ListBuilder([
          ...model.parameters.where((param) => param.isRelation).map((param) {
            return Field(
              (f) => f
                ..name = "_${param.name}"
                ..type = Reference("${param.type.toString().trimString("?")}?"),
            );
          }),
        ])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "uid"
              ..lambda = true
              ..type = MethodType.getter
              ..returns = const Reference("String")
              ..body = Code(
                "_value[${model.name}Keys.uid.id] ?? \"\"",
              ),
          ),
          ...model.parameters.expand((param) {
            if (param.isRelation) {
              return [
                Method(
                  (m) => m
                    ..name = param.name
                    ..lambda = true
                    ..type = MethodType.getter
                    ..returns = Reference(
                      "${param.type.toString().trimString("?")}?",
                    )
                    ..body = Code(
                      "_${param.name}",
                    ),
                ),
                Method(
                  (m) => m
                    ..name = param.name
                    ..type = MethodType.setter
                    ..requiredParameters = ListBuilder([
                      Parameter(
                        (p) => p
                          ..name = "val"
                          ..type = Reference(
                            "${param.type.toString().trimString("?")}?",
                          ),
                      )
                    ])
                    ..body = Code(
                      "if(val == null){return;}_${param.name} = val;_value[${model.name}Keys.${param.name}.id] = val.uid;",
                    ),
                ),
              ];
            } else {
              return [
                Method(
                  (m) => m
                    ..name = param.name
                    ..lambda = true
                    ..type = MethodType.getter
                    ..returns = Reference(param.type.toString())
                    ..body = Code(
                      "_${model.name.toCamelCase()}Converter.convertFrom<${param.type}>(_value[${model.name}Keys.${param.name}.id]) ?? _${param.name}",
                    ),
                ),
                Method(
                  (m) => m
                    ..name = param.name
                    ..lambda = true
                    ..type = MethodType.setter
                    ..requiredParameters = ListBuilder([
                      Parameter(
                        (p) => p
                          ..name = "val"
                          ..type = Reference(param.type.toString()),
                      )
                    ])
                    ..body = Code(
                      "_value[${model.name}Keys.${param.name}.id] = _${model.name.toCamelCase()}Converter.convertTo(val)",
                    ),
                ),
                Method(
                  (m) => m
                    ..name = "_${param.name}"
                    ..lambda = true
                    ..type = MethodType.getter
                    ..returns = Reference(param.type.toString())
                    ..body = Code(_defaultValue(param)),
                )
              ];
            }
          }),
          Method(
            (m) => m
              ..name = "value"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("Map<String, dynamic>")
              ..body = const Code("_value"),
          ),
          Method(
            (m) => m
              ..name = "_value"
              ..type = MethodType.getter
              ..lambda = true
              ..returns = const Reference("Map<String, dynamic>")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "_valueDocument"
              ..lambda = true
              ..returns = const Reference("DynamicDocumentModel")
              ..body = const Code("_value as DynamicDocumentModel"),
          ),
          Method(
            (m) => m
              ..name = "addListener"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "listener"
                    ..type = const Reference("VoidCallback"),
                ),
              ])
              ..returns = const Reference("void")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "removeListener"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "listener"
                    ..type = const Reference("VoidCallback"),
                ),
              ])
              ..returns = const Reference("void")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "notifyListeners"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("void")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "hasListeners"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("bool")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "fetch"
              ..lambda = true
              ..optionalParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "listen"
                    ..type = const Reference("bool")
                    ..defaultTo = const Code("true"),
                ),
              ])
              ..returns = const Reference("Future<void>")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "reload"
              ..lambda = true
              ..returns = const Reference("Future<void>")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "save"
              ..lambda = true
              ..returns = const Reference("Future<void>")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "delete"
              ..lambda = true
              ..returns = const Reference("Future<void>")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "transaction"
              ..lambda = true
              ..returns = const Reference("DocumentTransactionBuilder")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "loading"
              ..lambda = true
              ..type = MethodType.getter
              ..returns = const Reference("Future<void>?")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "saving"
              ..lambda = true
              ..type = MethodType.getter
              ..returns = const Reference("Future<void>?")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "dispose"
              ..lambda = true
              ..annotations = ListBuilder([
                const Reference("override"),
                const Reference("mustCallSuper"),
              ])
              ..returns = const Reference("void")
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "toString"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("String")
              ..body = const Code("_value.toString()"),
          ),
        ]),
    ),
  ];
}
