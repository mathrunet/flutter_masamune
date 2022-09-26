part of masamune_cli;

class AdsAdmobCliCommand extends CliCommand {
  const AdsAdmobCliCommand();
  @override
  String get description => "masamune.yamlで指定した`AppID`を元にAdmobの初期設定を行ないます。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final ads = yaml.getAsMap("ads");
    if (ads.isEmpty) {
      print("Ads data could not be found.");
      return;
    }
    final admob = ads.getAsMap("admob");
    if (admob.isEmpty) {
      print("Admob data could not be found.");
      return;
    }
    final android = admob.get("android_app_id", "");
    final ios = admob.get("ios_app_id", "");
    if (android.isEmpty || ios.isEmpty) {
      print("Admob settings could not be found.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("TODO_REPLACE_ADMOB_ANDROID_APP_ID", android);
      text = text.replaceAll("TODO_REPLACE_ADMOB_IOS_APP_ID", ios);
      text = text.replaceAll(
        "<!-- TODO_REPLACE_ADMOB_MANIFEST -->",
        """
<!-- Admob configuration -->
        <!-- [GoogleAdmob] -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="@string/admob_app_id"/>
        """,
      );
      File(file.path).writeAsStringSync(text);
    });
  }
}
