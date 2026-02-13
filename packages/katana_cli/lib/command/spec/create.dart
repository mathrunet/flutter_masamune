part of "spec.dart";

/// Create a specification yaml file.
///
/// 仕様書yamlの作成を行います。
class SpecCreateCliCommand extends CliCommand {
  /// Create a specification yaml file.
  ///
  /// 仕様書yamlの作成を行います。
  const SpecCreateCliCommand();

  @override
  String get description =>
      "Create a specification yaml file. 仕様書yamlの作成を行います。";

  @override
  String? get example => "katana spec create";

  @override
  Future<void> exec(ExecContext context) async {
    label("Create a katana_spec.yaml");
    await const KatanaSpecCliCode(true).generateFile("katana_spec.yaml");
  }
}

/// Contents of katana_spec.yaml.
///
/// katana_spec.yamlの中身。
class KatanaSpecCliCode extends CliCode {
  /// Contents of katana_spec.yaml.
  ///
  /// katana_spec.yamlの中身。
  const KatanaSpecCliCode(this.showAllConfig);

  /// `true` to show all settings.
  ///
  /// すべての設定を表示する場合は`true`。
  final bool showAllConfig;

  @override
  String get name => "katana_spec";

  @override
  String get prefix => "katana_spec";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create katana_spec.yaml for katana_cli. katana_cli用のkatana_spec.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return katanaSpecYamlCode(showAllConfig);
  }
}
