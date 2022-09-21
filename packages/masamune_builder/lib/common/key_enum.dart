part of masamune_builder;

Enum keyEnum(ClassModel model) {
  return Enum(
    (e) => e
      ..name = "${model.name}Keys"
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
