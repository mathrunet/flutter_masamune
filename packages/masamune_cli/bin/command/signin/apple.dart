part of masamune_cli;

class SigninAppleCliCommand extends CliCommand {
  const SigninAppleCliCommand();
  @override
  String get description =>
      "`firebase_options.dart`を元にAppleIDログインの設定を行います。先に`masamune firebase init`のコマンドを実行してください。";
  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final options = firebaseOptions();
    if (options == null) {
      print(
        "firebase_options.dart is not found. Please run `masamune firebase init`",
      );
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
      text = text.replaceAll(
        "<!-- TODO_REPLACE_WEB_APPLE_SIGNIN -->",
        """
<script type="text/javascript" src="https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js"></script>
            """,
      );

      File(file.path).writeAsStringSync(text);
    });
  }
}
