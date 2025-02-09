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

1. 下記のコマンドを実行して`ChangeNotifier`を継承したクラスファイルを作成

    ```shell
    katana code controller [ControllerName(SnakeCase&末尾のControllerを取り除く)]
    ```

2. コマンド実行後、`lib/controllers`以下に[ControllerName(SnakeCase&末尾のControllerを取り除く)].dartファイルが作成される
3. 作成された`ChangeNotifier`を継承したクラス内の`// TODO: Define fields and processes.`以下に`Properties`に応じた`final`変数を定義
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
4. さらにクラス中に`Methods`に記載されているメソッドを内容に応じて実装。
    - 処理中に必要に応じてコントローラー中にミュータブルな変数を追加しても構わない。

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
""";
  }
}
