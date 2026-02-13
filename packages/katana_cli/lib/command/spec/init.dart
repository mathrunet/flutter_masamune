part of "spec.dart";

/// Initialize with katana_spec.yaml.
///
/// katana_spec.yamlを用いた初期化を行います。
class SpecInitCliCommand extends CliCommand {
  /// Initialize with katana_spec.yaml.
  ///
  /// katana_spec.yamlを用いた初期化を行います。
  const SpecInitCliCommand();

  @override
  String get description =>
      "Initialize with katana_spec.yaml. katana_spec.yamlを用いた初期化を行います。";

  @override
  String? get example => "katana spec init";

  @override
  Future<void> exec(ExecContext context) async {
    label("Create a katana_spec.yaml");
    await const KatanaSpecCliCode(true).generateFile("katana_spec.yaml");
  }
}
