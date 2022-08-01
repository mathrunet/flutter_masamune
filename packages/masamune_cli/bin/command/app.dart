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
    final id = app["bundle_id"] as String?;
    final appId = (app["app_id"] as int?).toString();
    final title = app["title"] as String?;
    final titleShort = app["short_title"] as String?;
    final description = app["description"] as String?;
    final email = app["email"] as String?;
    final color = app["color"] as String?;
    final url = app["url"] as String?;
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
