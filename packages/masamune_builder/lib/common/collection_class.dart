part of masamune_builder;

List<Class> collectionClass(ClassModel model) {
  return [
    Class(
      (c) => c
        ..name = "${model.name}List"
        ..mixins = ListBuilder([
          Reference("ListMixin<${model.name}>"),
        ])
        ..constructors = ListBuilder([
          Constructor(
            (c) => c
              ..name = "_"
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = const Reference("List<Map<String, dynamic>>"),
                )
              ])
              ..initializers = ListBuilder([
                const Code("_value = value"),
              ]),
          ),
        ])
        ..fields = ListBuilder([
          Field(
            (f) => f
              ..name = "_value"
              ..type = const Reference("List<Map<String, dynamic>>")
              ..modifier = FieldModifier.final$,
          )
        ])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "value"
              ..lambda = true
              ..returns = const Reference("List<Map<String, dynamic>>")
              ..body = const Code("_value"),
          ),
          Method(
            (m) => m
              ..name = "collection"
              ..lambda = true
              ..returns = const Reference("DynamicCollectionModel")
              ..body = const Code("_value as DynamicCollectionModel"),
          ),
          Method(
            (m) => m
              ..name = "length"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("int")
              ..body = const Code("_value.length"),
          ),
          Method(
            (m) => m
              ..name = "length"
              ..lambda = true
              ..type = MethodType.setter
              ..annotations = ListBuilder([const Reference("override")])
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "newLength"
                    ..type = const Reference("int"),
                )
              ])
              ..body = const Code("_value.length = newLength"),
          ),
          Method(
            (m) => m
              ..name = "operator []"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "index"
                    ..type = const Reference("int"),
                ),
              ])
              ..returns = Reference(model.name.toString())
              ..body = Code("_value[index].to${model.name}()"),
          ),
          Method(
            (m) => m
              ..name = "operator []="
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "index"
                    ..type = const Reference("int"),
                ),
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = Reference(model.name.toString()),
                ),
              ])
              ..returns = const Reference("void")
              ..body = const Code("_value[index] = value.value()"),
          ),
          Method(
            (m) => m
              ..name = "create"
              ..lambda = true
              ..optionalParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "id"
                    ..type = const Reference("String?"),
                ),
              ])
              ..returns = Reference(model.name.toString())
              ..body = Code(
                "collection().create(id).to${model.name}()",
              ),
          ),
          Method(
            (m) => m
              ..name = "delete"
              ..lambda = true
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "test"
                    ..type = Reference(
                      "bool Function(${model.name} value)",
                    ),
                ),
              ])
              ..returns = const Reference("Future<void>")
              ..body = Code(
                "collection().delete((val) => test.call(val.to${model.name}()))",
              ),
          ),
          Method(
            (m) => m
              ..name = "append"
              ..lambda = true
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "uid"
                    ..type = const Reference("String"),
                ),
              ])
              ..optionalParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "data"
                    ..named = true
                    ..type = Reference("${model.name.toString()}?"),
                ),
              ])
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "collection().append(uid, data: data?.document())",
              ),
          ),
          Method(
            (m) => m
              ..name = "fetch"
              ..lambda = true
              ..optionalParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "listen"
                    ..defaultTo = const Code("true")
                    ..type = const Reference("bool"),
                ),
              ])
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "collection().fetch(listen)",
              ),
          ),
          Method(
            (m) => m
              ..name = "reload"
              ..lambda = true
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "collection().reload()",
              ),
          ),
          Method(
            (m) => m
              ..name = "next"
              ..lambda = true
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "collection().next()",
              ),
          ),
          Method(
            (m) => m
              ..name = "canNext"
              ..lambda = true
              ..type = MethodType.getter
              ..returns = const Reference("bool")
              ..body = const Code(
                "collection().canNext",
              ),
          ),
          Method(
            (m) => m
              ..name = "save"
              ..lambda = true
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "collection().save()",
              ),
          ),
        ]),
    ),
  ];
}
