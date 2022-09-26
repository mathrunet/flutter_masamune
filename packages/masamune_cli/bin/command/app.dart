part of masamune_cli;

class AppCliCommand extends CliCommand {
  const AppCliCommand();

  @override
  String get description =>
      "masamune.yamlで指定したアプリケーションのバンドルIDや名前、説明、メールアドレスなどを設定します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final app = yaml.getAsMap("app");
    if (app.isEmpty) {
      print("App data could not be found.");
      return;
    }
    var found = List<String>.generate(10, (index) => "");
    final information = yaml.get("information", "");
    final account = yaml.get("account", "");
    final id = app.get("bundle_id", "");
    if (id.isEmpty) {
      print("bundle_id could not be found.");
      return;
    }
    if (information.isNotEmpty && account.isNotEmpty) {
      final endpoint = information
          .replaceAllMapped(RegExp(r"/edit(#gid=([0-9]+))?$"), (match) {
        final gid = match.group(2);
        if (gid.isEmpty) {
          return "/export?format=csv";
        }
        return "/export?format=csv&gid=$gid";
      });
      print("Load from $endpoint");
      final request = await HttpClient().getUrl(Uri.parse(endpoint));
      final response = await request.close();
      final csv = await response.transform(utf8.decoder).join();
      final raw = const CsvToListConverter().convert(csv);
      for (int i = 1; i < raw.length; i++) {
        final line = raw[i];
        if (line.length <= 1) {
          continue;
        }
        final id = line.get(1, "");
        if (id.isEmpty || id != account) {
          continue;
        }
        found = line.map((e) => e.toString()).toList();
      }
    }
    final appId = (app["apple_app_id"] as int?).toString();
    final title = app.get("title", found.get(4, ""));
    final titleShort = app.get("short_title", found.get(3, ""));
    if (title.isEmpty || titleShort.isEmpty) {
      print("title could not be found.");
      return;
    }
    final description = app.get("description", found.get(5, ""));
    final email = app.get("email", found.get(8, ""));
    final color = app.get("color", "");
    final url = app.get("url", found.get(9, ""));
    final image = app.get("image", "");
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      if (id.isNotEmpty) {
        text = text.replaceAll("net.mathru.xxx", id);
      }
      if (appId.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_APPLE_APPID", appId);
      }
      if (title.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_NAME_TEMPLATE", title);
      }
      if (titleShort.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_SHORT_NAME_TEMPLATE", titleShort);
      }
      if (description.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_TEXT_TEMPLATE", description);
      }
      if (email.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_SUPPORT_EMAIL", email);
      }
      if (url.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_URL_TEMPLATE", url);
      }
      if (image.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_IMAGE_TEMPLATE", image);
      }
      if (color.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_COLOR_TEMPLATE", "#$color");
      }
      File(file.path).writeAsStringSync(text);
    });
  }
}
