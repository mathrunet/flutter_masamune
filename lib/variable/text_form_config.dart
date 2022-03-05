part of masamune.variable;

/// FormConfig for using TextField.
@immutable
class TextFormConfig<T> extends FormConfig<T> {
  const TextFormConfig({
    this.color,
    this.backgroundColor,
    this.obscureText = false,
    this.minLines,
    this.maxLines,
    this.minLength,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.prefix,
    this.prefixText,
    this.suffix,
    this.suffixText,
  });

  final String? prefixText;
  final String? suffixText;

  final Widget? prefix;
  final Widget? suffix;

  final Color? backgroundColor;

  final Color? color;

  final int? minLines;

  final int? maxLines;

  final TextInputType keyboardType;

  final int? minLength;

  final int? maxLength;

  final bool obscureText;

  final TextInputFormatterConfig? inputFormatter;
}

@immutable
class TextFormConfigBuilder<T> extends FormConfigBuilder<T, TextFormConfig> {
  const TextFormConfigBuilder();

  @override
  Iterable<Widget> form({
    required VariableConfig<T> config,
    required TextFormConfig form,
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
      FormItemTextField(
        dense: true,
        color: form.color,
        inputFormatters: [
          if (form.inputFormatter != null) form.inputFormatter!.value
        ],
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
            config.id, data.get(config.id, config.value).toString()),
        onSaved: (value) {
          context[config.id] = value;
        },
        prefix: form.prefix ??
            (form.prefixText != null
                ? Text(form.prefixText?.localize() ?? "")
                : null),
        suffix: form.suffix ??
            (form.suffixText != null
                ? Text(form.suffixText?.localize() ?? "")
                : null),
      ),
    ];
  }

  @override
  Iterable<Widget> view({
    required VariableConfig<T> config,
    required TextFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      ListItem(
        title: UIText(data.get(config.id, config.value).toString()),
      ),
    ];
  }

  @override
  dynamic value({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
