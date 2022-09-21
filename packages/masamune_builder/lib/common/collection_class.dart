part of masamune_builder;

List<Class> collectionClass(ClassModel model) {
  return [
    Class(
      (c) => c
        ..name = "${model.name}List"
        ..extend = const Reference("ChangeNotifier")
        ..mixins = ListBuilder([
          Reference("ListMixin<${model.name}>"),
        ])
        ..implements = ListBuilder([
          const Reference("BuiltCollectionBase"),
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
              ..optionalParameters = ListBuilder([
                ...model.parameters
                    .where((param) => param.isRelation)
                    .map((param) {
                  return Parameter(
                    (p) => p
                      ..name = param.name
                      ..named = true
                      ..type = Reference(
                        "${param.type.toString().trimString("?")}List?",
                      ),
                  );
                })
              ])
              ..initializers = ListBuilder([
                const Code("_value = value"),
                ...model.parameters
                    .where((param) => param.isRelation)
                    .map((param) {
                  return Code("_${param.name} = ${param.name}");
                }),
              ])
              ..body = Code(
                "if (_value is Listenable) {(_value as Listenable).addListener(notifyListeners);}${model.parameters.where((param) => param.isRelation).map((param) {
                  return Code("_${param.name}?.addListener(notifyListeners);");
                }).join()}",
              ),
          ),
        ])
        ..fields = ListBuilder([
          Field(
            (f) => f
              ..name = "_value"
              ..type = const Reference("List<Map<String, dynamic>>")
              ..modifier = FieldModifier.final$,
          ),
          ...model.parameters.where((param) => param.isRelation).map((param) {
            return Field(
              (f) => f
                ..name = "_${param.name}"
                ..type =
                    Reference("${param.type.toString().trimString("?")}List?")
                ..modifier = FieldModifier.final$,
            );
          }),
        ])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "value"
              ..lambda = true
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("List<Map<String, dynamic>>")
              ..body = const Code("_value"),
          ),
          Method(
            (m) => m
              ..name = "_valueCollection"
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
              ..annotations = ListBuilder([const Reference("override")])
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "index"
                    ..type = const Reference("int"),
                ),
              ])
              ..returns = Reference(model.name.toString())
              ..body = Code(
                "final document = _value[index];return document.to${model.name}(${model.parameters.where((e) => e.isRelation).map((e) => "${e.name}: _${e.name}.firstWhereOrNull((e) => e.uid == document.get(\"${e.name}\", \"\"))").join(",")});",
              ),
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
                "_valueCollection().create(id).to${model.name}()",
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
                "_valueCollection().delete((val) => test.call(val.to${model.name}()))",
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
                "_valueCollection().append(uid, data: data?._valueDocument())",
              ),
          ),
          Method(
            (m) => m
              ..name = "transaction"
              ..lambda = true
              ..returns = const Reference("CollectionTransactionBuilder")
              ..body = Code(
                "_valueCollection().transaction(_linked${model.name}Path)",
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
              ..modifier = MethodModifier.async
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "_valueCollection().fetch(listen)",
              ),
          ),
          Method(
            (m) => m
              ..name = "reload"
              ..lambda = true
              ..modifier = MethodModifier.async
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "_valueCollection().reload()",
              ),
          ),
          Method(
            (m) => m
              ..name = "next"
              ..lambda = true
              ..modifier = MethodModifier.async
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "_valueCollection().next()",
              ),
          ),
          Method(
            (m) => m
              ..name = "canNext"
              ..lambda = true
              ..type = MethodType.getter
              ..returns = const Reference("bool")
              ..body = const Code(
                "_valueCollection().canNext",
              ),
          ),
          Method(
            (m) => m
              ..name = "save"
              ..lambda = true
              ..returns = const Reference("Future<void>")
              ..body = const Code(
                "_valueCollection().save()",
              ),
          ),
          Method(
            (m) => m
              ..name = "loading"
              ..lambda = true
              ..type = MethodType.getter
              ..returns = const Reference("Future<void>?")
              ..body = Code(
                "wait([_valueCollection().loading, ${model.parameters.where((e) => e.isRelation).map((e) {
                  return "_${e.name}?.loading";
                }).join(",")}])",
              ),
          ),
          Method(
            (m) => m
              ..name = "saving"
              ..lambda = true
              ..type = MethodType.getter
              ..returns = const Reference("Future<void>?")
              ..body = const Code(
                "_valueCollection().saving",
              ),
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
  ];
}
