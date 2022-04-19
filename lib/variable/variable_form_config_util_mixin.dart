part of masamune.variable;

mixin VariableFormConfigUtilMixin<T> on VariableFormConfig<T> {
  Widget? headlinePrefix({
    required BuildContext context,
    required VariableConfig<T> config,
    Color? color,
  }) {
    if (config.icon != null) {
      return IconTheme(
        data: const IconThemeData(size: 16),
        child: Icon(
          config.icon!,
          color: color?.withOpacity(0.75),
        ),
      );
    }
    if (config.required) {
      return IconTheme(
        data: const IconThemeData(size: 16),
        child: context.widgetTheme.requiredIcon,
      );
    }
    return null;
  }
}
