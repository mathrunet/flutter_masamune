part of masamune.variable;

/// FormConfig for using Hidden.
@immutable
class HiddenFormConfig<T> extends FormConfig<T> {
  const HiddenFormConfig({
    this.type = HiddenFormConfigType.variable,
    this.applyOnUpdate = true,
  });

  final HiddenFormConfigType type;

  final bool applyOnUpdate;
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

@immutable
class HiddenFormConfigBuilder<T>
    extends FormConfigBuilder<T, HiddenFormConfig<T>> {
  const HiddenFormConfigBuilder();

  @override
  Iterable<Widget> form({
    required VariableConfig<T> config,
    required HiddenFormConfig<T> form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [];
  }

  @override
  Iterable<Widget> view({
    required VariableConfig<T> config,
    required HiddenFormConfig<T> form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [];
  }

  @override
  dynamic value({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    final form = config.form;
    if (form is! HiddenFormConfig<T>) {
      return null;
    }
    if (!form.applyOnUpdate && !updated) {
      return null;
    }
    switch (form.type) {
      case HiddenFormConfigType.dateTimeNow:
        return DateTime.now().millisecondsSinceEpoch;
      case HiddenFormConfigType.initialOrder:
        return DateTime.now().millisecondsSinceEpoch.toDouble();
      default:
        return config.value;
    }
  }
}
