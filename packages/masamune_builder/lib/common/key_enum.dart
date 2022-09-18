part of masamune_builder;

Enum keyEnum(ClassModel model, String suffix) {
  return Enum(
    (e) => e
      ..name = "${model.name}$suffix"
      ..values = ListBuilder([
        EnumValue(
          (e) => e..name = "uid",
        ),
        ...model.parameters.map((param) {
          return EnumValue(
            (e) => e..name = param.name,
          );
        }),
      ]),
  );
}
