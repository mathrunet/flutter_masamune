part of '/masamune_builder.dart';

/// Create a FormController query class for use with `ref.page.controller`.
///
/// `ref.page.controller`で使えるようにするためのFormControllerクエリーのクラスを作成します。
List<Spec> formValueClass(
  ClassValue model,
  bool autoDisposeWhenUnreferenced,
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
        ..extend = Reference("FormControllerQueryBase<${model.name}>")
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
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "ref"
                    ..type = const Reference("Ref"),
                )
              ])
              ..returns = Reference("FormController<${model.name}> Function()")
              ..body = const Code(
                "() => FormController(value)",
              ),
          ),
          Method(
            (m) => m
              ..name = "queryName"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("String")
              ..body = const Code("value.hashCode.toString()"),
          ),
          Method(
            (m) => m
              ..name = "autoDisposeWhenUnreferenced"
              ..lambda = true
              ..type = MethodType.getter
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("bool")
              ..body = Code(autoDisposeWhenUnreferenced ? "true" : "false"),
          ),
        ]),
    ),
  ];
}
