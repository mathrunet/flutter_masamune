// Project imports:
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
  String get globs => "documents/designs/**/*.md";

  @override
  String get directory => "designs";

  @override
  String get description => "`Widget設計`の方法と`Widget設計書`の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[page_design.md](mdc:documents/designs/page_design.md)に記載されている`Page設計書`および[model_design.md](mdc:documents/designs/model_design.md)に記載されている`Model設計書`から`Widget設計書`を作成

1. `Page設計書`と`Model設計書`から`Widget設計書`を作成
    -下記の条件に当てはまる場合、新しく`Widget`を定義
        - UI要素が2つ以上の`Page`で共通化可能
    - 当てはまらない場合無理に定義しない
    - 下記条件に当てはまる場合は**必ず**除外する
        - 再利用する目的でなくただ複数の`Widget`をまとめるだけの場合
        - フォームなどの入力や選択を行う`Widget`
        - すでにFlutterに該当する`Widget`で代用可能なものが存在する場合
        - [`UniversalUI`](mdc:.cursor/rules/docs/universal_ui_usage.mdc)で定義されている`Widget`で代用可能な場合
        - [`KatanaUI`](mdc:.cursor/rules/docs/katana_ui_usage.mdc)で定義されている`Widget`で代用可能な場合
        - [`Modal`](mdc:.cursor/rules/docs/modal_usage.mdc)で定義されている`Widget`で代用可能な場合
        - [`Form`](mdc:.cursor/rules/docs/form_usage.mdc)で定義されている`Widget`で代用可能な場合
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
