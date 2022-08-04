part of masamune_cli;

class AppCliCommand extends CliCommand {
  const AppCliCommand();

  @override
  String get description =>
      "masamune.yamlで指定したアプリケーションのバンドルIDや名前、説明、メールアドレスなどを設定します。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final app = yaml["app"] as YamlMap;
    if (app.isEmpty) {
      print("App data could not be found.");
      return;
    }
    var found = [];
    final information = yaml["information"] as String?;
    final account = app["account"] as String?;
    final id = app["bundle_id"] as String?;
    if (id.isEmpty) {
      print("bundle_id could not be found.");
      return;
    }
    if (information != null && account.isNotEmpty) {
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
        final id = line[1] as String;
        if (id.isEmpty || id != account) {
          continue;
        }
        found = line;
      }
    }
    final appId = (app["app_id"] as int?).toString();
    final title = app["title"] as String? ?? found[4];
    final titleShort = app["short_title"] as String? ?? found[3];
    if (title.isEmpty || titleShort.isEmpty) {
      print("title could not be found.");
      return;
    }
    final description = app["description"] as String? ?? found[5];
    final email = app["email"] as String? ?? found[8];
    final color = app["color"] as String?;
    final url = app["url"] as String? ?? found[9];
    final image = app["image"] as String?;
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      if (id.isNotEmpty) {
        text = text.replaceAll("net.mathru.xxx", id!);
      }
      if (appId.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_APPLE_APPID", appId);
      }
      if (title.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_NAME_TEMPLATE", title!);
      }
      if (titleShort.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_SHORT_NAME_TEMPLATE", titleShort!);
      }
      if (description.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_TEXT_TEMPLATE", description!);
      }
      if (email.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_SUPPORT_EMAIL", email!);
      }
      if (url.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_URL_TEMPLATE", url!);
      }
      if (image.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_IMAGE_TEMPLATE", image!);
      }
      if (color.isNotEmpty) {
        text = text.replaceAll("TODO_REPLACE_COLOR_TEMPLATE", "#${color!}");
      }
      File(file.path).writeAsStringSync(text);
    });
  }
}
