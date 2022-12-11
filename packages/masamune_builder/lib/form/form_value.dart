part of masamune_builder;

List<Spec> formValueClass(
  ClassValue model,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}FormQuery"
        ..annotations.addAll([const Reference("immutable")])
        ..constructors.addAll([
          Constructor(
            (c) => c..constant = true,
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "call"
              ..annotations.addAll([const Reference("useResult")])
              ..returns = Reference("_\$_${model.name}FormQuery")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = Reference(model.name),
                )
              ])
              ..body = Code(
                "return _\$_${model.name}FormQuery(value);",
              ),
          )
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$_${model.name}FormQuery"
        ..annotations.addAll([const Reference("immutable")])
        ..extend =
            Reference("ControllerQueryBase<FormController<${model.name}>>")
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..constant = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..toThis = true,
                )
              ]),
          )
        ])
        ..fields.addAll([
          Field(
            (f) => f
              ..name = "value"
              ..modifier = FieldModifier.final$
              ..type = Reference(model.name),
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "call"
              ..lambda = true
              ..annotations.addAll([const Reference("override")])
              ..returns = Reference("FormController<${model.name}> Function()")
              ..body = const Code(
                "() => FormController(value)",
              ),
          ),
          Method(
            (m) => m
              ..name = "name"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("String")
              ..body = const Code("value.hashCode.toString()"),
          ),
        ]),
    ),
  ];
}
