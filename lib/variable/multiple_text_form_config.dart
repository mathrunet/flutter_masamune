part of masamune.variable;

/// FormConfig for using multiple TextField List.
@immutable
class MultipleTextFormConfig extends FormConfig<List<String>> {
  const MultipleTextFormConfig({
    this.backgroundColor,
    this.obscureText = false,
    this.color,
    this.minLength,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.maxItems,
    this.keyboardType = TextInputType.url,
  });

  final int? maxItems;

  final Color? backgroundColor;

  final Color? color;

  final int? minLines;

  final int? maxLines;

  final TextInputType keyboardType;

  final int? minLength;

  final int? maxLength;

  final bool obscureText;
}

@immutable
class MultipleTextFormConfigBuilder
    extends FormConfigBuilder<List<String>, MultipleTextFormConfig> {
  const MultipleTextFormConfigBuilder();

  @override
  Iterable<Widget> form({
    required VariableConfig<List<String>> config,
    required MultipleTextFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
          prefix: config.required
              ? IconTheme(
                  data: const IconThemeData(size: 16),
                  child: context.widgetTheme.requiredIcon,
                )
              : null,
        )
      else
        const Divid(),
      FormItemMultipleTextField(
        dense: true,
        color: form.color,
        minLines: form.minLines ?? 1,
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        maxLines: form.maxLines,
        minLength: form.minLength,
        maxLength: form.maxLength,
        keyboardType: form.keyboardType,
        backgroundColor: form.backgroundColor,
        obscureText: form.obscureText,
        allowEmpty: !config.required,
        controller: ref.useTextEditingController(
            config.id, data.getAsList(config.id, config.value).join(",")),
        onSaved: (value) {
          context[config.id] = value?.where((e) => e.isNotEmpty).toList() ?? [];
        },
      ),
    ];
  }

  @override
  Iterable<Widget> view({
    required VariableConfig<List<String>> config,
    required MultipleTextFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final list = data.getAsList(config.id, config.value);
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      if (list.isEmpty)
        const ListItem(title: Text("--"))
      else
        for (final text in list) ListItem(title: UIText(text)),
    ];
  }

  @override
  dynamic value({
    required VariableConfig<List<String>> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.getAsList(config.id, config.value);
  }
}
