// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of controller_method_impl.md.
///
/// controller_method_impl.mdの中身。
class ControllerMethodImplMdCliAiCode extends CliAiCode {
  /// Contents of controller_method_impl.md.
  ///
  /// controller_method_impl.mdの中身。
  const ControllerMethodImplMdCliAiCode();

  @override
  String get name => "`Controller`のメソッドの実装";

  @override
  String get globs => "lib/controllers/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Controller設計書`を用いた`Controller`のメソッドの中身の実装方法";

  @override
  String body(String baseName, String className) {
    final packageName = retrievePackageName();
    return """
`documents/designs/controller_design.md`に記載されている`Controller設計書`と`lib/controllers`に作成されているDartファイルを参照してすでに定義されている`Controller`のメソッドの中身を実装
`documents/designs/controller_design.md`が存在しない場合は絶対に実施しない

1. 対象のDartファイル（`lib/controllers`以下に[ControllerName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Controller設計書`の`Methods`に記載されているメソッドを内容に応じて実装。
    - 処理中に必要に応じて`Controller`中にミュータブルな変数を追加しても構わない。

    ```dart
    // lib/controllers/purchase.dart

    // ignore: unused_import, unnecessary_import
    import "package:flutter/material.dart";
    // ignore: unused_import, unnecessary_import
    import "package:masamune/masamune.dart";

    // ignore: unused_import, unnecessary_import
    import "package:$packageName/main.dart";

    part "purchase.m.dart";

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

      // カートの`Collection`を取得
      late final CartModelCollection cartCollection = appRef.collection(
        CartModel.collection(userId: userId)
      )..load();

      // トランザクションの`Collection`を取得
      late final TransactionCollection transactionCollection = appRef.collection(
        TransactionModel.collection()
      );

      // カートの商品をすべて取得する。
      Future<List<ModelRef<CartModel>>> getCart() async {
        return cartCollection;  
      }

      // カートに商品を追加する。
      Future<void> addCart(ModelRef<ProductModel> product) async {
        // カートに商品があるかどうかを検索
        final cart = cartCollection.where((element) => element.product.uid == product.uid).firstOrNull;
        if (cart != null) {
          // カートに商品があれば数量を増やす。
          await cart.save(
            CartModel(
              product: product,
              quantity: (cart.value?.quantity ?? 0) + 1,
            )
          );
        } else {
          // カートに商品を追加
          final cart = cartCollection.create(product.uid);
          await cart.save(
            CartModel(
              product: product,
              quantity: 1,
            )
          );
        }
      }
      
      // カートから商品を削除する。
      Future<void> removeCart(ModelRef<CartModel> product) async {
        // カートに商品があるかどうかを検索
        final cart = cartCollection.where((element) => element.product.uid == product.uid).firstOrNull;
        if (cart != null) {
          // カートに商品があれば数量を減らす。
          if (cart.value?.quantity == 1) {
            // カートに商品が1つしかない場合は商品を削除
            await cart.delete();
          } else {
            await cart.save(
              CartModel(
                product: product,
                quantity: (cart.value?.quantity ?? 2) - 1,
              )
            );
          }
        } else {
          // カートに商品がない場合は何もしない。
        }
      }

      // カートの商品を決済する。
      Future<void> checkout(ModelRef<PaymentMethodModel> paymentMethod, String address) async {
        // カートの商品をすべて取得
        final carts = await getCart();
        // トランザクションを作成
        final transaction = transactionCollection.create();
        // トランザクションを保存
        await transaction.save(
          TransactionModel(
            products: carts,
            paymentMethod: paymentMethod,
            address: address,
          )
        );
      }
    }
    ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
