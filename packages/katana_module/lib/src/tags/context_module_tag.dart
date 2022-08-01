part of katana_module;

class _ContextModuleTag extends ModuleTag {
  const _ContextModuleTag();

  @override
  String get id => "context";

  @override
  String parse(
    String id,
    List<String> param,
    BuildContext context,
    WidgetRef ref,
  ) {
    return context[param.last]?.toString() ?? "";
  }
}
