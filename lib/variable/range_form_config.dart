part of masamune.variable;

/// FormConfig for using rage TextField.
@immutable
class RangeFormConfig extends FormConfig<num> {
  const RangeFormConfig({
    this.color,
    this.backgroundColor,
    this.minLength,
    this.maxLength,
    this.keyboardType = TextInputType.number,
    this.inputFormatter,
    this.prefix,
    this.prefixText,
    this.suffix,
    this.suffixText,
    this.minKey = "min",
    this.maxKey = "max",
  });

  final String? prefixText;
  final String? suffixText;

  final Widget? prefix;
  final Widget? suffix;

  final String minKey;
  final String maxKey;

  final Color? backgroundColor;

  final Color? color;

  final TextInputType keyboardType;

  final int? minLength;

  final int? maxLength;

  final TextInputFormatterConfig? inputFormatter;
}

@immutable
class RangeFormConfigBuilder extends FormConfigBuilder<num, RangeFormConfig> {
  const RangeFormConfigBuilder();

  @override
  Iterable<Widget> form({
    required VariableConfig<num> config,
    required RangeFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final map = data.getAsMap(config.id, <String, dynamic>{});
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
      Row(
        children: [
          Expanded(
            flex: 1,
            child: FormItemTextField(
              dense: true,
              color: form.color,
              inputFormatters: [
                if (form.inputFormatter != null) form.inputFormatter!.value
              ],
              errorText:
                  "No input %s".localize().format([config.label.localize()]),
              minLength: form.minLength,
              maxLength: form.maxLength,
              keyboardType: form.keyboardType,
              backgroundColor: form.backgroundColor,
              allowEmpty: !config.required,
              controller: ref.useTextEditingController(
                  "${config.id}:${form.minKey}",
                  map.get(form.minKey, config.value).toString()),
              onSaved: (value) {
                if (value.isEmpty) {
                  return;
                }
                final map = context.getAsMap(config.id, <String, dynamic>{});
                final min = num.tryParse(value!);
                if (min == null) {
                  return;
                }
                if (map.containsKey(form.maxKey)) {
                  final max = map.get(form.maxKey, min);
                  if (min > max) {
                    map[form.minKey] = max;
                    map[form.maxKey] = min;
                  }
                } else {
                  map[form.minKey] = min;
                }
                context[config.id] = map;
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
          ),
          const Space.width(8),
          const SizedBox(
            width: 16,
            child: Text(
              "～",
              textAlign: TextAlign.center,
            ),
          ),
          const Space.width(8),
          Expanded(
            flex: 1,
            child: FormItemTextField(
              dense: true,
              color: form.color,
              inputFormatters: [
                if (form.inputFormatter != null) form.inputFormatter!.value
              ],
              errorText:
                  "No input %s".localize().format([config.label.localize()]),
              minLength: form.minLength,
              maxLength: form.maxLength,
              keyboardType: form.keyboardType,
              backgroundColor: form.backgroundColor,
              allowEmpty: !config.required,
              controller: ref.useTextEditingController(
                  "${config.id}:${form.maxKey}",
                  map.get(form.maxKey, config.value).toString()),
              onSaved: (value) {
                if (value.isEmpty) {
                  return;
                }
                final map = context.getAsMap(config.id, <String, dynamic>{});
                final max = num.tryParse(value!);
                if (max == null) {
                  return;
                }
                if (map.containsKey(form.minKey)) {
                  final min = map.get(form.minKey, max);
                  if (min > max) {
                    map[form.minKey] = max;
                    map[form.maxKey] = min;
                  }
                } else {
                  map[form.maxKey] = max;
                }
                context[config.id] = map;
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
          ),
        ],
      ),
    ];
  }

  @override
  Iterable<Widget> view({
    required VariableConfig<num> config,
    required RangeFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final map = data.getAsMap(config.id, <String, dynamic>{});
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      ListItem(
        title: UIText(
            "${map.get(form.minKey, config.value)} ～ ${map.get(form.maxKey, config.value)}"),
      ),
    ];
  }

  @override
  dynamic value({
    required VariableConfig<num> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, <String, dynamic>{});
  }
}
