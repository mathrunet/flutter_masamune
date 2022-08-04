part of masamune_cli;

class SigninAppleCliCommand extends CliCommand {
  const SigninAppleCliCommand();
  @override
  String get description =>
      "`GoogleService-Info.plist`を元にIOSでのみに利用可能なAppleIDログインの設定を行います。";
  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final file = File("ios/Runner/GoogleService-Info.plist");
    if (!file.existsSync()) {
      print("GoogleService-Info.plist could not be found in ios/Runner.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll(
        "<!-- TODO_REPLACE_IOS_APPLE_SIGNIN -->",
        """
<key>com.apple.developer.applesignin</key>
	<array>
		<string>Default</string>
	</array>
            """,
      );
      File(file.path).writeAsStringSync(text);
    });
  }
}
