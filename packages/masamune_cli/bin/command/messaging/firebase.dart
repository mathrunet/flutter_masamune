part of masamune_cli;

class MessagingFirebaseCliCommand extends CliCommand {
  const MessagingFirebaseCliCommand();

  @override
  String get description =>
      "`google-services.json`や`GoogleService-Info.plist`を元にFirebase Messagingのアプリ側の初期設定を行ないます。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
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
      text = text.replaceAll(
        "<!-- TODO_REPLACE_IOS_FIREBASE_MESSAGING -->",
        """
<key>aps-environment</key>
	<string>development</string>
            """,
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_ANDROID_FIREBASE_MESSAGING -->",
        """
<!-- Firebase Messaging configuration -->
        <!-- [Firebase] [FirebaseMessaging] -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="@string/notification_channel_id" />
            """,
      );
      File(file.path).writeAsStringSync(text);
    });
  }
}
