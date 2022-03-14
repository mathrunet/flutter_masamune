part of masamune.variable;

/// FormConfig for using rage TextField.
@immutable
class RangeFormConfig extends VariableFormConfig<DynamicMap> {
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

  @override
  Iterable<Widget> build({
    required VariableConfig<DynamicMap> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final map = data.getAsMap(config.id, config.value);
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
              color: color,
              inputFormatters: [
                if (inputFormatter != null) inputFormatter!.value
              ],
              errorText:
                  "No input %s".localize().format([config.label.localize()]),
              minLength: minLength,
              maxLength: maxLength,
              keyboardType: keyboardType,
              backgroundColor: backgroundColor,
              allowEmpty: !config.required,
              controller: ref.useTextEditingController("${config.id}:$minKey",
                  map.get(minKey, config.value).toString()),
              onSaved: (value) {
                if (value.isEmpty) {
                  return;
                }
                final map = context.getAsMap(config.id, <String, dynamic>{});
                final min = num.tryParse(value!);
                if (min == null) {
                  return;
                }
                if (map.containsKey(maxKey)) {
                  final max = map.get(maxKey, min);
                  if (min > max) {
                    map[minKey] = max;
                    map[maxKey] = min;
                  }
                } else {
                  map[minKey] = min;
                }
                context[config.id] = map;
              },
              prefix: prefix ??
                  (prefixText != null
                      ? Text(prefixText?.localize() ?? "")
                      : null),
              suffix: suffix ??
                  (suffixText != null
                      ? Text(suffixText?.localize() ?? "")
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
              color: color,
              inputFormatters: [
                if (inputFormatter != null) inputFormatter!.value
              ],
              errorText:
                  "No input %s".localize().format([config.label.localize()]),
              minLength: minLength,
              maxLength: maxLength,
              keyboardType: keyboardType,
              backgroundColor: backgroundColor,
              allowEmpty: !config.required,
              controller: ref.useTextEditingController("${config.id}:$maxKey",
                  map.get(maxKey, config.value).toString()),
              onSaved: (value) {
                if (value.isEmpty) {
                  return;
                }
                final map = context.getAsMap(config.id, <String, dynamic>{});
                final max = num.tryParse(value!);
                if (max == null) {
                  return;
                }
                if (map.containsKey(minKey)) {
                  final min = map.get(minKey, max);
                  if (min > max) {
                    map[minKey] = max;
                    map[maxKey] = min;
                  }
                } else {
                  map[maxKey] = max;
                }
                context[config.id] = map;
              },
              prefix: prefix ??
                  (prefixText != null
                      ? Text(prefixText?.localize() ?? "")
                      : null),
              suffix: suffix ??
                  (suffixText != null
                      ? Text(suffixText?.localize() ?? "")
                      : null),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  DynamicMap? value({
    required VariableConfig<DynamicMap> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, <String, dynamic>{});
  }
}
