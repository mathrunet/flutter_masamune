part of katana_module;

/// Config class for views.
@immutable
abstract class VariableViewConfig<T> {
  const VariableViewConfig();

  /// Specifies a callback for just displaying the value.
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<T> config,
    DynamicMap? data,
    bool onlyRequired = false,
  });

  Iterable<Widget> _build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig config,
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
}
