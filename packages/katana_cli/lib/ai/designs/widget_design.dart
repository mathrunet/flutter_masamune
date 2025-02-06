import 'package:katana_cli/katana_cli.dart';

/// Contents of widget_design.mdc.
///
/// widget_design.mdcの中身。
class WidgetDesignMdcCliAiCode extends CliAiCode {
  /// Contents of widget_design.mdc.
  ///
  /// widget_design.mdcの中身。
  const WidgetDesignMdcCliAiCode();

  @override
  String get name => "Widget設計書の作成";

  @override
  String get globs => "*.md";

  @override
  String get directory => "designs";

  @override
  String get description => "MasamuneフレームワークによるWidget設計書の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[screen_design.md](mdc:documents/designs/screen_design.md)に記載されている`画面設計書`および[model_design.md](mdc:documents/designs/model_design.md)に記載されている`モデル設計書`から`Widget設計書`を作成

1. `画面設計書`において`Widget設計書`を作成
    -下記の条件に当てはまる場合、新しくWidgetを定義
        - UI要素が2つ以上の画面で共通化可能
    - 当てはまらない場合無理に定義しない
    - 下記条件に当てはまる場合は必ず除外する
        - 再利用する目的でなくただ複数のWidgetをまとめるだけの場合
        - フォームなどの入力や選択を行うWidget
        - すでにFlutterに該当するWidgetで代用可能なものが存在する場合
        - Masamuneフレームワークで定義されている下記UniversalWidgetで代用可能な場合
            - `UniversalScaffold`
                - Flutter標準の`Scaffold`に下記機能が追加されたもの
                    - SliverWidgetへの変換
                    - PaddingやContainerを内蔵し`Scaffold`の外側に余白やボーダー、透明背景を設定可能
                    - loadingFuturesを設定可能で非同期処理のローディングを表示可能
            - `UniversalAppBar`
                - Flutter標準の`AppBar`に下記機能が追加されたもの
                    - `UniversalScaffold`と連携しSliverWidgetへの変換
            - `UniversalListView`
                - Flutter標準の`ListView`に下記機能が追加されたもの
                    - `UniversalScaffold`と連携しSliverWidgetへの変換
                    - onRefreshを設定可能でリストの更新を可能にする
                    - onLoadNextを設定可能でリストの追加読み込みを可能にする
                    - paddingやdecorationを設定可能でリストの外側に余白やボーダーを設定可能
            - `UniversalColumn`
                - Flutter標準の`Column`に下記機能が追加されたもの
                    - `UniversalScaffold`と連携しSliverWidgetへの変換
                    - paddingやdecorationを設定可能でリストの外側に余白やボーダーを設定可能
            - `UniversalContainer`
                - Flutter標準の`Container`に下記機能が追加されたもの
                    - `UniversalScaffold`と連携しSliverWidgetへの変換
        - Masamuneフレームワークで定義されている下記フォームWidgetで代用可能な場合
            - `FormButton`
                - Flutter標準の`Button`からMasamuneフレームワーク用にインターフェースを統一したもの
            - `FormCheckbox`
                - Flutter標準の`CheckBoxForm`からMasamuneフレームワーク用にインターフェースを統一したもの
            - `FormChipsField`
                - テキスト入力をChipとして表示し、文字のリストとして保存可能なフォーム。タグの入力等に利用。
            - `FormDateField`
                - 日付の入力が可能なフォーム。
            - `FormDateTimeField`
                - 日時の入力が可能なフォーム。
            - `FormDateTimeRangeField`
                - 日付の範囲を選択可能なフォーム。
            - `FormDurationField`
                - 時間の入力が可能なフォーム。
            - `FormEditableToggleBuilder`
                - 他のフォームをbuilderに含めることで編集可能な状態と編集不可能な状態を切り替えることが可能なフォーム。
            - `FormEnumDropdownField`
                - 列挙体の選択がドロップダウン形式で可能なフォーム。
            - `FormEnumField`
                - 列挙体の選択がボトムシートの選択肢から可能なフォーム。
            - `FormFocusNodeBuilder`
                - builderに他のフォームを含めることでこのWidget内で閉じたFocusNodeを利用可能にするフォーム。
            - `FormFutureField`
                - なにかしらの非同期処理を挟み、その結果を保存するためのフォーム。別ページを作成してそれを選択フォームとするような場合に利用。
            - `FormLabel`
                - フォームのUIを表示する際にラベルを表示するフォーム。
            - `FormListBuilder`
                - 複数のフォームをリスト表示し要素の追加削除が可能なフォームを作成するためのフォーム。
            - `FormMapDropdownField`
                - 連想配列の選択がドロップダウン形式で可能なフォーム。
            - `FormMapField`
                - 連想配列の選択がボトムシートの選択肢から可能なフォーム。
            - `FormMapTagDropdownField`
                - 連想配列の選択および、その追加、削除、ラベルの編集がドロップダウン形式で可能なフォーム。可変のタグを選択する場合に利用可能。
            - `FormMedia`
                - 画像や映像を保存するためのフォーム。
            - `FormMonthField`
                - 月の入力が可能なフォーム。
            - `FormNumField`
                - 数値の選択がボトムシートの選択肢から可能なフォーム。
            - `FormPasswordBuilder`
                - FormTextFieldと組み合わせることでパスワードの入力およびその表示非表示の切り替えが可能なフォーム。
            - `FormPinField`
                - ピン番号の入力が可能なフォーム。
            - `FormRatingBar`
                - 評価の選択が可能なフォーム。
            - `FormStyleContainer`
                - Masamuneフレームワークのフォームで利用するFormStyleを適用可能なContainer。
            - `FormSwitch`
                - Flutter標準の`Switch`からMasamuneフレームワーク用にインターフェースを統一したもの
            - `FormTextEditingControllerBuilder`
                - builderに他のフォームを含めることでこのWidget内で閉じたTextEditingControllerを利用可能にするフォーム。
            - `FormTextField`
                - Flutter標準の`TextField`からMasamuneフレームワーク用にインターフェースを統一したもの
        - Masamuneフレームワークで定義されている下記ダイアログで代用可能な場合
            - `Modal.alert`
                - タイトル、メッセージ、１つのアクション（閉じる等）を設定可能なダイアログ。
            - `Modal.confirm`
                - タイトル、メッセージ、２つのアクション（決定、キャンセル等）を設定可能なダイアログ。
    - 各々のWidgetに対して定義
        - `Widget名`
            - 末尾にWidgetはつけない形でPascalCaseで定義
        - `Widgetタイプ`
            - 下記から選択
                - `stateless`
                    - 状態を持たないWidget
                - `stateful`
                    - 状態を持つWidget
                - `model_extension`
                    - `モデル`のextensionとして定義。`モデル`をそのままListTileなどのWidgetに変換する場合はこちらで定義。
        - `対象モデル`
            - `Widgetタイプ`が`model_extension`の場合、対応するモデルの`モデル名`を指定。
        - `内容`
            - WidgetのUIの内容を記載、箇条書きで可能な限り細かく記載
            - 他のWidgetを利用する場合はそのWidgetの名前を記載
            - タップしてなにかアクションを起こす場合はそのアクションの内容を記載
        - `プロパティ`
            - Widgetに渡すプロパティを定義
                - ない場合は無理に定義しない
                - `Widgetタイプ`が`model_extension`の場合、対応する`モデル`のデータはextension内で利用されるためプロパティとして定義しない。
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
                - `必須かどうか`
                    - `必須`もしくは`任意`
                - `デフォルト値`
                    - `任意`の場合入力されなかった場合のデフォルトの値 
                - `概要`
                    - プロパティの概要
    - モデルのデータをそのまま表示するようなWidgetの場合は必ず`Widgetタイプ`を`model_extension`とする。
    - 例：
      ```markdown
      <!-- documents/designs/widget_design.md -->
        
      ## アプリタイトルAppBar
      
      ### Widget名
      
      `TitleAppBar`

      ### Widgetタイプ

      `stateless`

      ### 対象モデル
      
      ### 概要
      
      - アプリタイトルを表示するAppBarWidget
      - 左には戻るボタンを表示
      - 中央にタイトルを表示
        - `title`のプロパティが渡された場合はそのタイトルを表示する。
      
      ### プロパティ

      | プロパティ名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
      | --- | --- | --- | --- | --- |
      | `title` | String | 任意 |  | 表示するタイトル。 |

      ## メモタイル
      
      ### Widget名
      
      `MemoTile`

      ### Widgetタイプ

      `model_extension`

      ### 対象モデル
      
      `Memo`
      
      ### 概要
      
      - `MemoModel`で定義されているメモのデータを表示するTileWidget。
      - タイトル、メモ内容、作成日時を表示する。
      - 作成日時を小さく表示し、その下にメモ内容を同じ文字の大きさで表示。
      
      ### プロパティ

      ```
2. 作成した`Widget設計書`は`documents/designs/widget_design.md`に保存
""";
  }
}
