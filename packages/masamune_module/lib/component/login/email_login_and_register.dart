import 'dart:ui';
import 'package:masamune_module/masamune_module.dart';

@immutable
class EmailLoginAndRegisterModule extends PageModule {
  const EmailLoginAndRegisterModule({
    bool enabled = true,
    String title = "",
    this.layoutType = LoginLayoutType.fixed,
    this.color,
    String routePathPrefix = "",
    this.userPath = Const.user,
    this.roleKey = Const.role,
    this.backgroundColor,
    this.backgroundGradient,
    this.appBarColorOnSliverList,
    this.appBarHeightOnSliverList,
    this.buttonColor,
    this.buttonBackgroundColor,
    this.backgroundImage,
    this.backgroundImageBlur = 5.0,
    this.featureImage,
    this.featureImageSize,
    this.featureImageRadius,
    this.formImageSize,
    this.featureImageFit = BoxFit.cover,
    this.titleTextStyle,
    this.copyRightText,
    this.titleAlignment = Alignment.bottomLeft,
    this.menu = const [
      MenuConfig(
        path: "login",
        name: "Login",
        icon: FontAwesomeIcons.rightToBracket,
      ),
    ],
    this.titlePadding =
        const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    this.padding = const EdgeInsets.all(36),
    List<RerouteConfig> rerouteConfigs = const [],
    this.registerVariables = const {},
    this.showOnlyRequiredVariable = true,
    this.runAfterFinishBootHooksOnRidirect = true,
    this.landingPage = const PageConfig(
      "/landing",
      EmailLoginAndRegisterModuleLandingPage(),
    ),
    this.loginPage = const PageConfig(
      "/login",
      EmailLoginAndRegisterModuleLoginPage(),
    ),
    this.resetPage = const PageConfig(
      "/reset",
      EmailLoginAndRegisterModulePasswordResetPage(),
    ),
    this.registerPage = const PageConfig(
      "/register",
      EmailLoginAndRegisterModuleRegisterPage(),
    ),
    this.registerAnonymousPage = const PageConfig(
      "/register/anonymous",
      EmailLoginAndRegisterModuleRegisterAnonymousPage(),
    ),
    this.registerWithRolePage = const PageConfig(
      "/register/{role_id}",
      EmailLoginAndRegisterModuleRegisterPage(),
    ),
    this.redirectPage = const ExternalPageConfig("/"),
  }) : super(
          enabled: enabled,
          title: title,
          routePathPrefix: routePathPrefix,
          rerouteConfigs: rerouteConfigs,
        );

  @override
  List<PageConfig<Widget>> get pages => [
        landingPage,
        loginPage,
        resetPage,
        registerPage,
        registerAnonymousPage,
        registerWithRolePage,
      ];

  // ページ。
  final PageConfig<PageModuleWidget<EmailLoginAndRegisterModule>> landingPage;
  final PageConfig<PageModuleWidget<EmailLoginAndRegisterModule>> loginPage;
  final PageConfig<PageModuleWidget<EmailLoginAndRegisterModule>> resetPage;
  final PageConfig<PageModuleWidget<EmailLoginAndRegisterModule>> registerPage;
  final PageConfig<PageModuleWidget<EmailLoginAndRegisterModule>>
      registerAnonymousPage;
  final PageConfig<PageModuleWidget<EmailLoginAndRegisterModule>>
      registerWithRolePage;
  final ExternalPageConfig<PageModuleWidget<EmailLoginAndRegisterModule>>
      redirectPage;

  /// レイアウトタイプ。
  final LoginLayoutType layoutType;

  /// 登録するメニュー。
  final List<MenuConfig> menu;

  /// ロールキー。
  final String roleKey;

  /// 前景色。
  final Color? color;

  /// ユーザーコレクションのパス。
  final String userPath;

  /// 背景色。
  final Color? backgroundColor;

  /// 背景グラデーション。
  final Gradient? backgroundGradient;

  /// AppBarの背景色。Sliver時のみ。
  final Color? appBarColorOnSliverList;

  /// AppBarの高さ。Sliver時のみ。
  final double? appBarHeightOnSliverList;

  /// フィーチャー画像。
  final String? featureImage;

  /// フィーチャー画像の丸み。
  final BorderRadius? featureImageRadius;

  /// フィーチャー画像の配置。
  final BoxFit featureImageFit;

  /// フィーチャー画像のサイズ。
  final Size? featureImageSize;

  /// フォーム画像のサイズ。
  final Size? formImageSize;

  /// 背景画像。
  final String? backgroundImage;

  /// 背景のブラーを設定する度合い。
  final double? backgroundImageBlur;

  /// ボタンの前景色。
  final Color? buttonColor;

  /// ボタンの背景色。
  final Color? buttonBackgroundColor;

  /// タイトルのテキストスタイル。
  final TextStyle? titleTextStyle;

  /// タイトルの位置。
  final Alignment titleAlignment;

  /// タイトルのパディング。
  final EdgeInsetsGeometry titlePadding;

  /// コンテンツのパディング。
  final EdgeInsetsGeometry padding;

  /// True if [AfterFinishBoot] hook is executed on redirect.
  final bool runAfterFinishBootHooksOnRidirect;

  /// 登録時の値データ。
  final Map<String, List<VariableConfig>> registerVariables;

  /// `true` if you want to show only necessary values at registration.
  final bool showOnlyRequiredVariable;

  /// コピーライトテキスト。
  final String? copyRightText;
}

class EmailLoginAndRegisterModuleLandingPage
    extends PageModuleWidget<EmailLoginAndRegisterModule> {
  const EmailLoginAndRegisterModuleLandingPage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    EmailLoginAndRegisterModule module,
  ) {
    final animation = ref.useAutoPlayAnimationScenario(
      "main",
      [
        AnimationUnit(
          tween: DoubleTween(begin: 0, end: 1),
          from: const Duration(milliseconds: 500),
          to: const Duration(milliseconds: 1500),
          tag: "opacity",
        ),
      ],
    );

    final color = module.color ?? Colors.white;
    final buttonColor = module.buttonColor ?? module.color ?? Colors.white;
    final buttonBackgroundColor =
        module.buttonBackgroundColor ?? Colors.transparent;

    switch (module.layoutType) {
      case LoginLayoutType.fixed:
        return UIScaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              _EmailLoginAndRegisterModuleBackgroundImage(
                module,
                opacity: 0.75,
              ),
              AnimationScope(
                animation: animation,
                builder: (context, child, animation) {
                  return Opacity(
                    opacity: animation.get("opacity", 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (module.featureImage.isNotEmpty)
                                  SizedBox(
                                    width: module.featureImageSize?.width,
                                    height: module.featureImageSize?.height,
                                    child: ClipRRect(
                                      borderRadius: module.featureImageRadius ??
                                          BorderRadius.zero,
                                      child: Image(
                                        image: Asset.image(
                                          module.featureImage!,
                                        ),
                                        fit: module.featureImageFit,
                                      ),
                                    ),
                                  ),
                                if (module.title.isNotEmpty)
                                  Align(
                                    alignment: module.titleAlignment,
                                    child: Padding(
                                      padding: module.titlePadding,
                                      child: DefaultTextStyle(
                                        style: TextStyle(
                                          fontSize: 56,
                                          fontFamily: "Mplus",
                                          fontWeight: FontWeight.w700,
                                          color: color,
                                        ),
                                        child: Text(
                                          module.title ?? "",
                                          style: module.titleTextStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: module.padding,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  for (final menu in module.menu)
                                    FormItemButton(
                                      menu.name.localize(),
                                      borderWidth: 1.6,
                                      borderRadius: 35,
                                      color: buttonColor,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      mergin: const EdgeInsets.only(bottom: 8),
                                      borderColor: buttonColor,
                                      backgroundColor: buttonBackgroundColor,
                                      icon: menu.icon,
                                      onPressed: () async {
                                        switch (menu.path) {
                                          case "login":
                                            context.navigator.pushNamed(
                                              ref.applyModuleTag(
                                                "/${menu.path!}",
                                              ),
                                            );
                                            break;
                                          case "anonymous":
                                            try {
                                              await context.model
                                                  ?.signInAnonymously()
                                                  .showIndicator(context);
                                              if (_hasAnonymousRegistrationData(
                                                context,
                                                module,
                                              )) {
                                                context.navigator
                                                    .pushReplacementNamed(
                                                  module.loginPage
                                                      .apply(module),
                                                );
                                              } else {
                                                context.navigator
                                                    .pushReplacementNamed(
                                                  module.redirectPage
                                                      .apply(module),
                                                );
                                                if (module
                                                    .runAfterFinishBootHooksOnRidirect) {
                                                  Future.wait(
                                                    Module.registeredHooks.map(
                                                      (e) =>
                                                          e.onAfterFinishBoot(
                                                        context
                                                            .navigator.context,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            } catch (e) {
                                              UIDialog.show(
                                                context,
                                                title: "Error".localize(),
                                                text:
                                                    "Could not login. Please check your information."
                                                        .localize(),
                                              );
                                            }
                                            break;
                                          default:
                                            context.navigator.pushNamed(
                                              module.registerWithRolePage.apply(
                                                module,
                                                {"role_id": menu.path!},
                                              ),
                                              arguments: RouteQuery.fade,
                                            );
                                            break;
                                        }
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (module.copyRightText.isNotEmpty)
                          Text(module.copyRightText!)
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
    }
  }

  bool _hasAnonymousRegistrationData(
    BuildContext context,
    EmailLoginAndRegisterModule module,
  ) {
    if ((context.app?.userVariables
                .where((e) => !module.showOnlyRequiredVariable || e.required)
                .length ??
            0) >
        0) {
      return false;
    }
    return module.registerVariables.containsKey("anonymous");
  }
}

class EmailLoginAndRegisterModuleLoginPage
    extends PageModuleWidget<EmailLoginAndRegisterModule> {
  const EmailLoginAndRegisterModuleLoginPage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    EmailLoginAndRegisterModule module,
  ) {
    final form = ref.useForm();
    final emailFocus = ref.useFocusNode(hookId: "email");
    final passFocus = ref.useFocusNode(hookId: "pass");
    final showPassword = ref.state(false);

    final color = module.color ?? Colors.white;
    final buttonColor = module.buttonColor ?? module.color ?? Colors.white;
    final buttonBackgroundColor =
        module.buttonBackgroundColor ?? Colors.transparent;
    final imageSize = _imageSize(module);

    return Scaffold(
      backgroundColor: module.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: color,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _EmailLoginAndRegisterModuleBackgroundImage(module, opacity: 0.75),
          FormBuilder(
            type: FormBuilderType.center,
            key: form.key,
            padding: const EdgeInsets.all(0),
            children: [
              const Space.height(24),
              if (module.featureImage.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: imageSize?.width,
                    height: imageSize?.height,
                    child: ClipRRect(
                      borderRadius:
                          module.featureImageRadius ?? BorderRadius.zero,
                      child: Image(
                        image: Asset.image(module.featureImage!),
                        fit: module.featureImageFit,
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: Text(
                    "Login".localize(),
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5
                            ?.copyWith(color: module.color) ??
                        TextStyle(color: module.color),
                  ),
                ),
              const Space.height(36),
              DividHeadline(
                "Email".localize(),
                icon: Icons.email,
                color: color.withOpacity(0.75),
              ),
              FormItemTextField(
                dense: true,
                focusNode: emailFocus,
                hintText: "Input %s".localize().format(["Email".localize()]),
                errorText:
                    "No input %s".localize().format(["Email".localize()]),
                keyboardType: TextInputType.emailAddress,
                color: color,
                cursorColor: color,
                subColor: color.withOpacity(0.5),
                maxLines: 1,
                minLength: 2,
                maxLength: 256,
                onSaved: (value) {
                  context["email"] = value;
                },
                onSubmitted: (value) {
                  passFocus.requestFocus();
                },
              ),
              DividHeadline(
                "Password".localize(),
                icon: Icons.lock,
                color: color.withOpacity(0.75),
              ),
              FormItemTextField(
                dense: true,
                focusNode: passFocus,
                hintText: "Input %s".localize().format(["Password".localize()]),
                errorText:
                    "No input %s".localize().format(["Password".localize()]),
                keyboardType: TextInputType.visiblePassword,
                color: color,
                cursorColor: color,
                subColor: color.withOpacity(0.5),
                maxLines: 1,
                minLength: 8,
                maxLength: 36,
                obscureText: !showPassword.value,
                onSaved: (value) {
                  context["password"] = value;
                },
                suffixIcon: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 18, 0),
                    child: Icon(
                      !showPassword.value
                          ? FontAwesomeIcons.solidEyeSlash
                          : FontAwesomeIcons.solidEye,
                      color: color.withOpacity(0.5),
                      size: 21,
                    ),
                  ),
                  onTap: () {
                    showPassword.value = !showPassword.value;
                  },
                ),
                suffixIconConstraints:
                    const BoxConstraints(minHeight: 0, minWidth: 0),
                onSubmitted: (value) => onSubmitted(context, ref, module, form),
              ),
              Divid(color: color.withOpacity(0.75)),
              const Space.height(16),
              Indent(
                padding: EdgeInsets.symmetric(
                  horizontal: module.padding.horizontal / 2.0,
                ),
                children: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.navigator.pushNamed(
                          module.resetPage.apply(module),
                          arguments: RouteQuery.fade,
                        );
                      },
                      child: Text(
                        "Click here if you forget your password".localize(),
                        style: TextStyle(
                          color: color,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const Space.height(16),
                  FormItemButton(
                    "Login".localize(),
                    borderRadius: 35,
                    borderWidth: 1.6,
                    color: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: buttonBackgroundColor,
                    borderColor: buttonColor,
                    icon: Icons.check,
                    onPressed: () => onSubmitted(context, ref, module, form),
                  )
                ],
              ),
              const Space.height(24),
            ],
          ),
        ],
      ),
    );
  }

  Size? _imageSize(EmailLoginAndRegisterModule module) {
    if (module.formImageSize != null) {
      return module.formImageSize;
    }
    if (module.featureImageSize != null) {
      return module.featureImageSize! / 2.0;
    }
    return null;
  }

  @protected
  Future<void> onSubmitted(
    BuildContext context,
    WidgetRef ref,
    EmailLoginAndRegisterModule module,
    FormContext form,
  ) async {
    if (!form.validate()) {
      return;
    }
    try {
      await context.model
          ?.signInEmailAndPassword(
            email: context.get("email", ""),
            password: context.get("password", ""),
            userPath: module.userPath,
          )
          .showIndicator(context);
      context.navigator.pushReplacementNamed(
        module.redirectPage.apply(module),
      );
      if (module.runAfterFinishBootHooksOnRidirect) {
        Future.wait(
          Module.registeredHooks
              .map((e) => e.onAfterFinishBoot(context.navigator.context)),
        );
      }
    } catch (e) {
      UIDialog.show(
        context,
        title: "Error".localize(),
        text: "Could not login. Please check your email address and password."
            .localize(),
        submitText: "Close".localize(),
      );
    }
  }
}

class EmailLoginAndRegisterModuleRegisterPage
    extends PageModuleWidget<EmailLoginAndRegisterModule> {
  const EmailLoginAndRegisterModuleRegisterPage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    EmailLoginAndRegisterModule module,
  ) {
    final form = ref.useForm();
    final emailFocus = ref.useFocusNode(hookId: "email");
    final passFocus = ref.useFocusNode(hookId: "pass");
    final passConfirmFocus = ref.useFocusNode(hookId: "passConfirm");
    final showPassword = ref.state(hookId: "showPassword", false);
    final showPasswordConfirm = ref.state(hookId: "showPasswordConfirm", false);
    final role = module.menu.length <= 1
        ? module.menu.first
        : module.menu.firstWhere(
            (element) => element.path == context.get("role_id", ""),
          );

    final color = module.color ?? Colors.white;
    final buttonColor = module.buttonColor ?? module.color ?? Colors.white;
    final buttonBackgroundColor =
        module.buttonBackgroundColor ?? Colors.transparent;
    final imageSize = _imageSize(module);

    return Scaffold(
      backgroundColor: module.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: color,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _EmailLoginAndRegisterModuleBackgroundImage(module, opacity: 0.75),
          FormBuilder(
            type: FormBuilderType.center,
            key: form.key,
            padding: const EdgeInsets.all(0),
            children: [
              const Space.height(24),
              if (module.featureImage.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: imageSize?.width,
                    height: imageSize?.height,
                    child: ClipRRect(
                      borderRadius:
                          module.featureImageRadius ?? BorderRadius.zero,
                      child: Image(
                        image: Asset.image(module.featureImage!),
                        fit: module.featureImageFit,
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: Text(
                    role.name.isNotEmpty
                        ? "%s registration"
                            .localize()
                            .format([role.name.localize()])
                        : "Registration".localize(),
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5
                            ?.copyWith(color: module.color) ??
                        TextStyle(color: module.color),
                  ),
                ),
              const Space.height(36),
              DividHeadline(
                "Email".localize(),
                icon: Icons.email,
                color: color.withOpacity(0.75),
              ),
              FormItemTextField(
                dense: true,
                hintText: "Input %s".localize().format(["Email".localize()]),
                errorText:
                    "No input %s".localize().format(["Email".localize()]),
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                maxLength: 256,
                color: color,
                cursorColor: color,
                subColor: color.withOpacity(0.5),
                focusNode: emailFocus,
                onSaved: (value) {
                  context["email"] = value;
                },
                onSubmitted: (value) {
                  passFocus.requestFocus();
                },
              ),
              DividHeadline(
                "Password".localize(),
                icon: Icons.lock,
                color: color.withOpacity(0.75),
              ),
              FormItemTextField(
                dense: true,
                hintText: "Input %s".localize().format(["Password".localize()]),
                errorText:
                    "No input %s".localize().format(["Password".localize()]),
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
                minLength: 8,
                maxLength: 36,
                color: color,
                cursorColor: color,
                subColor: color.withOpacity(0.5),
                obscureText: !showPassword.value,
                onSaved: (value) {
                  context["password"] = value;
                },
                focusNode: passFocus,
                suffixIcon: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 18, 0),
                    child: Icon(
                      !showPassword.value
                          ? FontAwesomeIcons.solidEyeSlash
                          : FontAwesomeIcons.solidEye,
                      color: color.withOpacity(0.5),
                      size: 21,
                    ),
                  ),
                  onTap: () {
                    showPassword.value = !showPassword.value;
                  },
                ),
                suffixIconConstraints:
                    const BoxConstraints(minHeight: 0, minWidth: 0),
                onSubmitted: (value) {
                  passConfirmFocus.requestFocus();
                },
              ),
              DividHeadline(
                "ConfirmationPassword".localize(),
                icon: Icons.lock,
                color: color.withOpacity(0.75),
              ),
              FormItemTextField(
                dense: true,
                hintText: "Input %s".localize().format(["Password".localize()]),
                errorText:
                    "No input %s".localize().format(["Password".localize()]),
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
                minLength: 8,
                maxLength: 36,
                color: color,
                cursorColor: color,
                subColor: color.withOpacity(0.5),
                focusNode: passConfirmFocus,
                obscureText: !showPasswordConfirm.value,
                onSaved: (value) {
                  context["passwordConfirm"] = value;
                },
                suffixIcon: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 18, 0),
                    child: Icon(
                      !showPasswordConfirm.value
                          ? FontAwesomeIcons.solidEyeSlash
                          : FontAwesomeIcons.solidEye,
                      color: color.withOpacity(0.5),
                      size: 21,
                    ),
                  ),
                  onTap: () {
                    showPasswordConfirm.value = !showPasswordConfirm.value;
                  },
                ),
                suffixIconConstraints:
                    const BoxConstraints(minHeight: 0, minWidth: 0),
                onSubmitted: (value) {
                  onSubmitted(context, ref, module, form, role);
                },
              ),
              ...context.app?.userVariables.buildForm(
                    context: context,
                    ref: ref,
                    onlyRequired: module.showOnlyRequiredVariable,
                  ) ??
                  [],
              ...module.registerVariables.entries
                  .where((e) => e.key == role.path)
                  .expand((e) => e.value)
                  .buildForm(
                    context: context,
                    ref: ref,
                    onlyRequired: module.showOnlyRequiredVariable,
                  ),
              Divid(color: color.withOpacity(0.75)),
              if (context.app?.termsUrl != null)
                FormItemCheckbox(
                  dense: true,
                  needToCheck: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 4.5),
                  labelText: "Agree to the %s".localize().format([
                    "[${"Terms".localize()}](${context.app?.termsUrl})",
                  ]),
                  errorText: "Please agree to the %s"
                      .localize()
                      .format(["Terms".localize()]),
                  color: color,
                  checkColor: context.theme.textColorOnPrimary,
                  activeColor: context.theme.primaryColor,
                  linkTextStyle: TextStyle(
                    color: color,
                    decoration: TextDecoration.underline,
                  ),
                  onSaved: (value) {
                    context["terms"] = value;
                  },
                ),
              Divid(color: color.withOpacity(0.75)),
              const Space.height(24),
              Indent(
                padding: EdgeInsets.symmetric(
                  horizontal: module.padding.horizontal / 2.0,
                ),
                children: [
                  FormItemButton(
                    role.name.localize(),
                    borderRadius: 35,
                    borderWidth: 1.6,
                    color: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: buttonBackgroundColor,
                    borderColor: buttonColor,
                    icon: Icons.check,
                    onPressed: () =>
                        onSubmitted(context, ref, module, form, role),
                  )
                ],
              ),
              const Space.height(24),
            ],
          ),
        ],
      ),
    );
  }

  Size? _imageSize(EmailLoginAndRegisterModule module) {
    if (module.formImageSize != null) {
      return module.formImageSize;
    }
    if (module.featureImageSize != null) {
      return module.featureImageSize! / 2.0;
    }
    return null;
  }

  @protected
  Future<void> onSubmitted(
    BuildContext context,
    WidgetRef ref,
    EmailLoginAndRegisterModule module,
    FormContext form,
    MenuConfig role,
  ) async {
    if (await context.model?.skipRegistration(
          data: {
            module.roleKey: role.path,
          },
        ) ??
        false) {
      context.navigator.pushReplacementNamed(
        module.redirectPage.apply(module),
      );
      if (module.runAfterFinishBootHooksOnRidirect) {
        Future.wait(
          Module.registeredHooks
              .map((e) => e.onAfterFinishBoot(context.navigator.context)),
        );
      }
      return;
    }
    if (!form.validate()) {
      return;
    }
    if (context.get("password", "") != context.get("passwordConfirm", "")) {
      UIDialog.show(
        context,
        title: "Error".localize(),
        text: "Passwords do not match.".localize(),
        submitText: "Close".localize(),
      );
      return;
    }
    if (context.app?.termsUrl != null && !context.get("terms", false)) {
      UIDialog.show(
        context,
        title: "Error".localize(),
        text: "Please agree to the %s".localize().format(["Terms".localize()]),
        submitText: "Close".localize(),
      );
      return;
    }
    try {
      await context.model?.registerInEmailAndPassword(
        email: context.get("email", ""),
        password: context.get("password", ""),
        userPath: module.userPath,
        data: {
          module.roleKey: role.path,
          ...context.app?.userVariables.buildMap(
                context: context,
                ref: ref,
                onlyRequired: module.showOnlyRequiredVariable,
              ) ??
              {},
          ...module.registerVariables.entries
              .where((e) => e.key == role.path)
              .expand((e) => e.value)
              .buildMap(
                context: context,
                ref: ref,
                onlyRequired: module.showOnlyRequiredVariable,
              ),
        },
      ).showIndicator(context);
      UIDialog.show(
        context,
        title: "Complete".localize(),
        text: "Registration has been completed.".localize(),
        submitText: "Forward".localize(),
        onSubmit: () {
          context.navigator.pushReplacementNamed(
            module.redirectPage.apply(module),
          );
          if (module.runAfterFinishBootHooksOnRidirect) {
            Future.wait(
              Module.registeredHooks
                  .map((e) => e.onAfterFinishBoot(context.navigator.context)),
            );
          }
        },
      );
    } catch (e) {
      UIDialog.show(
        context,
        title: "Error".localize(),
        text:
            "Could not register. It may already be registered. Please check your email address and password again."
                .localize(),
        submitText: "Close".localize(),
      );
    }
  }
}

class EmailLoginAndRegisterModulePasswordResetPage
    extends PageModuleWidget<EmailLoginAndRegisterModule> {
  const EmailLoginAndRegisterModulePasswordResetPage();
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    EmailLoginAndRegisterModule module,
  ) {
    final form = ref.useForm();
    final emailFocus = ref.useFocusNode();

    final color = module.color ?? Colors.white;
    final buttonColor = module.buttonColor ?? module.color ?? Colors.white;
    final buttonBackgroundColor =
        module.buttonBackgroundColor ?? Colors.transparent;
    final imageSize = _imageSize(module);

    return Scaffold(
      backgroundColor: module.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: color,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _EmailLoginAndRegisterModuleBackgroundImage(module, opacity: 0.75),
          FormBuilder(
            type: FormBuilderType.center,
            key: form.key,
            padding: const EdgeInsets.all(0),
            children: [
              const Space.height(24),
              if (module.featureImage.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: imageSize?.width,
                    height: imageSize?.height,
                    child: ClipRRect(
                      borderRadius:
                          module.featureImageRadius ?? BorderRadius.zero,
                      child: Image(
                        image: Asset.image(module.featureImage!),
                        fit: module.featureImageFit,
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: Text(
                    "Password reset".localize(),
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5
                            ?.copyWith(color: module.color) ??
                        TextStyle(color: module.color),
                  ),
                ),
              const Space.height(24),
              MessageBox(
                "Email to reset your password will be sent to the email address you specified. Please reset your password from the link in the email you received."
                    .localize(),
                color: color,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const Space.height(24),
              DividHeadline(
                "Email".localize(),
                icon: Icons.email,
                color: color.withOpacity(0.75),
              ),
              FormItemTextField(
                dense: true,
                focusNode: emailFocus,
                hintText: "Input %s".localize().format(["Email".localize()]),
                errorText:
                    "No input %s".localize().format(["Email".localize()]),
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                maxLength: 256,
                color: color,
                cursorColor: color,
                subColor: color.withOpacity(0.5),
                onSaved: (value) {
                  context["email"] = value;
                },
                onSubmitted: (value) => onSubmitted(context, ref, module, form),
              ),
              Divid(color: color.withOpacity(0.75)),
              const Space.height(24),
              Indent(
                padding: EdgeInsets.symmetric(
                  horizontal: module.padding.horizontal / 2.0,
                ),
                children: [
                  FormItemButton(
                    "Send mail".localize(),
                    borderRadius: 35,
                    borderWidth: 1.6,
                    color: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: buttonBackgroundColor,
                    borderColor: buttonColor,
                    icon: Icons.send,
                    onPressed: () => onSubmitted(context, ref, module, form),
                  ),
                ],
              ),
              const Space.height(24),
            ],
          ),
        ],
      ),
    );
  }

  Size? _imageSize(EmailLoginAndRegisterModule module) {
    if (module.formImageSize != null) {
      return module.formImageSize;
    }
    if (module.featureImageSize != null) {
      return module.featureImageSize! / 2.0;
    }
    return null;
  }

  @protected
  Future<void> onSubmitted(
    BuildContext context,
    WidgetRef ref,
    EmailLoginAndRegisterModule module,
    FormContext form,
  ) async {
    if (!form.validate()) {
      return;
    }
    try {
      await context.model
          ?.sendPasswordResetEmail(
            email: context.get("email", ""),
          )
          .showIndicator(context);
      UIDialog.show(
        context,
        title: "Complete".localize(),
        text:
            "Password reset email has been sent to the specified email address. Please login again after resetting the password."
                .localize(),
        submitText: "Back".localize(),
        onSubmit: () {
          context.navigator.pop();
        },
      );
    } catch (e) {
      UIDialog.show(
        context,
        title: "Error".localize(),
        text:
            "The specified email address did not exist. Please check your email address."
                .localize(),
        submitText: "Close".localize(),
      );
    }
  }
}

class _EmailLoginAndRegisterModuleBackgroundImage extends StatelessWidget {
  const _EmailLoginAndRegisterModuleBackgroundImage(
    this.module, {
    this.opacity = 0.75,
  });
  final EmailLoginAndRegisterModule module;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (module.backgroundImage.isNotEmpty) ...[
          Image(
            image: Asset.image(module.backgroundImage!),
            fit: BoxFit.cover,
          ),
          if (module.backgroundImageBlur != null)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: module.backgroundImageBlur!,
                sigmaY: module.backgroundImageBlur!,
              ),
              child: _backgroundColor(context, opacity),
            )
          else
            _backgroundColor(context, opacity),
        ] else ...[
          _backgroundColor(context),
        ],
      ],
    );
  }

  Widget _backgroundColor(BuildContext context, [double opacity = 1.0]) {
    if (module.backgroundGradient != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: module.backgroundGradient,
        ),
      );
    } else if (opacity < 1.0) {
      return ColoredBox(
        color: (module.backgroundColor ?? context.theme.backgroundColor)
            .withOpacity(opacity),
      );
    } else {
      return ColoredBox(
        color: module.backgroundColor ?? context.theme.backgroundColor,
      );
    }
  }
}

class EmailLoginAndRegisterModuleRegisterAnonymousPage
    extends PageModuleWidget<EmailLoginAndRegisterModule> {
  const EmailLoginAndRegisterModuleRegisterAnonymousPage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    EmailLoginAndRegisterModule module,
  ) {
    final form = ref.useForm();

    return UIScaffold(
      designType: DesignType.material,
      appBar: UIAppBar(
        designType: DesignType.material,
        title: Text("Registration".localize()),
      ),
      body: FormBuilder(
        key: form.key,
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ...context.app?.userVariables.buildForm(
                context: context,
                ref: ref,
                onlyRequired: module.showOnlyRequiredVariable,
              ) ??
              [],
          ...module.registerVariables.entries
              .where((e) => e.key == "anonymous")
              .expand((e) => e.value)
              .buildForm(
                context: context,
                ref: ref,
                onlyRequired: module.showOnlyRequiredVariable,
              ),
          const Divid(),
          const Space.height(120),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!form.validate()) {
            return;
          }
          try {
            final userId = context.model?.userId;
            if (userId.isEmpty) {
              throw Exception("User id is not found.");
            }
            final collection = ref.readCollectionModel(module.userPath);
            final doc = collection.create(userId);
            context.app?.userVariables.setValue(
              target: doc,
              context: context,
              ref: ref,
              updated: false,
            );
            await doc.save().showIndicator(context);
            context.navigator.pushReplacementNamed(
              module.redirectPage.apply(module),
            );
            if (module.runAfterFinishBootHooksOnRidirect) {
              Future.wait(
                Module.registeredHooks
                    .map((e) => e.onAfterFinishBoot(context.navigator.context)),
              );
            }
          } catch (e) {
            UIDialog.show(
              context,
              title: "Error".localize(),
              text: "Invalid error.".localize(),
              submitText: "Close".localize(),
            );
          }
        },
        label: Text("Submit".localize()),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
