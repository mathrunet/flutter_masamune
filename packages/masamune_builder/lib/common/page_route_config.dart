part of masamune_builder;

Field pageRouteConfig(ClassModel model, PathModel path) {
  return Field(
    (f) => f
      ..name = "${model.name.toCamelCase()}RouteConfig"
      ..modifier = FieldModifier.final$
      ..type = const Reference("Map<String, RouteConfig>")
      ..assignment = Code(
          "{_${model.name.toCamelCase()}Path: RouteConfig((context){ return ${model.name}(${model.parameters.map((param) {
        return "${param.name}:context.get<${param.type}>(\"${param.name}\", ${param.defaultValue ?? _defaultValue(param)})";
      }).join(",")}); }),}"),
  );
}
