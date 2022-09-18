part of masamune_builder;

Enum keyEnum(ClassModel model, String suffix) {
  return Enum(
    (e) => e
      ..name = "${model.name}$suffix"
      ..values = ListBuilder([
        ...model.parameters.map((param) {
          return EnumValue(
            (v) => v..name = param.name,
          );
        }),
      ]),
  );
}
