import 'package:katana_cli/katana_cli.dart';

/// Login page template.
///
/// ログインページのテンプレート。
class PagesPageLoginCliCodeSnippet extends CliCodeSnippet {
  /// Login page template.
  ///
  /// ログインページのテンプレート。
  const PagesPageLoginCliCodeSnippet();

  @override
  String get name => "PagesPageLogin";

  @override
  String get prefix => "@pages/page/login";

  @override
  String get description => "Login page template. ログインページのテンプレート。";

  @override
  String body(String path, String baseName, String className) {
    return r"""return SafeArea(
  child: Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Spacer(flex: 1),
      Expanded(
        flex: 10,
        child: ClipRRect(
          borderRadius: 16.r,
          child: Image(
            image: theme.asset.image.provider,
            width: 128,
            height: 128,
          ),
        ),
      ),
      Expanded(
        flex: 6,
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                label: Text(l().signInWith.$(l().google)),
                icon: Icon(
                  FontAwesomeIcons.google,
                  color: authFormButtonStyle.foregroundColor?.resolve({}),
                ),
                style: authFormButtonStyle,
                onPressed: () async {
                  executeGuarded(
                    context,
                    () async {
                      // TODO: Uncomment when Firebase is integrated
                      // await appAuth.signIn(
                      //   const FirebaseGoogleSignInAuthProvider(),
                      // );
                      router.replace(IndexPage.query());
                    },
                    onError: (error, stackTrace) {
                      debugPrint(error.toString());
                      Modal.alert(
                        context,
                        submitText: l().close,
                        title: l().error,
                        text: l().$(l().login).hasFailed,
                      );
                    },
                  );
                },
              ),
              if (UniversalPlatform.isIOS) ...[
                16.sy,
                OutlinedButton.icon(
                  label: Text(l().signInWith.$(l().apple)),
                  icon: Icon(
                    FontAwesomeIcons.apple,
                    color: authFormButtonStyle.foregroundColor?.resolve({}),
                  ),
                  style: authFormButtonStyle,
                  onPressed: () async {
                    executeGuarded(
                      context,
                      () async {
                        // TODO: Uncomment when Firebase is integrated
                        // await appAuth.signIn(
                        //   const FirebaseAppleSignInAuthProvider(),
                        // );
                        router.replace(IndexPage.query());
                      },
                      onError: (error, stackTrace) {
                        Modal.alert(
                          context,
                          submitText: l().close,
                          title: l().error,
                          text: l().$(l().login).hasFailed,
                        );
                      },
                    );
                  },
                ),
              ],
              8.sy,
            ],
          ),
        ),
      ),
      const Spacer(flex: 1),
    ],
  ),
);
""";
  }
}
