import 'package:katana_cli/katana_cli.dart';

/// Contents of plugin_design.mdc.
///
/// plugin_design.mdcの中身。
class PluginDesignMdcCliAiCode extends CliAiCode {
  /// Contents of plugin_design.mdc.
  ///
  /// plugin_design.mdcの中身。
  const PluginDesignMdcCliAiCode();

  @override
  String get name => "プラグイン設計書の作成";

  @override
  String get globs => "documents/designs/plugin_design.md";

  @override
  String get directory => "designs";

  @override
  String get description => "Masamuneフレームワークによるプラグイン設計書の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[screen_design.md](mdc:documents/designs/screen_design.md)に記載されている`画面設計書`から`プラグイン設計書`を作成
""";
  }
}
