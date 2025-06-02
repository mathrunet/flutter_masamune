// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of controller_impl.md.
///
/// controller_impl.mdの中身。
class ControllerImplMdCliAiCode extends CliAiCode {
  /// Contents of controller_impl.md.
  ///
  /// controller_impl.mdの中身。
  const ControllerImplMdCliAiCode();

  @override
  String get name => "`Controller`の実装";

  @override
  String get globs => "lib/controllers/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Controller設計書`を用いた`Controller`の作成方法";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/*.md`に記載されている各種`設計書`からコードを実装
下記の順番通りにステップごとに実施

1. `Controller`の作成
    - `documents/rules/impls/controller_creation.md`を参照して、`Controller`を作成
2. `Controller`の各種メソッドの作成
    - 1で作成した`Controller`に対して、`documents/rules/impls/controller_method_creation.md`を参照して、`Controller`の各種メソッドを作成
3. `Controller`の実装
    - 1で作成した`Controller`と2で作成した各種メソッドに対して、`documents/rules/impls/controller_method_impl.md`を参照して、`Controller`の各種メソッドの中身を実装
""";
  }
}
