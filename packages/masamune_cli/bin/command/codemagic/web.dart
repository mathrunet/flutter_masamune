part of masamune_cli;

class CodemagicWebCliCommand extends CliCommand {
  const CodemagicWebCliCommand();

  @override
  String get description =>
      "masamune.yamlで指定したcodemagicの情報をWeb用の元にビルドスクリプトを作成します。予め`firebase login:ci`を実行し`token`の項目を入れておく必要があります。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final build = yaml["codemagic"] as YamlMap;
    final web = build["web"] as YamlMap;
    final token = web["token"] as String?;
    if (token.isEmpty) {
      print("Codemagic Web information is missing.");
      return;
    }
    var codemagic = File("codemagic.yaml").readAsStringSync();
    codemagic = codemagic.replaceAll(
        RegExp(r"(# )?CM_FIREBASE_TOKEN: [a-zA-Z0-9_=+/-]+"),
        "CM_FIREBASE_TOKEN: $token");
    codemagic = codemagic.replaceAll("# TODO_REPLACE_CODEMAGIC_WEB_SCRIPT", r"""
- |
        # build web
        cd .
        flutter build web --release --dart-define=FLAVOR=prod --web-renderer html
        cd build/web
        7z a -r ../web.zip ./*
        # Publishing web
        cp -R * ../../firebase/hosting/.
        cd ../../firebase
        firebase deploy --only hosting --token $CM_FIREBASE_TOKEN
          """);
    codemagic =
        codemagic.replaceAll("# TODO_REPLACE_CODEMAGIC_WEB_ARTIFACTS", """
- build/web.zip
          """);
    File("codemagic.yaml").writeAsStringSync(codemagic);
    var firebase = File("firebase/firebase.json").readAsStringSync();
    firebase = firebase.replaceAll("\"destination\": \"/en/index.html\"",
        "\"destination\": \"/index.html\"");
    File("firebase/firebase.json").writeAsStringSync(firebase);
  }
}
