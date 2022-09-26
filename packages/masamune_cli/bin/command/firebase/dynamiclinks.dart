part of masamune_cli;

class FirebaseDynamicLinksCliCommand extends CliCommand {
  const FirebaseDynamicLinksCliCommand();

  @override
  String get description =>
      "`firebase_options.dart`を元にFirebase DynamicLinksのアプリ側の初期設定を行ないます。先に`masamune firebase init`を実行してください。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final firebase = yaml.getAsMap("firebase");
    final dynamicLinks = firebase.getAsMap("dynamic_links");
    final domain = dynamicLinks.get("domain", "");
    if (domain.isEmpty) {
      print("firebase/dynamic_links/domain is empty.");
      return;
    }
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
        "<!-- TODO_REPLACE_IOS_FIREBASE_DYNAMIC_LINKS -->",
        """
<key>com.apple.developer.associated-domains</key>
	<array>
		<string>applinks:$domain</string>
	</array>
            """,
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_ANDROID_FIREBASE_DYNAMIC_LINKS -->",
        """
<intent-filter>
                <action android:name="android.intent.action.VIEW"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <data
                    android:host="$domain"
                    android:scheme="https"/>
            </intent-filter>
            """,
      );
      File(file.path).writeAsStringSync(text);
    });
  }
}
