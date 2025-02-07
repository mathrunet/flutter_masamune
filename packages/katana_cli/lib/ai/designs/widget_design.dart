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
  String get name => "`Widget設計書`の作成";

  @override
  String get globs => "documents/designs/widget_design.md";

  @override
  String get directory => "designs";

  @override
  String get description => "Masamuneフレームワークによる`Widget設計書`の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[page_design.md](mdc:documents/designs/page_design.md)に記載されている`Page設計書`および[model_design.md](mdc:documents/designs/model_design.md)に記載されている`Model設計書`から`Widget設計書`を作成

1. `Page設計書`において`Widget設計書`を作成
    -下記の条件に当てはまる場合、新しく`Widget`を定義
        - UI要素が2つ以上の`Page`で共通化可能
    - 当てはまらない場合無理に定義しない
    - 下記条件に当てはまる場合は**必ず**除外する
        - 再利用する目的でなくただ複数の`Widget`をまとめるだけの場合
        - フォームなどの入力や選択を行う`Widget`
        - すでにFlutterに該当する`Widget`で代用可能なものが存在する場合
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
    - 各々の`Widget`に対して下記を定義
        - `WidgetName`
            - 末尾に`Widget`はつけない形でPascalCaseで定義
        - `WidgetType`
            - 下記から選択
                - `stateless`
                    - 状態を持たないWidget
                - `stateful`
                    - 状態を持つWidget
                - `model_extension`
                    - `Model`のextensionとして定義。`Model`をそのまま`ListTile`などの`Widget`に変換する場合はこちらで定義。
        - `TargetModel`
            - `WidgetType`が`model_extension`の場合、対応する`Model`の`ModelName`を指定。
        - `Content`
            - `Widget`のUIの内容を記載、箇条書きで可能な限り細かく記載
            - 他の`Widget`を利用する場合はその`Widget`の名前を記載
            - タップしてなにかアクションを起こす場合はそのアクションの内容を記載
        - `Properties`
            - `Widget`に渡すプロパティを定義
                - ない場合は無理に定義しない
                - `WidgetType`が`model_extension`の場合、対応する`Model`のデータはextension内で利用されるためプロパティとして定義しない。
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
    - `Model`のデータをそのまま表示するような`Widget`の場合は必ず`WidgetType`を`model_extension`とする。
    - 例：
      ```markdown
      <!-- documents/designs/widget_design.md -->
        
      ## アプリタイトルAppBar
      
      ### WidgetName
      
      `TitleAppBar`

      ### WidgetType

      `stateless`

      ### TargetModel
      
      `Memo`
      
      ### Content
      
      - アプリタイトルを表示するAppBarWidget
      - 左には戻るボタンを表示
      - 中央にタイトルを表示
        - `title`のプロパティが渡された場合はそのタイトルを表示する。
      
      ### Properties

      | PropertyName | PropertyType | RequiredOrOptional | DefaultValue | Summary |
      | --- | --- | --- | --- | --- |
      | `title` | String | Optional |  | 表示するタイトル。 |

      ## メモタイル
      
      ### WidgetName
      
      `MemoTile`

      ### WidgetType

      `model_extension`

      ### TargetModel
      
      `Memo`
      
      ### Content
      
      - `MemoModel`で定義されているメモのデータを表示するTileWidget。
      - タイトル、メモ内容、作成日時を表示する。
      - 作成日時を小さく表示し、その下にメモ内容を同じ文字の大きさで表示。
      
      ### Properties

      ```
2. 作成した`Widget設計書`は`documents/designs/widget_design.md`に保存
""";
  }
}
