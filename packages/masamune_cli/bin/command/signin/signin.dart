part of masamune_cli;

class SigninCliCommand extends CliCommandGroup {
  const SigninCliCommand();

  @override
  String get groupDescription => "SNSログイン周りの設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "apple": SigninAppleCliCommand(),
        "google": SigninGoogleCliCommand(),
        "facebook": SigninFacebookCliCommand(),
      };
}
