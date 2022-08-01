part of katana_module;

class _UserModuleTag extends ModuleTag {
  const _UserModuleTag();

  @override
  String get id => "user";

  @override
  String parse(
    String id,
    List<String> param,
    BuildContext context,
    WidgetRef ref,
  ) {
    switch (param.last) {
      case "id":
        return context.model?.userId ?? "";
      default:
        final doc = context.model!.loadDocument(
          ref.watch(
            context.model!
                .documentProvider("${Const.user}/${context.model?.userId}"),
          ),
        );
        return doc.get<dynamic>(param.last, "").toString();
    }
  }
}
