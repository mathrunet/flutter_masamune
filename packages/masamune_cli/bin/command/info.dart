part of masamune_cli;

class InfoCliCommand extends CliCommand {
  const InfoCliCommand();

  @override
  String get description => "ストア登録を行ってもらう際の客先に提供するための情報をinformation.txtに保存します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final app = yaml.getAsMap("app");
    if (app.isEmpty) {
      print("App data could not be found.");
      return;
    }
    final id = app.get("bundle_id", "");
    final figerPrint =
        loadYaml(await File("android/app/fingerprint.yaml").readAsString());
    final sha1 = figerPrint.get("sha1", "");
    final base64 = figerPrint.get("base64_sha1", "");
    File("information.txt").writeAsStringSync(
      """
# 提供情報

- バンドルID
$id

- パッケージ名
$id

- キーハッシュ
$base64

- デバッグ用の署名証明書キー    
$sha1  

""",
    );
  }
}
