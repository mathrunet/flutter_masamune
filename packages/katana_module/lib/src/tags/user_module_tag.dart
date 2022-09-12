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
        final doc = ref.watch(
          context.model!
              .documentProvider("${Const.user}/${context.model?.userId}"),
        )..fetch();
        return doc.get<dynamic>(param.last, "").toString();
    }
  }
}
