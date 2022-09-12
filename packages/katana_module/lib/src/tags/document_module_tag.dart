part of katana_module;

class _DocumentModuleTag extends ModuleTag {
  const _DocumentModuleTag();

  @override
  String get id => "document";

  @override
  String parse(
    String id,
    List<String> param,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (param.length < 2) {
      return "";
    }
    final doc = ref.watch(context.model!.documentProvider(param[0]))
      ..fetch();
    return doc.get<dynamic>(param.last, "").toString();
  }
}
