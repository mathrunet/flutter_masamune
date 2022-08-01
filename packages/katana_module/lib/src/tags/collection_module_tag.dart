part of katana_module;

class _CollectionModuleTag extends ModuleTag {
  const _CollectionModuleTag();
  @override
  String get id => "collection";

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
    final col = context.model!.loadCollection(
      ref.watch(context.model!.collectionProvider(param[0])),
    );
    return col
        .mapAndRemoveEmpty(
          (item) => item.get<dynamic>(param.last, "").toString(),
        )
        .join(",");
  }
}
