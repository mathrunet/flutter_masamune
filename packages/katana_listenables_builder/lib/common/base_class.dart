part of '/katana_listenables_builder.dart';

/// Create a base class.
///
/// Pass the value for the query to [model].
///
/// ベースを作成します。
///
/// [model]にクエリー用の値を渡します。
List<Spec> baseClass(
  ClassValue model,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}"
        ..abstract = true
        ..implements.addAll([
          const Reference("Listenable"),
        ])
        ..methods.addAll([
          ...model.parameters.map((param) {
            return Method(
              (m) => m
                ..name = param.name
                ..type = MethodType.getter
                ..lambda = true
                ..returns = Reference(
                  "${param.type.toString().trimStringRight("?")}${param.required ? "" : "?"}",
                )
                ..body = const Code("throw UnimplementedError()"),
            );
          }),
          Method(
            (m) => m
              ..name = "addListener"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("void")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "listener"
                    ..type = const Reference("VoidCallback"),
                )
              ])
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "removeListener"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("void")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "listener"
                    ..type = const Reference("VoidCallback"),
                )
              ])
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "notifyListeners"
              ..returns = const Reference("void")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "dispose"
              ..returns = const Reference("void")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "hasListeners"
              ..type = MethodType.getter
              ..returns = const Reference("bool")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "toString"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("String")
              ..body = Code(
                "return \"\$runtimeType(${model.parameters.map((e) => "${e.name}: \$${e.name}").join(", ")})\";",
              ),
          ),
        ]),
    ),
    if (model.existUnderbarConstructor) ...[
      Class(
        (c) => c
          ..name = "_${model.name}"
          ..extend = Reference(model.name)
          ..mixins.addAll([
            if (!model.existChangeNotifierMixin)
              const Reference("ChangeNotifier"),
          ])
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..optionalParameters.addAll([
                  ...model.parameters.map((param) {
                    return Parameter(
                      (p) => p
                        ..name = param.name
                        ..toThis = true
                        ..named = true
                        ..required = param.required,
                    );
                  }),
                ])
                ..initializers.addAll([const Code("super._()")])
                ..body = Code(
                  model.parameters
                      .map(
                        (e) =>
                            "if(${e.name} is Listenable){${e.name}${e.required ? "" : "?"}.addListener(_handledOnUpdate);}",
                      )
                      .join("\n"),
                ),
            ),
          ])
          ..fields.addAll([
            ...model.parameters.map((param) {
              return Field(
                (f) => f
                  ..name = param.name
                  ..modifier = FieldModifier.final$
                  ..annotations.addAll([const Reference("override")])
                  ..type = Reference(
                    "${param.type.toString().trimStringRight("?")}${param.required ? "" : "?"}",
                  ),
              );
            })
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "dispose"
                ..annotations.addAll([const Reference("override")])
                ..returns = const Reference("void")
                ..body = Code(
                  "super.dispose(); ${model.parameters.map((e) => "if(${e.name} is Listenable){${e.name}${e.required ? "" : "?"}.removeListener(_handledOnUpdate); ${e.name}${e.required ? "" : "?"}.dispose();}").join("\n")}",
                ),
            ),
            Method(
              (m) => m
                ..name = "_handledOnUpdate"
                ..returns = const Reference("void")
                ..body = const Code(
                  "notifyListeners();",
                ),
            ),
          ]),
      ),
    ] else ...[
      Class(
        (c) => c
          ..name = "_${model.name}"
          ..mixins.addAll([
            const Reference("ChangeNotifier"),
          ])
          ..implements.addAll([
            Reference(model.name),
          ])
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..optionalParameters.addAll([
                  ...model.parameters.map((param) {
                    return Parameter(
                      (p) => p
                        ..name = param.name
                        ..toThis = true
                        ..named = true
                        ..required = param.required,
                    );
                  }),
                ])
                ..body = Code(
                  model.parameters
                      .map(
                        (e) =>
                            "if(${e.name} is Listenable){${e.name}${e.required ? "" : "?"}.addListener(_handledOnUpdate);}",
                      )
                      .join("\n"),
                ),
            ),
          ])
          ..fields.addAll([
            ...model.parameters.map((param) {
              return Field(
                (f) => f
                  ..name = param.name
                  ..annotations.addAll([const Reference("override")])
                  ..modifier = FieldModifier.final$
                  ..type = Reference(
                    "${param.type.toString().trimStringRight("?")}${param.required ? "" : "?"}",
                  ),
              );
            })
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "dispose"
                ..annotations.addAll([const Reference("override")])
                ..returns = const Reference("void")
                ..body = Code(
                  "super.dispose(); ${model.parameters.map((e) => "if(${e.name} is Listenable){${e.name}${e.required ? "" : "?"}.removeListener(_handledOnUpdate); ${e.name}${e.required ? "" : "?"}.dispose();}").join("\n")}",
                ),
            ),
            Method(
              (m) => m
                ..name = "_handledOnUpdate"
                ..returns = const Reference("void")
                ..body = const Code(
                  "notifyListeners();",
                ),
            ),
          ]),
      ),
    ],
  ];
}
