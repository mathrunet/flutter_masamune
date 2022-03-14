part of masamune.variable;

/// Type of form.
enum DateTimeFormConfigType {
  /// Date only.
  date,

  /// Time only.
  time,

  /// Date and time.
  dateTime,
}

/// FormConfig for using date time field.
@immutable
class DateTimeFormConfig extends VariableFormConfig<int> {
  const DateTimeFormConfig({
    this.backgroundColor,
    this.initialDate,
    this.color,
    this.type = DateTimeFormConfigType.dateTime,
    this.startSelectingDate,
    this.endSelectingDate,
  });

  final String? initialDate;

  final DateTimeFormConfigType type;

  final Color? backgroundColor;

  final Color? color;

  final String? startSelectingDate;

  final String? endSelectingDate;

  @override
  Iterable<Widget> build({
    required VariableConfig<int> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final initialValue = __value(config, data);
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
      FormItemDateTimeField(
        dense: true,
        type: _type(),
        controller: ref.useTextEditingController(
          config.id,
          initialValue != null ? _tryParseFromDateTime(initialValue) : "",
        ),
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        allowEmpty: !config.required,
        onShowPicker: _onShowPicker(config),
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
    return context.get<DateTime?>(config.id, null)?.millisecondsSinceEpoch;
  }

  FormItemDateTimeFieldPickerType _type() {
    switch (type) {
      case DateTimeFormConfigType.date:
        return FormItemDateTimeFieldPickerType.date;
      case DateTimeFormConfigType.time:
        return FormItemDateTimeFieldPickerType.time;
      default:
        return FormItemDateTimeFieldPickerType.dateTime;
    }
  }

  String _tryParseFromDateTime(DateTime dateTime) {
    switch (type) {
      case DateTimeFormConfigType.date:
        return FormItemDateTimeField.formatDate(
            dateTime.millisecondsSinceEpoch);
      case DateTimeFormConfigType.time:
        return FormItemDateTimeField.formatTime(
            dateTime.millisecondsSinceEpoch);
      default:
        return FormItemDateTimeField.formatDateTime(
            dateTime.millisecondsSinceEpoch);
    }
  }

  DateTime? __value(
    VariableConfig<int> config,
    DynamicMap? data,
  ) {
    if (data.containsKey(config.id)) {
      return data.getAsDateTime(config.id);
    }
    if (initialDate.isEmpty) {
      return null;
    }
    return FormItemDateTimeField.tryParseFromDate(initialDate!);
  }

  Future<DateTime> Function(BuildContext context, DateTime dateTime)
      _onShowPicker(VariableConfig config) {
    final startDate = startSelectingDate.isEmpty
        ? null
        : FormItemDateTimeField.tryParseFromDate(startSelectingDate!);
    final endDate = endSelectingDate.isEmpty
        ? null
        : FormItemDateTimeField.tryParseFromDate(endSelectingDate!);
    switch (type) {
      case DateTimeFormConfigType.date:
        return FormItemDateTimeField.datePicker(
          startDate: startDate,
          endDate: endDate,
        );
      case DateTimeFormConfigType.time:
        return FormItemDateTimeField.timePicker();
      default:
        return FormItemDateTimeField.dateTimePicker(
          startDate: startDate,
          endDate: endDate,
        );
    }
  }
}
