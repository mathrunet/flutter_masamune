part of masamune_cli;

class LocalizeCliCommand extends CliCommand {
  const LocalizeCliCommand();

  @override
  String get description =>
      "masamune.yamlで指定したGoogleSpreadSheetのURLを元にローカライズ用ファイルを作成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final url = yaml["localize"] as String;
    if (url.isEmpty) {
      print("Localize url could not be found.");
      return;
    }
    final endpoint =
        url.replaceAllMapped(RegExp(r"/edit(#gid=([0-9]+))?$"), (match) {
      final gid = match.group(2);
      if (gid.isEmpty) {
        return "/export?format=csv";
      }
      return "/export?format=csv&gid=$gid";
    });
    print("Load from $endpoint");
    final request = await HttpClient().getUrl(Uri.parse(endpoint));
    final response = await request.close();
    await response.pipe(File("assets/Localization.csv").openWrite());
    print("Convert to code-snippets");
    final csv = await File("assets/Localization.csv").readAsString();
    final raw = const CsvToListConverter().convert(csv);
    final snippets = <String, dynamic>{};
    for (final line in raw) {
      if (line.length <= 1) {
        continue;
      }
      final id = line[0] as String;
      if (id.isEmpty || id.startsWith("#")) {
        continue;
      }
      snippets["Localize $id"] = {
        "prefix": ["lang $id"],
        "body": ["\"$id\".localize()"],
      };
    }
    if (snippets.isNotEmpty) {
      await File(".vscode/localize.code-snippets")
          .writeAsString(jsonEncode(snippets));
    }
    print("Loading is success!!");
  }
}
