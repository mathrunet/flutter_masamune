part of masamune_builder;

Class keyConstClass(ClassModel model, String suffix) {
  return Class(
    (c) => c
      ..name = "${model.name}$suffix"
      ..constructors.add(
        Constructor(
          (c) => c
            ..name = "_"
            ..constant = true,
        ),
      )
      ..fields.addAll(
        [
          ...model.parameters.map((param) {
            return Field(
              (f) => f
                ..name = param.name
                ..assignment = Code("\"${param.name}\"")
                ..type = const Reference("String")
                ..static = true
                ..modifier = FieldModifier.constant,
            );
          }),
        ],
      ),
  );
}
