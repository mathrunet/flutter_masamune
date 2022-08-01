part of masamune_cli;

class FirebaseDynamicLinksCliCommand extends CliCommand {
  const FirebaseDynamicLinksCliCommand();

  @override
  String get description =>
      "`google-services.json`や`GoogleService-Info.plist`を元にFirebase DynamicLinksのアプリ側の初期設定を行ないます。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final firebase = yaml["firebase"] as YamlMap;
    final dynamicLinks = firebase["dynamic_links"] as YamlMap;
    final domain = dynamicLinks["domain"] as String?;
    if (domain.isEmpty) {
      print("Firebase dynamic links domain is empty.");
      return;
    }
    final json = File("android/app/google-services.json");
    if (!json.existsSync()) {
      print("google-services.json could not be found in android/app.");
      return;
    }
    final file = File("ios/Runner/GoogleService-Info.plist");
    if (!file.existsSync()) {
      print("GoogleService-Info.plist could not be found in ios/Runner.");
      return;
    }

    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text
          .replaceAll("<!-- TODO_REPLACE_IOS_FIREBASE_DYNAMIC_LINKS -->", """
<key>com.apple.developer.associated-domains</key>
	<array>
		<string>applinks:$domain</string>
	</array>
            """);
      text = text.replaceAll(
          "<!-- TODO_REPLACE_ANDROID_FIREBASE_DYNAMIC_LINKS -->", """
<intent-filter>
                <action android:name="android.intent.action.VIEW"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <data
                    android:host="$domain"
                    android:scheme="https"/>
            </intent-filter>
            """);
      File(file.path).writeAsStringSync(text);
    });
  }
}
