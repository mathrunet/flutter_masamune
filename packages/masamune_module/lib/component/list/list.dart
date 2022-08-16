import 'package:masamune_module/masamune_module.dart';

@immutable
class ListModule extends PageModule {
  const ListModule({
    bool enabled = true,
    String? title,
    ModelQuery? query,
    required String queryPath,
    required String routePathPrefix,
    this.padding = const EdgeInsets.all(0),
    this.enableAdd = true,
    this.mergeConfig,
    this.automaticallyImplyLeadingOnHome = true,
    this.sliverLayoutWhenModernDesignOnHome = true,
    List<RerouteConfig> rerouteConfigs = const [],
    this.homePage = const PageConfig("/", ListModuleHomePage()),
    this.editPage = const PageConfig("/edit"),
    this.top = const [],
    this.bottom = const [],
    this.item = const ListModuleItemWidget(),
  }) : super(
          enabled: enabled,
          title: title,
          queryPath: queryPath,
          query: query,
          routePathPrefix: routePathPrefix,
          rerouteConfigs: rerouteConfigs,
        );

  @override
  List<PageConfig<Widget>> get pages => [
        homePage,
        editPage,
      ];

  /// Form padding.
  final EdgeInsetsGeometry padding;

  /// Item widget.
  final ModuleValueWidget<ListModule, DynamicMap> item;

  /// Top widget.
  final List<ModuleWidget<EditModule>> top;

  /// Bottom widget.
  final List<ModuleWidget<EditModule>> bottom;

  /// True if you want to enable additions.
  final bool enableAdd;

  /// Specify when merging separate collections.
  final MergeCollectionConfig? mergeConfig;

  /// Widget.
  final PageConfig<PageModuleWidget<ListModule>> homePage;
  final PageConfig<PageModuleWidget<ListModule>> editPage;

  /// True if Home is a sliver layout.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// True if you want to automatically display the back button when you are at home.
  final bool automaticallyImplyLeadingOnHome;
}

class ListModuleHomePage extends PageModuleWidget<ListModule> {
  const ListModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, ListModule module) {
    // Please describe reference.
    final collection = ref.watchCollectionModel(
      module.query?.value ?? module.queryPath,
    );
    final mergedCollection = module.mergeConfig != null
        ? collection.mergeDetailInformation(
            ref,
            module.mergeConfig!.path,
            idKey: module.mergeConfig!.key,
            keyPrefix: module.mergeConfig!.prefix,
          )
        : null;

    // Please describe the Widget.
    return UIScaffold(
      loadingFutures: [
        collection.loading,
      ],
      appBar: UIAppBar(
        title: Text(module.title ?? "List".localize()),
      ),
      body: ListBuilder<DynamicMap>(
        source: mergedCollection ?? collection,
        top: module.top,
        bottom: module.bottom,
        builder: (context, item, index) {
          return [
            ModuleValueProvider(value: item, child: module.item),
          ];
        },
      ),
      floatingActionButton: module.enableAdd
          ? FloatingActionButton.extended(
              onPressed: () {
                context.rootNavigator.pushNamed(
                  module.editPage.apply(module),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              },
              label: Text("Add".localize()),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class ListModuleItemWidget extends ModuleValueWidget<ListModule, DynamicMap> {
  const ListModuleItemWidget();
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ListModule module,
    DynamicMap value,
  ) {
    return ListItem(
      title: Text(value.get(Const.name, "")),
    );
  }
}

class ListModuleProfileWidget
    extends ModuleValueWidget<ListModule, DynamicMap> {
  const ListModuleProfileWidget();
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ListModule module,
    DynamicMap value,
  ) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: CircleAvatar(
              backgroundImage: Asset.image(value.get(Const.image, "")),
            ),
          ),
          const Space.width(16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value.get(Const.name, "")),
                const Space.height(8),
                Text(value.get(Const.text, "")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
