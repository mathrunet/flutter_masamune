import 'package:masamune_module/masamune_module.dart';

enum MemberModuleInviteType {
  none,
  email,
}

@immutable
class MemberModule extends PageModule {
  const MemberModule({
    bool enabled = true,
    String? title,
    String queryPath = "user",
    ModelQuery? query,
    this.nameKey = Const.name,
    this.iconKey = Const.icon,
    this.formMessage,
    this.groupId,
    this.affiliationKey = "affiliation",
    String routePathPrefix = "memter",
    this.sliverLayoutWhenModernDesignOnHome = true,
    this.automaticallyImplyLeadingOnHome = true,
    List<RerouteConfig> rerouteConfigs = const [],
    this.homePage = const PageConfig(
      "/",
      MemberModuleHomePage(),
    ),
    this.invitePage = const PageConfig(
      "/innvite",
      MemberModuleInvitePage(),
    ),
    this.profilePage = const ExternalPageConfig("/user/{user_id}"),
    this.designType = DesignType.modern,
    this.inviteType = MemberModuleInviteType.none,
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
        invitePage,
        profilePage,
      ];

  // Page settings.
  final PageConfig<PageModuleWidget<MemberModule>> homePage;
  final PageConfig<PageModuleWidget<MemberModule>> invitePage;
  final ExternalPageConfig<PageModuleWidget<MemberModule>> profilePage;

  /// ホームをスライバーレイアウトにする場合True.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// ホームのときのバックボタンを削除するかどうか。
  final bool automaticallyImplyLeadingOnHome;

  /// Design type.
  final DesignType designType;

  /// タイトルのキー。
  final String nameKey;

  /// アイコンのキー。
  final String iconKey;

  /// 招待のタイプ。
  final MemberModuleInviteType inviteType;

  /// 所属リストのキー。
  final String affiliationKey;

  /// グループID.
  final String? groupId;

  /// フォームのメッセージ。
  final String? formMessage;
}

class MemberModuleHomePage extends PageModuleWidget<MemberModule> {
  const MemberModuleHomePage();

  String _groupId(BuildContext context, WidgetRef ref, MemberModule module) {
    if (module.groupId.isEmpty) {
      final user = ref.watchUserDocumentModel();
      return user.uid;
    }
    return ref.applyModuleTag(module.groupId!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref, MemberModule module) {
    // Please describe Hook.
    final members =
        ref.watchCollectionModel(module.query?.value ?? module.queryPath);
    final groupId = _groupId(context, ref, module);
    final user = ref.watchUserDocumentModel();

    // Please describe the Widget.
    return UIScaffold(
      waitTransition: true,
      loadingFutures: [
        members.loading,
        user.loading,
      ],
      appBar: UIAppBar(
        title: Text(
          module.title ?? "%s list".localize().format(["Member".localize()]),
        ),
        sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
        automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
      ),
      body: UIListBuilder<DynamicMap>(
        source: members,
        builder: (context, item, index) {
          return [
            ListItem(
              leading: CircleAvatar(
                backgroundImage: Asset.image(item.get(module.iconKey, "")),
                backgroundColor: context.theme.disabledColor,
              ),
              title: Text(item.get(module.nameKey, "")),
              trailing: item.uid == user.uid
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        UIConfirm.show(
                          context,
                          title: "Confirmation".localize(),
                          text:
                              "You will remove this %s from the list. Are you sure?"
                                  .localize()
                                  .format(["User".localize()]),
                          submitText: "Yes".localize(),
                          cancelText: "No".localize(),
                          onSubmit: () async {
                            final doc = members
                                .firstWhereOrNull((e) => e.uid == item.uid);
                            if (doc == null) {
                              return;
                            }
                            final affiliation = List<String>.from(
                              item.getAsList(module.affiliationKey, []),
                            );
                            if (affiliation.isEmpty ||
                                !affiliation.contains(groupId)) {
                              return UIDialog.show(
                                context,
                                title: "Error".localize(),
                                text: "This %s has already been removed."
                                    .localize()
                                    .format(["User".localize()]),
                                submitText: "Close".localize(),
                              );
                            }
                            doc[module.affiliationKey] = affiliation
                              ..remove(groupId);
                            await doc.save().showIndicator(context);
                            UIDialog.show(
                              context,
                              title: "Success".localize(),
                              text: "You have removed this %s from the list."
                                  .localize()
                                  .format(["User".localize()]),
                              submitText: "Close".localize(),
                            );
                          },
                        );
                      },
                    ),
              onTap: () {
                context.navigator.pushNamed(
                  module.profilePage.apply(
                    module,
                    {"user_id": item.uid},
                  ),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              },
            )
          ];
        },
      ),
      floatingActionButton: module.inviteType == MemberModuleInviteType.none
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                context.navigator.pushNamed(
                  ref.applyModuleTag(module.invitePage.apply(module)),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              },
              label: Text("Invite".localize()),
              icon: const Icon(Icons.email),
            ),
    );
  }
}

class MemberModuleInvitePage extends PageModuleWidget<MemberModule> {
  const MemberModuleInvitePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, MemberModule module) {
    final form = ref.useForm();

    return UIScaffold(
      waitTransition: true,
      appBar: UIAppBar(title: Text("Invite".localize())),
      body: FormBuilder(
        key: form.key,
        type: _type(context, module),
        padding: const EdgeInsets.all(0),
        children: _form(context, ref, module),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          switch (module.inviteType) {
            case MemberModuleInviteType.email:
            default:
          }
        },
        label: Text("Submit".localize()),
        icon: const Icon(Icons.check),
      ),
    );
  }

  FormBuilderType _type(BuildContext context, MemberModule module) {
    switch (module.inviteType) {
      case MemberModuleInviteType.email:
      default:
        return FormBuilderType.center;
    }
  }

  List<Widget> _form(BuildContext context, WidgetRef ref, MemberModule module) {
    switch (module.inviteType) {
      case MemberModuleInviteType.email:
        return [
          MessageBox(
            module.formMessage ??
                "An invitation email will be sent to the email address you entered. You can complete the invitation by clicking the link in the invitation email."
                    .localize(),
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          ),
          DividHeadline("Email".localize()),
          FormItemTextField(
            dense: true,
            controller: ref.useTextEditingController("email"),
            hintText: "Input %s".localize().format(["Email".localize()]),
            errorText: "No input %s".localize().format(["Email".localize()]),
            onSaved: (value) {
              context["email"] = value;
            },
          ),
          const Divid(),
        ];
      default:
        return [];
    }
  }
}
