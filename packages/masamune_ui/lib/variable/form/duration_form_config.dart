part of masamune_ui.variable;

/// Base unit of form.
enum DuratioinFormConfigBaseUnit {
  /// Second.
  second,

  /// Minute.
  minute,

  /// Hour.
  hour,
}

/// FormConfig for using duration field.
@immutable
class DurationFormConfig extends VariableFormConfig<int>
    with VariableFormConfigUtilMixin<int> {
  const DurationFormConfig({
    this.backgroundColor,
    this.color,
    this.format = "HH:mm:ss",
    this.baseUnit = DuratioinFormConfigBaseUnit.second,
  });

  final DuratioinFormConfigBaseUnit baseUnit;

  final Color? backgroundColor;

  final String format;

  final Color? color;

  @override
  Iterable<Widget> build({
    required VariableConfig<int> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final initialValue = __value(config, data);
    final baseUnit = _baseUnit();
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
      FormItemDurationField(
        dense: true,
        baseUnit: baseUnit,
        controller: ref.useTextEditingController(
          config.id,
          FormItemDurationField.tryFormat(
            initialValue?.inMilliseconds ?? 0,
            format: format,
          ),
        ),
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        allowEmpty: !config.required,
        format: format,
        onShowPicker: FormItemDurationField.picker(baseUnit: baseUnit),
        onSaved: (value) {
          if (value != null) {
            context[config.id] = value;
          } else {
            context[config.id] = initialValue;
          }
        },
      ),
    ];
  }

  @override
  int? value({
    required VariableConfig<int> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get<Duration?>(config.id, null)?.inMilliseconds;
  }

  FormItemDurationFieldBaseUnit _baseUnit() {
    switch (baseUnit) {
      case DuratioinFormConfigBaseUnit.second:
        return FormItemDurationFieldBaseUnit.second;
      case DuratioinFormConfigBaseUnit.minute:
        return FormItemDurationFieldBaseUnit.minute;
      default:
        return FormItemDurationFieldBaseUnit.hour;
    }
  }

  Duration? __value(
    VariableConfig<int> config,
    DynamicMap? data,
  ) {
    if (data.containsKey(config.id)) {
      return Duration(milliseconds: data.get(config.id, 0));
    }
    return Duration(milliseconds: config.value);
  }
}
