import 'package:katana_cli/katana_cli.dart';

/// Contents of controller_impl.mdc.
///
/// controller_impl.mdcの中身。
class ControllerImplMdcCliAiCode extends CliAiCode {
  /// Contents of controller_impl.mdc.
  ///
  /// controller_impl.mdcの中身。
  const ControllerImplMdcCliAiCode();

  @override
  String get name => "Controllerの実装";

  @override
  String get globs => "lib/controllers/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Controller設計書`を用いた`Controller`の実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
[controller_design.md](mdc:documents/designs/controller_design.md)に記載されている`Controller設計書`からDartコードを生成
""";
  }
}
