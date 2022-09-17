part of masamune_cli;

class MessagingFirebaseCliCommand extends CliCommand {
  const MessagingFirebaseCliCommand();

  @override
  String get description =>
      "`firebase_options.dart`を元にFirebase Messagingのアプリ側の初期設定を行ないます。先に`masamune firebase init`を実行してください。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
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
