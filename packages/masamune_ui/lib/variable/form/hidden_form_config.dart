part of masamune_ui.variable;

/// FormConfig for using Hidden.
@immutable
class HiddenFormConfig<T> extends VariableFormConfig<T> {
  const HiddenFormConfig({
    this.type = HiddenFormConfigType.variable,
    this.applyOnUpdate = true,
  });

  final HiddenFormConfigType type;

  final bool applyOnUpdate;

  @override
  Iterable<Widget> build({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [];
  }

  @override
  T? value({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    final form = config.form;
    if (form is! HiddenFormConfig<T>) {
      return null;
    }
    if (!form.applyOnUpdate && updated) {
      return null;
    }
    switch (form.type) {
      case HiddenFormConfigType.dateTimeNow:
        return DateTime.now().millisecondsSinceEpoch as T;
      case HiddenFormConfigType.initialOrder:
        return DateTime.now().millisecondsSinceEpoch.toDouble() as T;
      default:
        return config.value;
    }
  }
}

/// The type of Hidden form config.
enum HiddenFormConfigType {
  /// Value.
  variable,

  /// Current time.
  dateTimeNow,

  /// Initial Order.
  initialOrder,
}
