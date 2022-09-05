part of masamune_cli;

class SigninGoogleCliCommand extends CliCommand {
  const SigninGoogleCliCommand();
  @override
  String get description =>
      "`GoogleService-Info.plist`を元にGoogleアカウントでのログイン設定を行ないます。";
  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final file = File("ios/Runner/GoogleService-Info.plist");
    if (!file.existsSync()) {
      print("GoogleService-Info.plist could not be found in ios/Runner.");
      return;
    }
    final plist = file.readAsStringSync();
    final match = RegExp(r"com.googleusercontent.apps.[^<]+").firstMatch(plist);
    if (match == null) {
      print("GoogleService-Info.plist is invalid.");
      return;
    }
    final domain = match.group(0);
    if (domain == null) {
      print("GoogleService-Info.plist is invalid.");
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
