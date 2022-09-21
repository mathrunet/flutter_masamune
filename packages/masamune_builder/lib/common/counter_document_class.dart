part of masamune_builder;

Class counterDocumentClass(ClassModel model, PathModel path) {
  final key = path.path.last();
  if (key.contains("{") || key.contains("}")) {
    throw Exception(
      "When dealing with Counters, variables are not allowed at the bottom of the PATH name. Please exclude {} in your definition.",
    );
  }
  return Class(
    (c) => c
      ..name = "${model.name}Counter"
      ..mixins = ListBuilder([
        const Reference("ChangeNotifier"),
      ])
      ..constructors = ListBuilder([
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
            ..initializers = ListBuilder([
              const Code("_value = value"),
            ])
            ..body = const Code(
              "if(_value is Listenable){(_value as Listenable).addListener(notifyListeners);}",
            ),
        )
      ])
      ..fields = ListBuilder([
        Field(
          (f) => f
            ..name = "_value"
            ..modifier = FieldModifier.final$
            ..type = const Reference("Map<String, dynamic>"),
        ),
      ])
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "${key}Count"
            ..type = MethodType.getter
            ..lambda = true
            ..returns = const Reference("int")
            ..body = Code(
              "((_value[\"${key}Count\"] as num?) ?? 0).toInt()",
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
            ..body = const Code(
              "super.dispose();if (_value is Listenable) {(_value as Listenable).removeListener(notifyListeners);}",
            ),
        ),
      ]),
  );
}
