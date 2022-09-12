import 'dart:async';

import 'package:masamune_module/masamune_module.dart';

@immutable
class EditModule extends PageModule {
  const EditModule({
    bool enabled = true,
    required this.variables,
    String? title,
    String queryPath = "edit",
    ModelQuery? query,
    required String routePathPrefix,
    this.enableDelete = true,
    this.fixed = false,
    this.bottomSpace = 120,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.automaticallyImplyLeadingOnHome = true,
    this.sliverLayoutWhenModernDesignOnHome = false,
    List<RerouteConfig> rerouteConfigs = const [],
    this.addPage = const PageConfig("/edit", EditModuleHomePage()),
    this.editPage = const PageConfig("/{edit_id}/edit", EditModuleHomePage()),
    this.top = const [],
    this.bottom = const [],
    this.function,
  }) : super(
          enabled: enabled,
          title: title,
          query: query,
          queryPath: queryPath,
          routePathPrefix: routePathPrefix,
          rerouteConfigs: rerouteConfigs,
        );

  @override
  List<PageConfig<Widget>> get pages {
    return [
      addPage,
      editPage,
    ];
  }

  // Page settings.
  final PageConfig<PageModuleWidget<EditModule>> addPage;
  final PageConfig<PageModuleWidget<EditModule>> editPage;

  /// Form padding.
  final EdgeInsetsGeometry padding;

  /// Top widget.
  final List<ModuleWidget<EditModule>> top;

  /// Bottom widget.
  final List<ModuleWidget<EditModule>> bottom;

  /// True if you want to enable deletion.
  final bool enableDelete;

  /// List of forms.
  final List<VariableConfig> variables;

  /// True if Home is a sliver layout.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// True if you want to automatically display the back button when you are at home.
  final bool automaticallyImplyLeadingOnHome;

  /// Space under the form.
  final double bottomSpace;

  /// True if the form is fixed rather than scrollable.
  final bool fixed;

  /// Defined if there are additional processes.
  final EditModuleFunctionAdapter? function;
}

class EditModuleHomePage extends PageModuleWidget<EditModule> {
  const EditModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, EditModule module) {
    final queryKey = module.editPage.queryKeys.firstOrNull;
    final form = ref.useForm(queryKey ?? "edit_id");
    final doc = ref.watchDocumentModel("${module.queryPath}/${form.uid}");
    final variables = module.variables;

    return UIScaffold(
      appBar: UIAppBar(
        automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
        sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
        title: Text(module.title ?? "Edit".localize()),
        actions: [
          if (module.enableDelete && form.exists)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                try {
                  UIConfirm.show(
                    context,
                    title: "Confirmation".localize(),
                    text: "You will delete this %s. Are you sure?"
                        .localize()
                        .format(["Data".localize()]),
                    submitText: "Yes".localize(),
                    onSubmit: () async {
                      await module.function
                          ?.preProcessOnDelete(
                            context,
                            ref,
                            doc,
                          )
                          .showIndicator(context);
                      await doc.delete().showIndicator(context);
                      await module.function
                          ?.postProcessOnDelete(
                            context,
                            ref,
                          )
                          .showIndicator(context);
                      UIDialog.show(
                        context,
                        title: "Success".localize(),
                        text: "%s is completed."
                            .localize()
                            .format(["Deletion".localize()]),
                        submitText: "Back".localize(),
                        onSubmit: () {
                          context.navigator.pop();
                        },
                      );
                    },
                    cancelText: "No".localize(),
                  );
                } catch (e) {
                  UIDialog.show(
                    context,
                    title: "Error".localize(),
                    text: "%s is not completed."
                        .localize()
                        .format(["Deletion".localize()]),
                    submitText: "Close".localize(),
                  );
                }
              },
            )
        ],
      ),
      body: LoadingBuilder(
        futures: [
          Future.value(doc.loading),
        ],
        builder: (context) {
          return FormBuilder(
            key: form.key,
            padding: module.padding,
            type:
                module.fixed ? FormBuilderType.fixed : FormBuilderType.listView,
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
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.check),
        label: Text("Submit".localize()),
        onPressed: () async {
          if (!form.validate()) {
            return;
          }

          try {
            if (form.exists) {
              variables.setValue(
                target: doc,
                context: context,
                ref: ref,
                updated: form.exists,
              );
              await module.function
                  ?.preProcessOnAddOrUpdate(
                    context,
                    ref,
                    doc,
                  )
                  .showIndicator(context);
              await doc.save().showIndicator(context);
              await module.function
                  ?.postProcessOnAddOrUpdate(
                    context,
                    ref,
                    doc,
                  )
                  .showIndicator(context);
            } else {
              final model = context.model;
              if (model == null) {
                return;
              }
              final collection = ref.readCollectionModel(module.queryPath);
              final doc = collection.create();
              variables.setValue(
                target: doc,
                context: context,
                ref: ref,
                updated: form.exists,
              );
              await module.function
                  ?.preProcessOnAddOrUpdate(
                    context,
                    ref,
                    doc,
                  )
                  .showIndicator(context);
              await doc.save().showIndicator(context);
              await module.function
                  ?.postProcessOnAddOrUpdate(
                    context,
                    ref,
                    doc,
                  )
                  .showIndicator(context);
            }
            UIDialog.show(
              context,
              title: "Success".localize(),
              text:
                  "%s is completed.".localize().format(["Editing".localize()]),
              submitText: "Back".localize(),
              onSubmit: () {
                context.navigator.pop();
              },
            );
          } catch (e) {
            UIDialog.show(
              context,
              title: "Error".localize(),
              text: "%s is not completed."
                  .localize()
                  .format(["Editing".localize()]),
              submitText: "Close".localize(),
            );
          }
        },
      ),
    );
  }
}

@immutable
class EditModuleFunctionAdapter extends FunctionAdapter {
  const EditModuleFunctionAdapter();

  /// Define if pre-processing is required.
  FutureOr<void> preProcessOnAddOrUpdate(
    BuildContext context,
    WidgetRef ref,
    DynamicDocumentModel doc,
  ) {}

  /// Defined when post-processing is required.
  FutureOr<void> postProcessOnAddOrUpdate(
    BuildContext context,
    WidgetRef ref,
    DynamicDocumentModel doc,
  ) {}

  /// Define if pre-processing is required.
  FutureOr<void> preProcessOnDelete(
    BuildContext context,
    WidgetRef ref,
    DynamicDocumentModel doc,
  ) {}

  /// Defined when post-processing is required.
  FutureOr<void> postProcessOnDelete(
    BuildContext context,
    WidgetRef ref,
  ) {}
}
