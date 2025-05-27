// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of controller_creation.md.
///
/// controller_creation.mdの中身。
class ControllerCreationMdCliAiCode extends CliAiCode {
  /// Contents of controller_creation.md.
  ///
  /// controller_creation.mdの中身。
  const ControllerCreationMdCliAiCode();

  @override
  String get name => "`Controller`の作成";

  @override
  String get globs => "lib/controllers/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Controller設計書`を用いた`Controller`の作成方法";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/controller_design.md`に記載されている`Controller設計書`からDartコードを生成
`documents/designs/controller_design.md`が存在しない場合は絶対に実施しない

1. 下記のコマンドを実行して`ChangeNotifier`を継承したクラスファイルを作成

    ```shell
    katana code controller [ControllerName(SnakeCase&末尾のControllerを取り除く)]
    ```

2. コマンド実行後、`lib/controllers`以下に[ControllerName(SnakeCase&末尾のControllerを取り除く)].dartファイルが作成される
3. `ChangeNotifier`を継承したクラス内の`// TODO: Define fields and processes.`以下に`Controller設計書`の`Properties`に応じた`final`変数を定義
    - プロパティの状態に応じて下記を実施
        - `RequiredOrOptional`が`Required`な場合は先頭に`required`をつける
        - `DefaultValue`な場合は末尾に`= [DefaultValue]`をつける
    - 例：
        ```dart
        // lib/controllers/purchase.dart

        // ignore: unused_import, unnecessary_import
        import 'package:flutter/material.dart';
        // ignore: unused_import, unnecessary_import
        import 'package:masamune/masamune.dart';

        // ignore: unused_import, unnecessary_import
        import '/main.dart';

        part 'purchase.m.dart';

        /// Controller.
        @Controller(autoDisposeWhenUnreferenced: true)
        class PurchaseController extends ChangeNotifier {
          PurchaseController(
            // TODO: Define some arguments.
            required this.userId,
          );

          // TODO: Define fields and processes.
          final String userId;      

          /// Query for PurchaseController.
          ///
          /// ```dart
          /// appRef.controller(PurchaseController.query(parameters));     // Get from application scope.
          /// ref.app.controller(PurchaseController.query(parameters));    // Watch at application scope.
          /// ref.page.controller(PurchaseController.query(parameters));   // Watch at page scope.
          /// ```
          static const query = _$PurchaseControllerQuery();
        }
        ```
""";
  }
}
