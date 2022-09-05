part of masamune_ui.variable;

/// FormConfig for using TextField.
@immutable
class TextFormConfig<T> extends VariableFormConfig<T>
    with VariableFormConfigUtilMixin<T> {
  const TextFormConfig({
    this.color,
    this.backgroundColor,
    this.obscureText = false,
    this.minLines,
    this.maxLines,
    this.expands = false,
    this.minLength,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.prefix,
    this.prefixText,
    this.suffix,
    this.suffixText,
    this.top,
    this.bottom,
  });

  final String? prefixText;
  final String? suffixText;

  final Widget? prefix;
  final Widget? suffix;

  final Color? backgroundColor;

  final Color? color;

  final bool expands;

  final int? minLines;

  final int? maxLines;

  final TextInputType keyboardType;

  final int? minLength;

  final int? maxLength;

  final bool obscureText;

  final TextInputFormatterConfig? inputFormatter;

  final ValueWidget<TextEditingController>? top;
  final ValueWidget<TextEditingController>? bottom;

  @override
  Iterable<Widget> build({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final controller = ref.useTextEditingController(
      config.id,
      data.get(config.id, config.value).toString(),
    );
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
          color: color?.withOpacity(0.75),
          prefix: headlinePrefix(
            context: context,
            config: config,
            color: color,
          ),
        )
      else
        const Divid(),
      if (top != null) ValueProvider(value: controller, child: top!),
      if (expands)
        Expanded(
          child: _textField(
            config: config,
            context: context,
            ref: ref,
            data: data,
            onlyRequired: onlyRequired,
            controller: controller,
          ),
        )
      else
        _textField(
          config: config,
          context: context,
          ref: ref,
          data: data,
          onlyRequired: onlyRequired,
          controller: controller,
        ),
      if (bottom != null) ValueProvider(value: controller, child: bottom!),
    ];
  }

  Widget _textField({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController controller,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return FormItemTextField(
      dense: true,
      expands: expands,
      color: color,
      cursorColor: color,
      subColor: color?.withOpacity(0.5),
      inputFormatters: [if (inputFormatter != null) inputFormatter!.value],
      minLines: minLines ?? 1,
      hintText: "Input %s".localize().format([config.label.localize()]),
      errorText: "No input %s".localize().format([config.label.localize()]),
      maxLines: maxLines,
      minLength: minLength,
      maxLength: maxLength,
      textAlignVertical: TextAlignVertical.top,
      keyboardType: keyboardType,
      backgroundColor: backgroundColor,
      obscureText: obscureText,
      allowEmpty: !config.required,
      controller: controller,
      onSaved: (value) {
        context[config.id] = value;
      },
      prefix: prefix ??
          (prefixText != null ? Text(prefixText?.localize() ?? "") : null),
      suffix: suffix ??
          (suffixText != null ? Text(suffixText?.localize() ?? "") : null),
    );
  }

  @override
  T? value({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
