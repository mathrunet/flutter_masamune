part of masamune_cli;

class SigninGoogleCliCommand extends CliCommand {
  const SigninGoogleCliCommand();
  @override
  String get description =>
      "`firebase_options.dart`を元にGoogleアカウントでのログイン設定を行ないます。先に`masamune firebase init`のコマンドを実行してください。";
  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final options = firebaseOptions();
    if (options == null) {
      print(
        "firebase_options.dart is not found. Please run `masamune firebase init`",
      );
      return;
    }

    final domain = options.get("iosClientId", "");
    if (domain.isEmpty) {
      print("iosClientId from firebase_options.dart is invalid.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text =
          text.replaceAll("TODO_REPLACE_GOOGLE_OAUTH_REVERSE_DOMAIN", domain);
      text = text.replaceAll(
        "<!-- TODO_REPLACE_GOOGLE_OAUTH_REVERSE_DOMAIN_URL_SCHEME -->",
        r"""
<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>$(GOOGLE_OAUTH_REVERSE_DOMAIN)</string>
			</array>
		</dict>
        """,
      );
      text = text.replaceAll(
        "// TODO_REPLACE_GOOGLE_SERVICES_APPLY_PLUGIN",
        """
// Comment out using Google services (Firebase、Admob、Google OAuth、Map etc...)
            // [Firebase] [Firestore] [GoogleSignIn] [GoogleMap]
            // [FirebaseCrashlytics] [FirebaseAnalytics] [FirebaseDynamicLink] [FirebaseMessaging]
            apply plugin: 'com.google.gms.google-services'
            """,
      );
      text = text.replaceAll(
        "// TODO_REPLACE_GOOGLE_SERVICES_CLASSPASS",
        """
// Comment out using Google services (Firebase、Google OAuth、Map etc..)
            // [Firebase] [Firestore] [GoogleSignIn] [GoogleMap]
            // [FirebaseCrashlytics] [FirebaseAnalytics] [FirebaseDynamicLink] [FirebaseMessaging]
            classpath 'com.google.gms:google-services:4.3.3'
            """,
      );
      File(file.path).writeAsStringSync(text);
    });
  }
}
