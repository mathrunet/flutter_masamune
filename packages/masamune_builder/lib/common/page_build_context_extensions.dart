part of masamune_builder;

Extension pageBuildContextExtensions(ClassModel model, PathModel path) {
  return Extension(
    (e) => e
      ..name = "_\$${model.name}PageBuildContextExtensions"
      ..on = const Reference("BuildContext")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "parameter"
            ..lambda = true
            ..type = MethodType.getter
            ..returns = Reference("_${model.name}PageParameter")
            ..body = Code("_${model.name}PageParameter._(this)"),
        )
      ]),
  );
}
