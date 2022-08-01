import 'package:masamune_module/masamune_module.dart';

@immutable
class ViewModule extends PageModule {
  const ViewModule({
    bool enabled = true,
    required this.variables,
    String? title,
    required String routePathPrefix,
    String queryPath = "view",
    ModelQuery? query,
    this.titleKey = Const.name,
    this.bottomSpace = 120,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.enableEdit = true,
    this.automaticallyImplyLeadingOnHome = true,
    this.sliverLayoutWhenModernDesignOnHome = false,
    List<RerouteConfig> rerouteConfigs = const [],
    this.homePage = const PageConfig(
      "/{view_id}",
      ViewModuleHomePage(),
    ),
    this.editPage = const PageConfig("/{view_id}/edit"),
    this.top = const [],
    this.bottom = const [],
  }) : super(
          enabled: enabled,
          title: title,
          query: query,
          queryPath: queryPath,
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

  /// Top widget.
  final List<ModuleWidget<ViewModule>> top;

  /// Bottom widget.
  final List<ModuleWidget<ViewModule>> bottom;

  // Page settings.
  final PageConfig<PageModuleWidget<ViewModule>> homePage;
  final PageConfig<PageModuleWidget<ViewModule>> editPage;

  /// True if editing is enabled.
  final bool enableEdit;

  /// Title key.
  final String titleKey;

  /// List of forms.
  final List<VariableConfig> variables;

  /// True if Home is a sliver layout.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// True if you want to automatically display the back button when you are at home.
  final bool automaticallyImplyLeadingOnHome;

  /// Space under the form.
  final double bottomSpace;
}

class ViewModuleHomePage extends PageModuleWidget<ViewModule> {
  const ViewModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, ViewModule module) {
    final queryKey = module.homePage.queryKeys.firstOrNull;
    final queryId = context.get(queryKey ?? "view_id", "");
    final doc = ref.watchDocumentModel("${module.queryPath}/$queryId");
    final variables = module.variables;
    final title = doc.get(module.titleKey, module.title ?? "Edit".localize());

    return UIScaffold(
      appBar: UIAppBar(
        automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
        sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
        title: Text(title),
        actions: [
          if (module.enableEdit)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.navigator.pushNamed(
                  module.editPage.apply(
                    module,
                    {queryKey ?? "view_id": queryId},
                  ),
                );
              },
            )
        ],
      ),
      body: LoadingBuilder(
        futures: [
          Future.value(doc.loading),
        ],
        builder: (context) {
          return ListView(
            padding: module.padding,
            children: [
              ...module.top,
              ...variables.buildForm(context: context, ref: ref, data: doc),
              ...module.bottom,
              if (variables.isNotEmpty && module.bottomSpace > 0) const Divid(),
              Space.height(module.bottomSpace),
            ],
          );
        },
      ),
    );
  }
}
