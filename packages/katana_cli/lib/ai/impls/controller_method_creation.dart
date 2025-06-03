// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of controller_method_creation.md.
///
/// controller_method_creation.mdの中身。
class ControllerMethodCreationMdCliAiCode extends CliAiCode {
  /// Contents of controller_method_creation.md.
  ///
  /// controller_impl.mdの中身。
  const ControllerMethodCreationMdCliAiCode();

  @override
  String get name => "`Controller`のメソッドの作成";

  @override
  String get globs => "lib/controllers/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Controller設計書`を用いた`Controller`中のメソッドの作成方法";

  @override
  String body(String baseName, String className) {
    final packageName = retrievePackageName();
    return """
`documents/designs/controller_design.md`に記載されている`Controller設計書`と`lib/controllers`に作成されているDartファイルを参照して`Controller`のメソッドを作成
`documents/designs/controller_design.md`が存在しない場合は絶対に実施しない

1. 対象のDartファイル（`lib/controllers`以下に[ControllerName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Controller設計書`の`Methods`に記載されているメソッドを内容に応じて作成
    - メソッドの中身は`throw UnimplementedError();`とする

    ```dart
    // lib/controllers/purchase.dart

    // ignore: unused_import, unnecessary_import
    import 'package:flutter/material.dart';
    // ignore: unused_import, unnecessary_import
    import 'package:masamune/masamune.dart';

    // ignore: unused_import, unnecessary_import
    import 'package:$packageName/main.dart';

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
      static const query = _\$PurchaseControllerQuery();

      // カートの商品をすべて取得する。
      Future<List<ModelRef<CartModel>>> getCart() async {
        // TODO: Implement the method.
        throw UnimplementedError();
      }

      // カートに商品を追加する。
      Future<void> addCart(ModelRef<ProductModel> product) async {
        // TODO: Implement the method.
        throw UnimplementedError();
      }
      
      // カートから商品を削除する。
      Future<void> removeCart(ModelRef<CartModel> product) async {
        // TODO: Implement the method.
        throw UnimplementedError();
      }

      // カートの商品を決済する。
      Future<void> checkout(ModelRef<PaymentMethodModel> paymentMethod, String address) async {
        // TODO: Implement the method.
        throw UnimplementedError();
      }
    }
    ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
