// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of controller_design.mdc.
///
/// controller_design.mdcの中身。
class ControllerDesignMdcCliAiCode extends CliAiCode {
  /// Contents of controller_design.mdc.
  ///
  /// controller_design.mdcの中身。
  const ControllerDesignMdcCliAiCode();

  @override
  String get name => "`Controller設計書`の作成";

  @override
  String get description => "`Controller設計`の方法と`Controller設計書`の作成";

  @override
  String get globs => "documents/designs/**/*.md";

  @override
  String get directory => "designs";

  @override
  String body(String baseName, String className) {
    return r"""
[page_design.md](mdc:documents/designs/page_design.md)に記載されている`Page設計書`および[model_design.md](mdc:documents/designs/model_design.md)に記載されている`Model設計書`から`Controller設計書`を作成

1. `Page設計書`において`Controller設計書`を作成
    - 下記の条件に当てはまる場合、新しく`Controller`を定義
        - 複数の`Page`に跨る処理が必要
        - 複数の`Model`や`Plugin`を連携させた処理が必要
    - 当てはまらない場合無理に定義しない
    - 下記条件に当てはまる場合は必ず除外する
        - 複数の`Controller`をまとめるだけの場合
        - 単一の`Model`を利用するだけの場合
            - `Model`の状態は`Model`内で維持されるため`Controller`で状態を維持する必要はない
            - `Model`のCRUD（Create、Read、Update、Delete）処理は`Model`の機能として提供されるため`Controller`内では必要ない
            - `Model`のフィルタリングも`Model`の機能として提供されるため`Controller`内では必要ない
        - 単一の`Page`を利用するだけの場合
    - 各々の`Controller`に対して定義
        - `ControllerName`
            - 末尾に`Controller`はつけない形でPascalCaseで定義
        - `Summary`
            - `Controller`の概要を記載
        - `Properties`
            - `Controller`に渡すプロパティを定義
                - ない場合は無理に定義しない
            - 各`Property`に対して下記を定義
                - `PropertyName`
                    - プロパティの名前をCamelCaseで定義
                - `PropertyType`
                    - プロパティの型を定義。**必ず**下記から選択。
                        - [ModelFieldValue](mdc:.cursor/rules/docs/model_field_value_usage.mdc)
                        - [プリミティブタイプ](mdc:.cursor/rules/docs/primitive_types.mdc)
                        - [Flutter特有のタイプ](mdc:.cursor/rules/docs/flutter_types.mdc)
                - `RequiredOrOptional`
                    - `Required`もしくは`Optional`
                - `DefaultValue`
                    - `Optional`の場合入力されなかった場合のデフォルトの値を定義
                - `Summary`
                    - プロパティの概要
        - `Methods`
            - `Controller`に必要なメソッドを定義
                - ない場合は無理に定義しない
            - 各`Method`に対して下記を定義
                - `MethodName`
                    - メソッドの名前をCamelCaseで定義
                - `Arguments`
                    - メソッドの引数を定義
                        - ない場合は無理に定義しない
                    - 各`Argument`に対して下記を定義
                        - `ArgumentName`
                            - 引数の名前をCamelCaseで定義
                        - `ArgumentType`
                            - 引数の型を定義
                                - ある場合は**必ず**下記から選択。
                                    - [ModelFieldValue](mdc:.cursor/rules/docs/model_field_value_usage.mdc)
                                    - [プリミティブタイプ](mdc:.cursor/rules/docs/primitive_types.mdc)
                                    - [Flutter特有のタイプ](mdc:.cursor/rules/docs/flutter_types.mdc)
                                - ない場合は`void`とし無理に定義しない。また非同期で戻り値が必要な場合は`Future<[ArgumentType]>`とする。
                        - `Summary`
                            - 引数の概要
                - `ReturnType`
                    - メソッドの戻り値のタイプを定義
                        - ない場合は`void`とし無理に定義しない。また非同期で戻り値が必要な場合は`Future<[戻り値のタイプ]>`とする。
                - `Summary`
                    - メソッドの概要を記載
    - 例：
      ```markdown
      <!-- documents/designs/controller_design.md -->

      ## 購入コントローラー

      ### ControllerName

      `PurchaseController`

      ### Summary

      商品をカートに入れ管理し決済まで行うためのコントローラー。

      ### Properties

      | PropertyName | PropertyType | RequiredOrOptional | DefaultValue | Summary |
      | --- | --- | --- | --- | --- |
      | `userId` | String | Required |  | コントローラーを利用するユーザーのID。 |

      ### Methods

      | MethodName | Arguments | ReturnType | Summary |
      | --- | --- | --- | --- |
      | addCart | `product`:`ModelRef<ProductModel>` | `Future<void>` | カートに商品を追加する |
      | removeCart | `product`:`ModelRef<CartModel>` | `Future<void>` | カートから商品を削除する |
      | getCart | | `Future<List<ModelRef<CartModel>>>` | カートの商品をすべて取得する。 |
      | checkout | `paymentMethod`:`ModelRef<PaymentMethodModel>`, `address`: `String` | `Future<void>` | 支払い方法および配送先住所を指定し現在のカートの商品を決済する。 |
      ```
2. 作成した`Controller設計書`は`documents/designs/controller_design.md`に保存
""";
  }
}
