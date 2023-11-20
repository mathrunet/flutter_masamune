part of '/masamune_builder.dart';

/// Create a class for the controller group query to be used with `ref.page.controller`.
///
/// `ref.page.controller`で使えるようにするためのコントローラーグループクエリーのクラスを作成します。
List<Spec> controllerGroupClass(
  ClassValue model,
  bool autoDisposeWhenUnreferenced,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}Query"
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
              ..lambda = true
              ..annotations.addAll([const Reference("useResult")])
              ..returns = Reference("_\$_${model.name}Query")
              ..optionalParameters.addAll([
                ...model.parameters.map((param) {
                  final type = param.type.toString();
                  final nullable = type.endsWith("?");
                  final functionType = nullable
                      ? "${type.trimStringRight("?")} Function()?"
                      : "${type.trimStringRight("?")} Function()";
                  return Parameter(
                    (p) => p
                      ..required = param.element.isRequired
                      ..named = true
                      ..type = Reference(functionType)
                      ..name = param.name,
                  );
                }),
              ])
              ..body = Code(
                "_\$_${model.name}Query((${[
                  "hashCode",
                  ...model.parameters.map((param) => "${param.name}.hashCode")
                ].join(" ^ ")}).toString(), ${model.parameters.map((param) => "${param.name}:${param.name}").join(",")})",
              ),
          ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$_${model.name}Query"
        ..annotations.addAll([const Reference("immutable")])
        ..extend = Reference("ControllerQueryBase<${model.name}>")
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..constant = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "_name"
                    ..toThis = true,
                )
              ])
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
              ]),
          )
        ])
        ..fields.addAll([
          Field(
            (f) => f
              ..name = "_name"
              ..modifier = FieldModifier.final$
              ..type = const Reference("String"),
          ),
          ...model.parameters.map((param) {
            final type = param.type.toString();
            final nullable = type.endsWith("?");
            final functionType = nullable
                ? "${type.trimStringRight("?")} Function()?"
                : "${type.trimStringRight("?")} Function()";
            return Field(
              (f) => f
                ..name = param.name
                ..modifier = FieldModifier.final$
                ..type = Reference(functionType),
            );
          })
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "call"
              ..annotations.addAll([const Reference("override")])
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "ref"
                    ..type = const Reference("Ref"),
                )
              ])
              ..returns = Reference("${model.name} Function()")
              ..body = Code(
                "return () => ${model.name}(${model.parameters.map((param) => "${param.name}:${param.name}${param.type.toString().endsWith("?") ? "?" : ""}.call()").join(",")});",
              ),
          ),
          Method(
            (m) => m
              ..name = "queryName"
              ..lambda = true
              ..annotations.addAll([const Reference("override")])
              ..type = MethodType.getter
              ..returns = const Reference("String")
              ..body = const Code("_name"),
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
