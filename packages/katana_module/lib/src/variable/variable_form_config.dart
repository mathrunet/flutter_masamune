part of katana_module;

/// Config class for forms.
@immutable
abstract class VariableFormConfig<T> {
  const VariableFormConfig();

  /// Specifies the callback for displaying the form.
  Iterable<Widget> build({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  });

  /// Callback to retrieve values when processing form content.
  T? value({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  });

  Iterable<Widget> _build({
    required VariableConfig config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) =>
      build(
        context: context,
        ref: ref,
        config: config as VariableConfig<T>,
        data: data,
        onlyRequired: onlyRequired,
      );

  T? _value({
    required VariableConfig config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) =>
      value(
        context: context,
        ref: ref,
        config: config as VariableConfig<T>,
        updated: updated,
      );
}
