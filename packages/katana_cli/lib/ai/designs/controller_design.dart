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
  String get name => "Controller設計書の作成";

  @override
  String get description => "MasamuneフレームワークによるController設計書の作成";

  @override
  String get globs => "*.md";

  @override
  String get directory => "designs";

  @override
  String body(String baseName, String className) {
    return r"""
[screen_design.md](mdc:documents/designs/screen_design.md)に記載されている`画面設計書`および[model_design.md](mdc:documents/designs/model_design.md)に記載されている`モデル設計書`から`Controller設計書`を作成

1. `画面設計書`において`Controller設計書`を作成
    - 下記の条件に当てはまる場合、新しくControllerを定義
        - 複数の画面に跨る処理が必要
        - 複数の`モデル`や`プラグイン`を連携させた処理が必要
    - 当てはまらない場合無理に定義しない
    - 下記条件に当てはまる場合は必ず除外する
        - 複数のControllerをまとめるだけの場合
        - 単一の`モデル`を利用するだけの場合
            - `モデル`の状態はモデル内で維持されるためControllerで状態を維持する必要はない
            - `モデル`のCRUD（Create、Read、Update、Delete）処理はモデルの機能として提供されるためController内では必要ない
            - `モデル`のフィルタリングもモデルの機能として提供されるためController内では必要ない
        - 単一の`画面`を利用するだけの場合
    - 各々のControllerに対して定義
        - `Controller名`
            - 末尾にControllerはつけない形でPascalCaseで定義
        - `概要`
            - Controllerの概要を記載
        - `プロパティ`
            - Controllerに渡すプロパティを定義
                - ない場合は無理に定義しない
            - 各`プロパティ`に対して下記を定義
                - `プロパティ名`
                    - プロパティの名前をCamelCaseで定義
                - `タイプ`
                    - プロパティの型を定義。下記から選択。
                    | タイプ | 概要 |
                    | --- | --- |
                    | `String` | 文字列。 |
                    | `int` | 整数。 |
                    | `double` | 小数。 |
                    | `bool` | 真偽値。 |
                    | `enum` | 列挙体。`katana code enum xxxx`でコードを出力した後`enum XxxEnum {}`にて定義された列挙体名が入る。選択肢が限られている場合はこちらを優先して利用。 |
                    | `List<[タイプ]>` | タイプを配列として複数持ちたい場合に利用。[タイプ]にはListも含めたその他タイプが入る。 |
                    | `Map<String, [タイプ]>` | タイプを連想配列として複数持ちたい場合に利用。キーには必ず`String`が入り[タイプ]にはMapも含めたその他タイプが入る。 |
                    | `Set<[タイプ]>` | タイプを重複禁止の配列として複数持ちたい場合に利用。[タイプ]にはSetも含めたその他タイプが入る。 |
                    | `ModelRef<[モデル名]>` | 他モデルへの参照を行いたい場合はそのモデル名を指定して定義。 |
                    | `ModelCounter` | カウントアップ、カウントダウンを正確に行いたい場合の整数を定義する際に優先して利用。 |
                    | `ModelTimestamp` | 日時を定義する際に優先して利用。Dartの`DateTime`を利用する場合こちらに必ず変換 |
                    | `ModelDate` | 日付のみを定義する際に優先して利用。 |
                    | `ModelUri` | 画像や映像以外のURLやURIを保存する際に優先して利用。 |
                    | `ModelImageUri` | 画像のURLやURIを保存する際に優先して利用。 |
                    | `ModelVideoUri` | 映像のURLやURIを保存する際に優先して利用。 |
                    | `ModelGeoValue` | 位置情報（緯度、経度）を保存する際に優先して利用。 |
                    | `ModelLocale` | ロケール（`ja_JP`、`en_US`等）を保存する際に優先して利用。 |
                    | `ModelLocalizedValue` | 各ロケールに対応した文字列を保存する際に利用。 |
                    | `ModelSearch` | 検索対象となる文字列のリストを保存する際に利用。 |
                    | `ModelToken` | Push通知のトークンなど複数トークンを保存する際に優先して利用。 |
        - `メソッド`
            - Controllerに必要なメソッドを定義
                - ない場合は無理に定義しない
            - 各`メソッド`に対して下記を定義
                - `メソッド名`
                    - メソッドの名前をCamelCaseで定義
                - `引数(引数名: 引数のタイプ)`
                    - メソッドの引数を定義
                        - ない場合は無理に定義しない
                    - 各`引数`に対して下記を定義
                        - `引数名`
                            - 引数の名前をCamelCaseで定義
                        - `引数のタイプ`
                            - 引数の型を定義
                                - ない場合は`void`とし無理に定義しない。また非同期で戻り値が必要な場合は`Future<[引数のタイプ]>`とする。
                - `戻り値のタイプ`
                    - メソッドの戻り値のタイプを定義
                        - ない場合は`void`とし無理に定義しない。また非同期で戻り値が必要な場合は`Future<[戻り値のタイプ]>`とする。
                    - `戻り値`
                        - 戻り値の型を定義
                - `概要`
                    - メソッドの概要を記載
    - 例：
      ```markdown
      <!-- documents/designs/controller_design.md -->

      ## 購入コントローラー

      ### Controller名

      `PurchaseController`

      ### 概要

      商品をカートに入れ管理し決済まで行うためのコントローラー。

      ### プロパティ

      | プロパティ名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
      | --- | --- | --- | --- | --- |
      | `userId` | String | 必須 |  | コントローラーを利用するユーザーのID。 |

      ### メソッド

      | メソッド名 | 引数(引数名: 引数のタイプ) | 戻り値のタイプ | 概要 |
      | --- | --- | --- | --- |
      | addCart | `product`:`ModelRef<ProductModel>` | `Future<void>` | カートに商品を追加する |
      | removeCart | `product`:`ModelRef<ProductModel>` | `Future<void>` | カートから商品を削除する |
      | getCart | | `Future<List<ModelRef<ProductModel>>>` | カートの商品をすべて取得する。 |
      | checkout | `paymentMethod`:`ModelRef<PaymentMethodModel>`, `address`: `String` | `Future<void>` | 支払い方法および配送先住所を指定し現在のカートの商品を決済する。 |
      ```
2. 作成した`Controller設計書`は`documents/designs/controller_design.md`に保存
""";
  }
}
