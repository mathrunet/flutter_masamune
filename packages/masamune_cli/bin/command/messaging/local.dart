part of masamune_cli;

class MessagingLocalCliCommand extends CliCommand {
  const MessagingLocalCliCommand();

  @override
  String get description => "ローカルプッシュ用の初期設定を行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("// TODO_REPLACE_IOS_LOCAL_MESSAGING", """
// flutter_local_notification
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
            """);
      File(file.path).writeAsStringSync(text);
    });
  }
}
