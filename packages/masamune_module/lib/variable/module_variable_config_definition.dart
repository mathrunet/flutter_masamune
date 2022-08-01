part of masamune_module;

class ModuleVariableConfigDefinition {
  const ModuleVariableConfigDefinition._();

  /// VariableConfig definition of the text.
  static const VariableConfig<String> content = VariableConfig(
    id: Const.text,
    label: "Text",
    value: "",
    form: ContentFormConfig(),
  );
}
